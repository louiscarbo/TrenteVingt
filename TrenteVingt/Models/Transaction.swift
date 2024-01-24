import SwiftData
import SwiftUI
import Foundation

@Model
final class Transaction: NSCopying {
    
    var monthBudget: MonthBudget?
    var title: String = ""
    var amount: Double = 0.0
    var addedDate: Date = Date()
    var category: transactionCategory = transactionCategory.needs
    var recurringTransaction: RecurringTransaction?

    init(title: String, amount: Double, category: transactionCategory) {
        self.title = title
        self.amount = amount
        self.category = category
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Transaction(title: title, amount: amount, category: category)
        copy.monthBudget = monthBudget
        return copy
    }
}

// Workaround for working with SwiftData in iOS 17 Beta 3 (maybe later?)
extension Transaction {
    @Transient
    var categoryColor: Color {
        switch category {
        case .wants: .yellow
        case .savingsDebts: .green
        case .positiveTransaction: .pink
        default: .blue
        }
    }
}

enum transactionCategory: String, Codable {
    case needs = "Needs"
    case wants = "Wants"
    case savingsDebts = "Savings & Debts"
    case positiveTransaction = "Positive Transaction"
}
