//
//  Transaction.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftData

@Model
class Transaction {
    var addedDate: Date
    var modifiedDate: Date?
    var title: String
    var amountCents: Int
    var type: TransactionType
    var category: BudgetCategory
    var month: Month
    
    @Relationship(deleteRule: .cascade, inverse: \IncomeAllocation.transaction)
    var incomeAllocations: [IncomeAllocation]? = nil
    
    // TrenteVingt+
    var note: String? = nil
    var photoAttachmentURL: URL? = nil
    
    var isDeleted: Bool = false
    
    init(addedDate: Date, title: String, amountCents: Int, type: TransactionType, category: BudgetCategory, month: Month) {
        self.addedDate = addedDate
        self.title = title
        self.amountCents = amountCents
        self.type = type
        self.category = category
        self.month = month
    }
}

enum TransactionType: String, Codable {
    case expense
    case income
}

extension Transaction {
    var amount : Double {
        Double(amountCents) / 100
    }
}

// MARK: - Sample Data
extension Transaction {
    static let sampleData: [Transaction] = [
        Transaction(
            addedDate: Date(),
            title: "Supermarket",
            amountCents: -50_00,
            type: .expense,
            category: .needs,
            month: Month.month1
        ),
        Transaction(
            addedDate: Date(),
            title: "Salary",
            amountCents: 1500_00,
            type: .income,
            category: .needs,
            month: Month.month1
        ),
        Transaction(
            addedDate: Date(),
            title: "Rent",
            amountCents: -800_00,
            type: .expense,
            category: .needs,
            month: Month.month2
        )
    ]
}
