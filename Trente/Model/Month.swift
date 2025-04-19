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
    
    var categoryRepartition: [BudgetCategory: Int] // Amount in cents for each category

    @Relationship(deleteRule: .cascade, inverse: \TransactionGroup.month)
    var transactionGroups: [TransactionGroup] = []

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
    var name: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: startDate).capitalized
    }
    
    private var transactionEntries: [TransactionEntry] {
        transactionGroups.flatMap { $0.entries }
    }
        
    private var remainingAmountCents: Int {
        transactionEntries.reduce(0) { $0 + $1.amountCents }
    }
    
    private var spentAmountCents: Int {
        transactionEntries.filter { $0.amountCents < 0 }.reduce(0) { $0 + $1.amountCents }
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
    
    /// Calculates the remaining budget for a specific category. Not in cents, positive value.
    func spentAmount(for category: BudgetCategory) -> Double {
        let categoryTransactions = transactionEntries.filter { $0.category == category && $0.amountCents < 0 }
        let categoryRemainingAmount = categoryTransactions.reduce(0) { $0 + $1.amountCents }
        return -1 * Double(categoryRemainingAmount) / 100
    }
    
    /// Calculates the sum of incomes for a specific category. Not in cents.
    func incomeAmount(for category: BudgetCategory) -> Double {
        let categoryTransactions = transactionEntries.filter { $0.category == category && $0.amountCents > 0 }
        let categoryIncomeAmount = categoryTransactions.reduce(0) { $0 + $1.amountCents }
        return Double(categoryIncomeAmount) / 100
    }
    
    /// Calculates the budget that is overspent for a specific category. Not in cents, positive value.
    func overSpentAmount(for category: BudgetCategory) -> Double {
        return -1 * (incomeAmount(for: category) - spentAmount(for: category))
    }
    
    /// Returns true if the user is overspending in a specific category
    func overSpending(in category: BudgetCategory) -> Bool {
        overSpentAmount(for: category) > 0
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
