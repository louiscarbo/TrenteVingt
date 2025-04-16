//
//  Month.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftData

@Model
final class Month {
    var startDate: Date
    var availableIncomeCents: Int
    var currency: Currency
    
    var categoryRepartition: [BudgetCategory: Int] // Percentages, sum to 100

    @Relationship(deleteRule: .cascade, inverse: \Transaction.month)
    var transactions: [Transaction] = []

    @Relationship(deleteRule: .cascade, inverse: \RecurringTransactionInstance.month)
    var recurringInstances: [RecurringTransactionInstance] = []

    var isDeleted: Bool = false
    
    init(startDate: Date, availableIncomeCents: Int, currency: Currency, categoryRepartition: [BudgetCategory: Int]) {
        self.startDate = startDate
        self.availableIncomeCents = availableIncomeCents
        self.currency = currency
        self.categoryRepartition = categoryRepartition
    }
}
