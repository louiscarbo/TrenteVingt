import SwiftData

@Model
final class Transaction {
    var monthBudget: MonthBudget
    var title: String
    var amount: Double
    var categoryDesignation: String

    init(monthBudget: MonthBudget, title: String = "", amount: Double = 0.0, categoryDesignation: String = "Needs") {
        self.monthBudget = monthBudget
        self.title = title
        self.amount = amount
        self.categoryDesignation = categoryDesignation
    }
}

// Workaround for working with SwiftData in iOS 17 Beta 3 (maybe later?)
extension Transaction {
    var category: transactionCategory {
        switch categoryDesignation{
        case "Wants": .wants
        case "Savings and debts": .savingsDebts
        default: .needs
        }
    }
}

enum transactionCategory: String {
    case needs
    case wants
    case savingsDebts
}
