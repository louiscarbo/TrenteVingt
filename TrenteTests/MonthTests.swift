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

        // Add expense groups with entries
        let groceries = TransactionGroup(
            addedDate: .now,
            title: "Groceries",
            type: .expense,
            month: month
        )
        groceries.entries = [
            TransactionEntry(amountCents: -100_00, category: .needs, group: groceries)
        ]

        let rent = TransactionGroup(
            addedDate: .now,
            title: "Rent",
            type: .expense,
            month: month
        )
        rent.entries = [
            TransactionEntry(amountCents: -400_00, category: .needs, group: rent)
        ]

        month.transactionGroups = [groceries, rent]

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

        // Income group
        let salary = TransactionGroup(
            addedDate: .now,
            title: "Salary",
            type: .income,
            month: month
        )
        salary.entries = [
            TransactionEntry(amountCents: 1000_00, category: .needs, group: salary)
        ]

        // Expenses
        let mall = TransactionGroup(
            addedDate: .now,
            title: "Mall",
            type: .expense,
            month: month
        )
        mall.entries = [
            TransactionEntry(amountCents: -100_00, category: .needs, group: mall)
        ]

        let rent = TransactionGroup(
            addedDate: .now,
            title: "Rent",
            type: .expense,
            month: month
        )
        rent.entries = [
            TransactionEntry(amountCents: -400_00, category: .needs, group: rent)
        ]

        month.transactionGroups = [salary, mall, rent]

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

        let groceries = TransactionGroup(
            addedDate: .now,
            title: "Groceries",
            type: .expense,
            month: month
        )
        groceries.entries = [
            TransactionEntry(amountCents: -100_00, category: .needs, group: groceries)
        ]

        month.transactionGroups = [groceries]

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

        let salary = TransactionGroup(
            addedDate: .now,
            title: "Salary",
            type: .income,
            month: month
        )
        salary.entries = [
            TransactionEntry(amountCents: 2000_00, category: .needs, group: salary)
        ]

        let groceries = TransactionGroup(
            addedDate: .now,
            title: "Groceries",
            type: .expense,
            month: month
        )
        groceries.entries = [
            TransactionEntry(amountCents: -100_00, category: .needs, group: groceries)
        ]

        month.transactionGroups = [salary, groceries]

        #expect(month.overSpent == false)
    }

}
