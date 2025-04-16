//
//  RecurringTransactionInstance.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftData

@Model
class RecurringTransactionInstance {
    var date: Date
    var rule: RecurringTransactionRule
    var month: Month
    var confirmed: Bool = false
    
    init(date: Date, rule: RecurringTransactionRule, month: Month, confirmed: Bool) {
        self.date = date
        self.rule = rule
        self.month = month
        self.confirmed = confirmed
    }
}
