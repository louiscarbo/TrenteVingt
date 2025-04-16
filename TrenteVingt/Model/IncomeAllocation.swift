//
//  IncomeAllocation.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftData

@Model
class IncomeAllocation {
    var amountCents: Int
    var category: BudgetCategory
    var transaction: Transaction
    
    init(amountCents: Int, category: BudgetCategory, transaction: Transaction) {
        self.amountCents = amountCents
        self.category = category
        self.transaction = transaction
    }
}
