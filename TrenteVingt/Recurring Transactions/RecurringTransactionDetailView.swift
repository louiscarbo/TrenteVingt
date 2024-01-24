//
//  RecurringTransactionDetailView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 24/01/2024.
//

import SwiftUI

struct RecurringTransactionDetailView: View {
    @Bindable var recurringTransaction: RecurringTransaction
    
    @State private var recurrenceType: RecurrenceType = RecurrenceType.monthly
    @State private var day: Int = 1
    @State private var startingDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                if let transaction = recurringTransaction.transaction {
                    TransactionDetailView(transaction: transaction)
                }
                Section {
                    RecurrenceTypePicker(selectedRecurrenceType: $recurrenceType)
                }
                Section {
                    RecurrenceDetailsPicker(
                        recurrenceType: $recurrenceType,
                        day: $day,
                        startingDate: $startingDate
                    )
                }
            }
            .onAppear {
                recurrenceType = recurringTransaction.recurrenceDetails.recurrenceType
                if let day = recurringTransaction.recurrenceDetails.day {
                    self.day = day
                }
                if let startingDate = recurringTransaction.recurrenceDetails.startingDate {
                    self.startingDate = startingDate
                }
            }
            .onChange(of: recurrenceType) {
                recurringTransaction.recurrenceDetails.recurrenceType = recurrenceType
            }
            .onChange(of: day) {
                recurringTransaction.recurrenceDetails.day = day
            }
            .onChange(of: startingDate) {
                recurringTransaction.recurrenceDetails.startingDate = startingDate
            }
        }
    }
}

//#Preview {
//    RecurringTransactionDetailView()
//}
