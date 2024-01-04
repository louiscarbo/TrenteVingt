import SwiftUI
import SwiftData

enum SortBy: String, CaseIterable {
    case date, title, amount
    
    var displayName: String {
        switch self {
        case .date:
            return String(localized: "Added Date")
        case .title:
            return String(localized: "Title")
        case .amount:
            return String(localized: "Amount")
        }
    }
}

enum FilterBy: String, CaseIterable {
    case needs, wants, savingsAndDebts, positiveTransactions
    
    var displayName: String {
        switch self {
        case.needs : return String(localized: "Needs")
        case .wants: return String(localized: "Wants")
        case .savingsAndDebts: return String(localized: "Savings and debts")
        case .positiveTransactions: return String(localized: "Positive transactions")
        }
    }
    
    var color: Color {
        switch self {
        case.needs : return .blue
        case .wants: return .yellow
        case .savingsAndDebts: return .green
        case .positiveTransactions: return .red
        }
    }
}

struct AllTransactionsListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    @State var transactions: [Transaction]
    @State var currency: Currency
    
    @State private var searchText = ""
    @State private var sortBy: SortBy = .date
    @State private var fromAToZ: Bool = true
    @State private var showFilter: Bool = false
    @State private var showSearchBar: Bool = false
    
    @State private var filterStates: [FilterBy: Bool] = [
        .needs: true,
        .wants: true,
        .savingsAndDebts: true,
        .positiveTransactions: true
    ]
    
    var sortDescriptor: (Transaction, Transaction) -> Bool {
        switch sortBy {
        case .date:
            return fromAToZ ? { $0.addedDate > $1.addedDate } : { $0.addedDate < $1.addedDate }
        case .title:
            return fromAToZ ? { $0.title < $1.title } : { $0.title > $1.title }
        case .amount:
            return fromAToZ ? { $0.amount < $1.amount } : { $0.amount > $1.amount }
        }
    }
    
    var filterDescriptor: (Transaction) -> Bool {
        { transaction in
            if filterStates[.needs] == true, transaction.category == .needs {
                return true
            }
            
            if filterStates[.wants] == true, transaction.category == .wants {
                return true
            }
            
            if filterStates[.savingsAndDebts] == true, transaction.category == .savingsDebts {
                return true
            }
            
            if filterStates[.positiveTransactions] == true, transaction.category == .positiveTransaction {
                return true
            }

            return false
        }
    }

    var transactionsDisplayedInList: [Transaction] {
        guard !searchText.isEmpty else {
            return transactions
                .filter(filterDescriptor)
                .sorted(by: sortDescriptor)
        }
        
        return transactions
            .filter(filterDescriptor)
            .filter {
                let amountWithPeriod = String($0.amount)
                let amountWithComma = amountWithPeriod.replacingOccurrences(of: ".", with: ",")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE d MMMM yyyy"
                let fullDateWithDayName = dateFormatter.string(from: $0.addedDate)
                
                return $0.title.localizedCaseInsensitiveContains(searchText) ||
                amountWithPeriod.contains(searchText) ||
                amountWithComma.contains(searchText) ||
                fullDateWithDayName.localizedCaseInsensitiveContains(searchText)
            }
            .sorted(by: sortDescriptor)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(transactionsDisplayedInList, id: \.id) { transaction in
                    TransactionRowView(transaction: transaction, currency: currency)
                }
                if transactionsDisplayedInList.count == 0 {
                    Text("Your search didn't give any results. Try to use other keywords or filters.")
                } else {
                    let totalAmount = transactionsDisplayedInList.reduce(0, { $0 + $1.amount })
                    Section {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total amount")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                Text("Sum of all displayed transactions")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(totalAmount.formatted(.currency(code: currency.code).presentation(.narrow).grouping(.automatic)))")
                                .font(.system(.title, design: .serif, weight: .semibold))
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .searchable(text: $searchText, isPresented: $showSearchBar ,prompt: Text("Search by title, amount, date..."))
            .toolbar {
                ToolbarItem {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Text("Sort by")
                        Section {
                            SortByButton(sortBy: $sortBy, fromAToZ: $fromAToZ, sortByCase: .date)
                            SortByButton(sortBy: $sortBy, fromAToZ: $fromAToZ, sortByCase: .amount)
                            SortByButton(sortBy: $sortBy, fromAToZ: $fromAToZ, sortByCase: .title)
                        }
                    }
                    .tint(colorScheme == .light ? Color(.black) : Color(.white))
                }
                ToolbarItem {
                    Button {
                        showFilter.toggle()
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                    }
                    .sheet(isPresented: $showFilter) {
                        FilteringSheet(filteringDictionnary: $filterStates)
                            .presentationDetents([.medium, .large])
                    }
                    .tint(colorScheme == .light ? Color(.black) : Color(.white))
                }
                ToolbarItem {
                    Button {
                        showSearchBar = true
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tint(colorScheme == .light ? Color(.black) : Color(.white))
                }
            }
        }
    }
}

private struct SortByButton: View {
    @Binding var sortBy: SortBy
    @Binding var fromAToZ: Bool
    let sortByCase: SortBy
    
    var body: some View {
        Button {
            if sortBy == sortByCase {
                fromAToZ.toggle()
            } else {
                fromAToZ = true
                sortBy = sortByCase
            }
        } label: {
            if sortBy == sortByCase {
                Label(sortByCase.displayName, systemImage: fromAToZ ? "chevron.up" : "chevron.down")
            } else {
                Text(sortByCase.displayName)
            }
        }
    }
}

private struct FilterByToggle: View {
    let filterByCase: FilterBy
    
    @Binding var showCategory: Bool?
    
    @State private var showCategoryLocal: Bool = true
    
    var body: some View {
        Toggle("\(filterByCase.displayName)", isOn: $showCategoryLocal)
            .toggleStyle(CheckToggleStyle(color: filterByCase.color))
            .onAppear {
                showCategoryLocal = showCategory ?? true
            }
            .onChange(of: showCategoryLocal) {
                showCategory = showCategoryLocal
            }
            .sensoryFeedback(.impact, trigger: showCategoryLocal)
    }
    
    struct CheckToggleStyle: ToggleStyle {
        let color: Color
        
        func makeBody(configuration: Configuration) -> some View {
            Button {
                configuration.isOn.toggle()
            } label: {
                Label {
                    configuration.label
                } icon: {
                    Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(color)
                        .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                        .imageScale(.large)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

private struct FilteringSheet: View {
    @Binding var filteringDictionnary: [FilterBy: Bool]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Categories") {
                    ForEach(FilterBy.allCases, id: \.self) { filterByCase in
                        FilterByToggle(filterByCase: filterByCase, showCategory: $filteringDictionnary[filterByCase])
                    }
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


/*
#Preview {
    AllTransactionsListView()
}
*/
