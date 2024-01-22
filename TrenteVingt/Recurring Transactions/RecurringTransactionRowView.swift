//
//  RecurrentTransactionRowView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 22/01/2024.
//

import SwiftUI

struct RecurringTransactionRowView: View {
    @State var currency: Currency
    @State var recurringTransaction: RecurringTransaction
    
    @State private var recurrenceDescriptor: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let transaction = recurringTransaction.transaction {
                TransactionRowView(
                    transaction: transaction,
                    currency: currency)
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
                recurrenceDescriptor = "Every \(getDayOfWeek(from: recurrenceDetails.day ?? 1))"
            case .monthly:
                recurrenceDescriptor = "Every \(recurrenceDetails.day ?? 1)th day of the month"
            case .yearly:
                recurrenceDescriptor = "Every \(getDateName(date: recurrenceDetails.startingDate ?? Date()))"
            }
        }
    }
}

func getDateName(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .long
    dateFormatter.locale = Locale.current
    dateFormatter.doesRelativeDateFormatting = false
    return dateFormatter.string(from: date)
}

//#Preview {
//    RecurringTransactionRowView()
//}
