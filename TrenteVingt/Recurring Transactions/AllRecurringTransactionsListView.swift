import SwiftUI
import SwiftData

struct AllRecurringTransactionsListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    @State var recurringTransactions: [RecurringTransaction]
    @State var monthBudget: MonthBudget
    
    private var recurringTransactionsDisplayedInList: [RecurringTransaction] {
        recurringTransactions.sorted(by: { return $0.nextRecurrenceDate < $1.nextRecurrenceDate })
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(recurringTransactionsDisplayedInList, id: \.id) { recurringTransaction in
                    RecurringTransactionRowView(monthBudget: monthBudget, recurringTransaction: recurringTransaction)
                }
                let totalAmount = recurringTransactionsDisplayedInList.reduce(0, { $0 + ($1.transaction?.amount ?? 0) })
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
                        Text("\(totalAmount.formatted(.currency(code: monthBudget.currency.code).presentation(.narrow).grouping(.automatic)))")
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
