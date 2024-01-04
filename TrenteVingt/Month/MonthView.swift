import SwiftUI
import SwiftData

struct MonthView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var monthBudget: MonthBudget
    @State var showSettings = false
    @State private var isPresentingNewMonthView = false
    @State var showNewTransaction = false
    
    private var transactionsDisplayedInList: [Transaction] {
        if let transactions = monthBudget.transactions {
            return Array(transactions.sorted { $0.addedDate > $1.addedDate }.prefix(5))
        } else {
            return [Transaction]()
        }
    }
    @State private var showRemaining = true
    @State private var updateCharts = false
    @State private var shouldDismiss = false
    @State private var navigateToAllTransactions = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                if let transactions = monthBudget.transactions {
                    List {
                        ChartView(monthBudget: monthBudget, showRemaining: $showRemaining)
                            .listRowBackground(Color(.clear))
                            .id(updateCharts)
                            .onChange(of: monthBudget.transactions) {
                                updateCharts.toggle()
                            }
                        Section {
                            ChartLegendView(monthBudget: monthBudget, showRemaining: $showRemaining)
                        }
                        if transactions.count > 0 {
                            Section("Transactions") {
                                ForEach(transactionsDisplayedInList) { transaction in
                                    TransactionRowView(transaction: transaction, currency: monthBudget.currency)
                                }
                                if let transactions = monthBudget.transactions {
                                    NavigationLink(destination: AllTransactionsListView(transactions: transactions, currency: monthBudget.currency)) {
                                        Text("Show all transactions")
                                    }
                                }
                            }
                        } else {
                            Section {
                                Text("Add your first transaction now and see how your budget evolves!")
                            }
                        }
                        Text("")
                            .listRowBackground(Color(.clear))
                    }
                } else {
                    Text("Add your first transaction now!")
                }
            }
            .onChange(of: shouldDismiss) {
                dismiss()
            }
            .navigationTitle(monthBudget.monthDesignation)
            .onOpenURL { url in
                guard
                    url.scheme == "trentevingt",
                    url.host == "newtransaction"
                else {
                    return
                }
                showNewTransaction = true
            }
            ZStack(alignment: .bottom) {
                if let transactions = monthBudget.transactions {
                    if !transactions.isEmpty {
                        LinearGradient(gradient: Gradient(colors: [.clear, colorScheme == .light ? .white : .black]), startPoint: .top, endPoint: .bottom)
                            .frame(height: 150)
                            .allowsHitTesting(false)
                    }
                }
                Button {
                    showNewTransaction = true
                } label: {
                    Label("Add transaction", systemImage: "plus")
                        .foregroundStyle(colorScheme == .light ? .white : .black)
                        .font(.system(.title2, design: .serif, weight: .semibold))
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .tint(colorScheme == .light ? Color(.black) : Color(.white))
                .padding(.bottom, 30)
                .sheet(isPresented: $showNewTransaction, content: {
                    NewTransactionView(currentMonthBudget: monthBudget)
                })
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .toolbar {
            ToolbarItem {
                Button {
                    showSettings = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .tint(colorScheme == .light ? Color(.black) : Color(.systemGray6))
                .navigationDestination(isPresented: $showSettings) {
                    NavigationStack {
                        MonthDetailsView(monthBudget: monthBudget, isPresenting: $showSettings, isInSettings: true, shouldDismiss: $shouldDismiss)
                        .navigationTitle(monthBudget.monthDesignation)
                    }
                }
            }
        }
    }
}

func newMonthNumber(oldMonthNumber: Int) -> Int {
    let newMonthNumber = oldMonthNumber + 1
    return newMonthNumber % 12 == 0 ? 12 : newMonthNumber % 12
}

/*
#Preview {
    MonthView()
}
*/
