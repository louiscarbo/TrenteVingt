import SwiftUI
import SwiftData

struct AllRecurringTransactionsListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    @State var recurringTransactions: [RecurringTransaction]
    @State var currency: Currency
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(recurringTransactions, id: \.id) { recurringTransaction in
                    RecurringTransactionRowView(currency: currency, recurringTransaction: recurringTransaction)
                }
                let totalAmount = recurringTransactions.reduce(0, { $0 + ($1.transaction?.amount ?? 0) })
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total amount")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            Text("Sum of all recurring transactions")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(totalAmount.formatted(.currency(code: currency.code).presentation(.narrow).grouping(.automatic)))")
                            .font(.system(.title, design: .serif, weight: .semibold))
                    }
                }
            }
            .navigationTitle("Transactions")
        }
    }
}

/*
#Preview {
    AllTransactionsListView()
}
*/
