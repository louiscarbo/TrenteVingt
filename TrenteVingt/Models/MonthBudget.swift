import SwiftData
import Foundation
import WidgetKit

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
    var creationDate: Date = Date()
    
    init(monthlyBudget: Double = 0, needsBudgetRepartition: Double = 50, wantsBudgetRepartition: Double = 30, savingsDebtsBudgetRepartition: Double = 20, monthNumber: Int = 1, currencySymbolSFName: String = "") {
        self.transactions = []
        self.monthlyBudget = monthlyBudget
        self.needsBudgetRepartition = needsBudgetRepartition
        self.wantsBudgetRepartition = wantsBudgetRepartition
        self.savingsDebtsBudgetRepartition = savingsDebtsBudgetRepartition
        self.monthNumber = monthNumber
        self.currencySymbolSFName = currencySymbolSFName
    }
    
    // Pourcentages de Needs/Wants/Savings and debts définis par l'utilisateur (ex: 0.5/0.3/0.2)
    var needsPercentage: Double = 0.5
    var wantsPercentage: Double = 0.3
    var savingsDebtsPercentage: Double = 0.2
    
    // Montant disponible à dépenser pour chaque catégorie (ex: 500-300-200)
    var needsBudget: Double = 500
    var wantsBudget: Double = 300
    var savingsDebtsBudget: Double = 200
    
    // Quantité NEGATIVE dépensée pour une catégorie donnée (ex: -250)
    var spentNeedsBudget: Double = 0
    var spentWantsBudget: Double = 0
    var spentSavingsDebtsBudget: Double = 0
    
    // Pourcentage dépensé pour une catégorie donnée (ex : 50€ dépensés en Wants sur un total de 100€ pour la catégorie Wants
    // fixé par l'utilisateur renvoie 0.5)
    var spentNeedsCategoryPercentage : Double = 0.5
    var spentWantsCategoryPercentage : Double = 0.3
    var spentSavingsDebtsCategoryPercentage : Double = 0.2
    
    // Montant restant à dépenser pour une catégorie définie
    var remainingNeeds: Double = 0
    var remainingWants: Double = 0
    var remainingSavingsDebts: Double = 0
    
    
    // Total dépensé
    var totalSpent: Double = 1000
    
    // Budget restant
    var remaining: Double = 0
    
    // Pourcentage (sur 100) d'une catégorie sur le total dépensé (et non pas sur le total de la catégorie en question)
    var spentNeedsPercentage: Double = 0
    var spentWantsPercentage: Double = 0
    var spentSavingsDebtsPercentage: Double = 0
    
    
    // Total des transactions positives
    var positiveTransactionsTotal: Double = 0
    
    // Montant disponible au total en comptant les transactions positives a priori exceptionnelles
    var totalAvailableFunds: Double = 1000
    
    
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
    
    // MARK: Update() function
    func update() {
        var tempPositiveTransactionsTotal: Double = 0
        var tempSpentNeedsBudget: Double = 0
        var tempSpentWantsBudget: Double = 0
        var tempSpentSavingsDebtsBudget: Double = 0
        
        if let transactionsLoop = transactions {
            for transaction in transactionsLoop {
                switch transaction.category {
                case transactionCategory.needs: tempSpentNeedsBudget += transaction.amount;
                case transactionCategory.wants: tempSpentWantsBudget += transaction.amount;
                case transactionCategory.savingsDebts: tempSpentSavingsDebtsBudget += transaction.amount;
                case transactionCategory.positiveTransaction: tempPositiveTransactionsTotal += transaction.amount
                }
            }
        }
        
        positiveTransactionsTotal = tempPositiveTransactionsTotal
        
        spentNeedsBudget = tempSpentNeedsBudget
        spentWantsBudget = tempSpentWantsBudget
        spentSavingsDebtsBudget = tempSpentSavingsDebtsBudget
        
        totalAvailableFunds = monthlyBudget + positiveTransactionsTotal
        
        needsPercentage = Double(needsBudgetRepartition) / 100
        wantsPercentage = Double(wantsBudgetRepartition) / 100
        savingsDebtsPercentage = Double(savingsDebtsBudgetRepartition) / 100
        
        needsBudget = totalAvailableFunds * needsPercentage
        wantsBudget = totalAvailableFunds * wantsPercentage
        savingsDebtsBudget = totalAvailableFunds * savingsDebtsPercentage
        
        spentNeedsCategoryPercentage = fabs(spentNeedsBudget / needsBudget)
        spentWantsCategoryPercentage = fabs(spentWantsBudget / wantsBudget)
        spentSavingsDebtsCategoryPercentage = fabs(spentSavingsDebtsBudget / savingsDebtsBudget)
        
        remainingNeeds = needsBudget + spentNeedsBudget
        remainingWants = wantsBudget + spentWantsBudget
        remainingSavingsDebts = savingsDebtsBudget + spentSavingsDebtsBudget
        
        totalSpent = spentNeedsBudget + spentWantsBudget + spentSavingsDebtsBudget
        
        remaining = totalAvailableFunds + totalSpent
        
        spentNeedsPercentage = spentNeedsBudget / totalSpent * 100
        spentWantsPercentage = spentWantsBudget / totalSpent * 100
        spentSavingsDebtsPercentage = spentSavingsDebtsBudget / totalSpent * 100
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}

extension MonthBudget {
    func detachedCopy() -> MonthBudget {
        // Create a new MonthBudget instance with the necessary initial properties
        let copy = MonthBudget(
            monthlyBudget: self.monthlyBudget,
            needsBudgetRepartition: self.needsBudgetRepartition,
            wantsBudgetRepartition: self.wantsBudgetRepartition,
            savingsDebtsBudgetRepartition: self.savingsDebtsBudgetRepartition,
            monthNumber: self.monthNumber,
            currencySymbolSFName: self.currencySymbolSFName
        )

        // Manually copy the additional properties used in the widget
        copy.transactions = self.transactions?.map { $0.detachedCopy() }
        copy.creationDate = self.creationDate
        copy.needsPercentage = self.needsPercentage
        copy.wantsPercentage = self.wantsPercentage
        copy.savingsDebtsPercentage = self.savingsDebtsPercentage
        copy.needsBudget = self.needsBudget
        copy.wantsBudget = self.wantsBudget
        copy.savingsDebtsBudget = self.savingsDebtsBudget
        copy.spentNeedsBudget = self.spentNeedsBudget
        copy.spentWantsBudget = self.spentWantsBudget
        copy.spentSavingsDebtsBudget = self.spentSavingsDebtsBudget
        copy.spentNeedsCategoryPercentage = self.spentNeedsCategoryPercentage
        copy.spentWantsCategoryPercentage = self.spentWantsCategoryPercentage
        copy.spentSavingsDebtsCategoryPercentage = self.spentSavingsDebtsCategoryPercentage
        copy.remainingNeeds = self.remainingNeeds
        copy.remainingWants = self.remainingWants
        copy.remainingSavingsDebts = self.remainingSavingsDebts
        copy.totalSpent = self.totalSpent
        copy.remaining = self.remaining
        copy.spentNeedsPercentage = self.spentNeedsPercentage
        copy.spentWantsPercentage = self.spentWantsPercentage
        copy.spentSavingsDebtsPercentage = self.spentSavingsDebtsPercentage
        copy.positiveTransactionsTotal = self.positiveTransactionsTotal
        copy.totalAvailableFunds = self.totalAvailableFunds

        return copy
    }
}
