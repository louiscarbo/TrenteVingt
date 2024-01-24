//
//  RecurrentTransactionRowView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 22/01/2024.
//

import SwiftUI
import WidgetKit

struct RecurringTransactionRowView: View {
    @State var monthBudget: MonthBudget
    @State var recurringTransaction: RecurringTransaction
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showConfirmAlert = false
    @State private var recurrenceDescriptor: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let transaction = recurringTransaction.transaction {
                TransactionRowView(
                    transaction: transaction,
                    currency: monthBudget.currency,
                    associatedRecurringTransaction: recurringTransaction
                )
                HStack {
                    Spacer()
                        .frame(width: 18)
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text(recurrenceDescriptor)
                    }
                    .padding(5)
                    .font(.callout)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(Color(UIColor.systemGray5))
                    )
                }
            } else {
                Text("didn't find transaction :(")
            }
        }
        .onAppear {
            let recurrenceDetails = recurringTransaction.recurrenceDetails
            switch(recurringTransaction.recurrenceDetails.recurrenceType) {
            case .weekly:
                recurrenceDescriptor = String(localized: "Every \(getDayOfWeek(from: recurrenceDetails.day ?? 1))")
            case .monthly:
                recurrenceDescriptor = String(localized: "Every \(ordinalString(from: recurrenceDetails.day ?? 1)) day of the month")
            case .yearly:
                recurrenceDescriptor = String(localized: "Every \(getDateName(date: recurrenceDetails.startingDate ?? Date()))")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                withAnimation {
                    showConfirmAlert.toggle()
                }
            } label: {
                Label("Confirm", systemImage: "checkmark")
                    .symbolVariant(.fill)
                    .tint(.green)
            }
        }
        .confirmationDialog(
            Text("Validating this transaction will add it as a transaction to the current month. Do you want to add it?"),
            isPresented: $showConfirmAlert,
            titleVisibility: .visible
        ) {
            Button("Yes, add") {
                withAnimation {
                    if let transaction = recurringTransaction.transaction {
                        let newTransaction = Transaction(title: transaction.title, amount: transaction.amount, category: transaction.category)
                        newTransaction.monthBudget = monthBudget
                        modelContext.insert(newTransaction)
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
            }
        }
    }
}

func getDateName(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
    return dateFormatter.string(from: date)
}

func ordinalString(from number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .ordinal
    return numberFormatter.string(from: NSNumber(value: number)) ?? ""
}

//#Preview {
//    RecurringTransactionRowView()
//}
