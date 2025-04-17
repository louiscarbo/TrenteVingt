//
//  Month.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import Foundation
import SwiftData

@Model
final class Month : Identifiable, Hashable {
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

// MARK: - Computed Properties
extension Month {
    var displayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: startDate).capitalized
    }
        
    private var remainingAmountCents: Int {
        transactions.reduce(0) { $0 + $1.amountCents }
    }
    
    private var spentAmountCents: Int {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amountCents }
    }
    
    var remainingAmount: Double {
        Double(remainingAmountCents) / 100
    }
    
    var negativeSpentAmount: Double {
        Double(spentAmountCents) / 100
    }
    
    var overSpent : Bool {
        remainingAmountCents < 0
    }
    
}

// MARK: - Sample Data
extension Month {
    static let month1 = Month(
        startDate: Date(),
        availableIncomeCents: 1600_00,
        currency: Currencies.currency(for: "EUR")!,
        categoryRepartition: [
            .needs: 50,
            .wants: 30,
            .savingsAndDebts: 20
        ]
    )
    
    static let month2 = Month(
        startDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
        availableIncomeCents: 1600_00,
        currency: Currencies.currency(for: "EUR")!,
        categoryRepartition: [
            .needs: 50,
            .wants: 30,
            .savingsAndDebts: 20
        ]
    )
    
    static let month3 = Month(
        startDate: Calendar.current.date(byAdding: .month, value: -2, to: Date())!,
        availableIncomeCents: 1600_00,
        currency: Currencies.currency(for: "EUR")!,
        categoryRepartition: [
            .needs: 50,
            .wants: 30,
            .savingsAndDebts: 20
        ]
    )
    
    static let sampleData: [Month] = [
        month1,
        month2,
        month3
    ]
}
