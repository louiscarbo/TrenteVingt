import SwiftUI
import WidgetKit

struct TransactionRowView: View {
    @State private var showEditSheet: Bool = false
    @Environment(\.modelContext) private var modelContext
    
    @State var transaction: Transaction
    @State var currency: Currency
    @State var associatedRecurringTransaction: RecurringTransaction?
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10)
                .foregroundStyle(transaction.categoryColor)
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text(getCategoryDesignation(category: transaction.category))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(transaction.amount.formatted(.currency(code: currency.code).presentation(.narrow).grouping(.automatic)))")
                    .font(.system(.title, design: .serif, weight: .semibold))
            }
        }
        .onTapGesture {
            showEditSheet = true
        }
        .sheet(isPresented: $showEditSheet) {
            if let recurringTransaction = associatedRecurringTransaction {
                RecurringTransactionDetailView(recurringTransaction: recurringTransaction)
            } else {
                NavigationStack {
                    Form {
                        TransactionDetailView(transaction: transaction)
                            .presentationDetents([.medium, .large])
                    }
                }
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                withAnimation {
                    modelContext.delete(transaction)
                    if let recurringTransaction = transaction.recurringTransaction {
                        NotificationHandler.shared.cancelRecurringTransactionNotification(completion: {}, recurringTransaction: recurringTransaction)
                        modelContext.delete(recurringTransaction)
                    }
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } label: {
                Label("Delete", systemImage: "trash")
                    .symbolVariant(.fill)
            }
            Button {
                showEditSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.orange)
        }
    }
}

func getCategoryDesignation(category: transactionCategory) -> String {
    switch category {
    case .needs: return String(localized: "Needs")
    case .wants: return String(localized: "Wants")
    case .savingsDebts: return String(localized: "Savings & Debts")
    default: return String(localized: "Positive Transaction")
    }
}

/*
#Preview {
    TransactionRowView()
}
*/
