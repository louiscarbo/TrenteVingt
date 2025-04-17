//
//  MonthTests.swift
//  TrenteTests
//
//  Created by Louis Carbo Estaque on 17/04/2025.
//

import Testing
@testable import Trente

struct MonthTests {

    @Test
    func testSpentAmount() {
        let month = Month(
            startDate: .now,
            availableIncomeCents: 1000_00,
            currency: Currencies.currency(for: "EUR")!,
            categoryRepartition: [.needs: 50, .wants: 30, .savingsAndDebts: 20]
        )
        
        // Add expenses
        month.transactions = [
            Transaction(
                addedDate: .now,
                title: "Groceries",
                amountCents: -100_00,
                type: .expense,
                category: BudgetCategory.needs,
                month: month
            ),
            Transaction(
                addedDate: .now,
                title: "Rent",
                amountCents: -400_00,
                type: .expense,
                category: BudgetCategory.needs,
                month: month
            )
        ]
        
        #expect(month.negativeSpentAmount == -500.0)
    }

    @Test
    func testRemainingAmount() {
        let month = Month(
            startDate: .now,
            availableIncomeCents: 1000_00,
            currency: Currencies.currency(for: "EUR")!,
            categoryRepartition: [.needs: 50, .wants: 30, .savingsAndDebts: 20]
        )
        
        // One income, two expenses
        month.transactions = [
            Transaction(
                addedDate: .now,
                title: "Salary",
                amountCents: 1000_00,
                type: .income,
                category: BudgetCategory.needs,
                month: month
            ),
            Transaction(
                addedDate: .now,
                title: "Mall",
                amountCents: -100_00,
                type: .expense,
                category: BudgetCategory.needs,
                month: month
            ),
            Transaction(
                addedDate: .now,
                title: "Rent",
                amountCents: -400_00,
                type: .expense,
                category: BudgetCategory.needs,
                month: month
            )
        ]
        
        #expect(month.remainingAmount == 500.0)
    }

    @Test
    func testOverSpentTrue() {
        let month = Month(
            startDate: .now,
            availableIncomeCents: 800_00,
            currency: Currencies.currency(for: "EUR")!,
            categoryRepartition: [.needs: 50, .wants: 30, .savingsAndDebts: 20]
        )
        
        month.transactions = [
            Transaction(
                addedDate: .now,
                title: "Groceries",
                amountCents: -100_00,
                type: .expense,
                category: BudgetCategory.needs,
                month: month
            )
        ]
        
        #expect(month.overSpent == true)
    }

    @Test
    func testOverSpentFalse() {
        let month = Month(
            startDate: .now,
            availableIncomeCents: 800_00,
            currency: Currencies.currency(for: "EUR")!,
            categoryRepartition: [.needs: 50, .wants: 30, .savingsAndDebts: 20]
        )
        
        month.transactions = [
            Transaction(
                addedDate: .now,
                title: "Salary",
                amountCents: 2000_00,
                type: .income,
                category: BudgetCategory.needs,
                month: month
            ),
            Transaction(
                addedDate: .now,
                title: "Groceries",
                amountCents: -100_00,
                type: .expense,
                category: BudgetCategory.needs,
                month: month
            )
        ]
        
        #expect(month.overSpent == false)
    }

}
