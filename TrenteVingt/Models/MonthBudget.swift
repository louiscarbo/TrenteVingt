import SwiftData
import Foundation

@Model
final class MonthBudget {
    @Relationship(deleteRule: .cascade) var transactions: [Transaction]? = []
    let identifier: UUID = UUID()
    var monthlyBudget: Double = 0
    var needsBudgetRepartition: Double = 50
    var wantsBudgetRepartition: Double = 30
    var savingsDebtsBudgetRepartition: Double = 20
    var currencySymbolSFName: String = ""
    var monthNumber: Int = 1
    
    init(monthlyBudget: Double = 0, needsBudgetRepartition: Double = 50, wantsBudgetRepartition: Double = 30, savingsDebtsBudgetRepartition: Double = 20, monthNumber: Int = 1, currencySymbolSFName: String = "") {
        self.transactions = []
        self.monthlyBudget = monthlyBudget
        self.needsBudgetRepartition = needsBudgetRepartition
        self.wantsBudgetRepartition = wantsBudgetRepartition
        self.savingsDebtsBudgetRepartition = savingsDebtsBudgetRepartition
        self.monthNumber = monthNumber
        self.currencySymbolSFName = currencySymbolSFName
    }
}

enum Currency: String, CaseIterable {
    case euro = "eurosign"
    case dollar = "dollarsign"
    case pound = "sterlingsign"
    case yen = "yensign"
    
    var code: String {
        switch self {
        case .dollar: return "USD"
        case .pound: return "GBP"
        case .yen: return "JPY"
        default: return "EUR"
        }
    }
}

extension MonthBudget {
    
    @Transient
    var monthDesignation: String {
        switch monthNumber {
        case 2: return String(localized: "February")
        case 3: return String(localized: "March")
        case 4: return String(localized: "April")
        case 5: return String(localized: "May")
        case 6: return String(localized: "June")
        case 7: return String(localized: "July")
        case 8: return String(localized: "August")
        case 9: return String(localized: "September")
        case 10: return String(localized: "October")
        case 11: return String(localized: "November")
        case 12: return String(localized: "December")
        default: return String(localized: "January")
        }
    }

    
    @Transient
    var currency: Currency {
        switch currencySymbolSFName {
        case "dollarsign": return .dollar
        case "sterlingsign": return .pound
        case "yensign": return .yen
        default: return .euro
        }
    }
    
    // Pourcentages de Needs/Wants/Savings and debts définis par l'utilisateur (ex: 0.5/0.3/0.2)
    @Transient
    var needsPercentage: Double { Double(needsBudgetRepartition) / 100 }
    @Transient
    var wantsPercentage: Double { Double(wantsBudgetRepartition) / 100 }
    @Transient
    var savingsDebtsPercentage: Double { Double(savingsDebtsBudgetRepartition) / 100 }
    
    // Montant disponible à dépenser pour chaque catégorie (ex: 500-300-200)
    @Transient
    var needsBudget: Double { totalAvailableFunds * needsPercentage }
    @Transient
    var wantsBudget: Double { totalAvailableFunds * wantsPercentage }
    @Transient
    var savingsDebtsBudget: Double { totalAvailableFunds * savingsDebtsPercentage }
    
    // Quantité NEGATIVE dépensée pour une catégorie donnée (ex: -250)
    @Transient
    var spentNeedsBudget: Double { transactions!.filter { $0.category == .needs && $0.amount < 0 }.reduce(0, { $0 + $1.amount }) }
    @Transient
    var spentWantsBudget: Double { transactions!.filter { $0.category == .wants && $0.amount < 0 }.reduce(0, { $0 + $1.amount }) }
    @Transient
    var spentSavingsDebtsBudget: Double { transactions!.filter { $0.category == .savingsDebts && $0.amount < 0 }.reduce(0, { $0 + $1.amount }) }
    
    // Pourcentage dépensé pour une catégorie donnée (ex : 50€ dépensés en Wants sur un total de 100€ pour la catégorie Wants
    // fixé par l'utilisateur renvoie 0.5)
    @Transient
    var spentNeedsCategoryPercentage : Double { fabs(spentNeedsBudget / needsBudget) }
    @Transient
    var spentWantsCategoryPercentage : Double { fabs(spentWantsBudget / wantsBudget) }
    @Transient
    var spentSavingsDebtsCategoryPercentage : Double { fabs(spentSavingsDebtsBudget / savingsDebtsBudget) }
    
    // Montant restant à dépenser pour une catégorie définie
    @Transient
    var remainingNeeds: Double { needsBudget + spentNeedsBudget }
    @Transient
    var remainingWants: Double { wantsBudget + spentWantsBudget }
    @Transient
    var remainingSavingsDebts: Double { savingsDebtsBudget + spentSavingsDebtsBudget }
    
    
    // Total dépensé
    @Transient
    var totalSpent: Double {
        spentNeedsBudget + spentWantsBudget + spentSavingsDebtsBudget
    }
    
    // Budget restant
    @Transient
    var remaining: Double {
        totalAvailableFunds + totalSpent
    }
    
    // Pourcentage (sur 100) d'une catégorie sur le total dépensé (et non pas sur le total de la catégorie en question)
    @Transient
    var spentNeedsPercentage: Double { spentNeedsBudget / totalSpent * 100}
    @Transient
    var spentWantsPercentage: Double { spentWantsBudget / totalSpent * 100}
    @Transient
    var spentSavingsDebtsPercentage: Double { spentSavingsDebtsBudget / totalSpent * 100}
    
    
    // Total des transactions positives
    @Transient
    var positiveTransactionsTotal: Double { transactions!.filter { $0.amount > 0 }.reduce(0, { $0 + $1.amount }) }
    
    // Montant disponible au total en comptant les transactions positives a priori exceptionnelles
    @Transient
    var totalAvailableFunds: Double { monthlyBudget + positiveTransactionsTotal }
}
