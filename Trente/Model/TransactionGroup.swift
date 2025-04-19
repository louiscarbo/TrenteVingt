//
//  Transaction.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftData

@Model
class TransactionGroup {
    var addedDate: Date
    var modifiedDate: Date?
    var title: String
    var type: TransactionType
    var month: Month
    var isDeleted: Bool = false

    
    @Relationship(deleteRule: .cascade, inverse: \TransactionEntry.group)
    var entries: [TransactionEntry] = []
    
    // TrenteVingt+
    var note: String? = nil
    var photoAttachmentURL: URL? = nil
    
    init(addedDate: Date, title: String, type: TransactionType, month: Month) {
        self.addedDate = addedDate
        self.title = title
        self.type = type
        self.month = month
    }
}

enum TransactionType: String, Codable {
    case expense
    case income
}

extension TransactionGroup {
    /// The total amount of all entries in cents. Can be negative or positive.
    var totalAmountCents: Int {
        entries.reduce(0) { $0 + $1.amountCents }
    }
    
    /// Returns a localized string that displays the amount correctly, not in cents.
    var displayAmount: String {
        (Double(totalAmountCents) / 100.0)
            .formatted(.currency(code: month.currency.isoCode))
    }
}

// MARK: - Sample Data
extension TransactionGroup {
    static func sampleData(month1: Month, month2: Month) -> [TransactionGroup] {
        // Expenses
        let supermarket = TransactionGroup(
            addedDate: Date(),
            title: "Supermarket",
            type: .expense,
            month: month1
        )
        let shopping = TransactionGroup(
            addedDate: Date(),
            title: "Shopping",
            type: .expense,
            month: month1
        )
        let livretA = TransactionGroup(
            addedDate: Date(),
            title: "Livret A",
            type: .expense,
            month: month1
        )
        let rent = TransactionGroup(
            addedDate: Date(),
            title: "Rent",
            type: .expense,
            month: month2
        )

        supermarket.entries = [
            TransactionEntry(amountCents: -150_00, category: .needs, group: supermarket)
        ]
        shopping.entries = [
            TransactionEntry(amountCents: -120_00, category: .wants, group: shopping)
        ]
        livretA.entries = [
            TransactionEntry(amountCents: -100_00, category: .savingsAndDebts, group: livretA)
        ]
        rent.entries = [
            TransactionEntry(amountCents: -800_00, category: .needs, group: rent)
        ]

        // Income (grouped under one transaction group)
        let salary = TransactionGroup(
            addedDate: Date(),
            title: "Salary",
            type: .income,
            month: month1
        )

        salary.entries = [
            TransactionEntry(amountCents: 40_00, category: .needs, group: salary),
            TransactionEntry(amountCents: 300_00, category: .wants, group: salary),
            TransactionEntry(amountCents: 200_00, category: .savingsAndDebts, group: salary)
        ]

        return [supermarket, shopping, livretA, salary, rent]
    }
}
