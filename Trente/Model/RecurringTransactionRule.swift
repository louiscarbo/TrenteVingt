//
//  RecurringTransactionRule.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftData

@Model
class RecurringTransactionRule {
    var title: String
    var amountCents: Int
    var category: BudgetCategory
    var frequency: RecurrenceFrequency
    var startDate: Date
    var autoConfirm: Bool = false
    
    @Relationship(deleteRule: .cascade, inverse: \RecurringTransactionInstance.rule)
    var instances: [RecurringTransactionInstance] = []

    var isDeleted: Bool = false
    
    init(title: String, amountCents: Int, category: BudgetCategory, frequency: RecurrenceFrequency, startDate: Date) {
        self.title = title
        self.amountCents = amountCents
        self.category = category
        self.frequency = frequency
        self.startDate = startDate
    }
}

enum RecurrenceFrequency: String, Codable, CaseIterable {
    case weekly, monthly, yearly
}
