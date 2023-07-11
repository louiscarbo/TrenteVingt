import Foundation
import SwiftData

@Model
final class MonthBudget {
    @Relationship(.cascade) var transactions: [Transaction] = []
    var monthlyBudget: Double = 2000
    var needsBudgetRepartition: Int = 50
    var wantsBudgetRepartition: Int = 30
    var savingsDebtsBudgetRepartition: Int = 20
    var monthDesignation: String = "january"
    
    init(monthlyBudget: Double, needsBudgetRepartition: Int, wantsBudgetRepartition: Int, savingsDebtsBudgetRepartition: Int) {
        self.monthlyBudget = monthlyBudget
        self.needsBudgetRepartition = needsBudgetRepartition
        self.wantsBudgetRepartition = wantsBudgetRepartition
        self.savingsDebtsBudgetRepartition = savingsDebtsBudgetRepartition
    }
}

enum monthsDesignation: String {
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}

extension MonthBudget {
    var month: monthsDesignation {
        switch monthDesignation {
        case "january": return .january
        case "february": return .february
        case "march": return .march
        case "april": return .april
        case "may": return .may
        case "june": return .june
        case "july": return .july
        case "august": return .august
        case "september": return .september
        case "october": return .october
        case "november": return .november
        case "december": return .december
        default: return .january
        }
    }
    
    @Transient
    var needsPercentage: Double { Double(needsBudgetRepartition) / 100 }
    @Transient
    var wantsPercentage: Double { Double(wantsBudgetRepartition) / 100 }
    @Transient
    var savingsDebtsPercentage: Double { Double(savingsDebtsBudgetRepartition) / 100 }
    
    @Transient
    var needsBudget: Double { monthlyBudget * needsPercentage }
    @Transient
    var wantsBudget: Double { monthlyBudget * wantsPercentage }
    @Transient
    var savingsDebtsBudget: Double { monthlyBudget * savingsDebtsPercentage }
    
    @Transient
    var spentNeedsBudget: Double { transactions.filter { $0.categoryDesignation == "needs" && !$0.isPositive }.reduce(0, { $0 + $1.amount }) }
    @Transient
    var spentWantsBudget: Double { transactions.filter { $0.categoryDesignation == "wants" && !$0.isPositive }.reduce(0, { $0 + $1.amount }) }
    @Transient
    var spentSavingsDebtsBudget: Double { transactions.filter { $0.categoryDesignation == "savingsDebts" && !$0.isPositive }.reduce(0, { $0 + $1.amount }) }

    @Transient
    var remainingTotalBudget: Double { monthlyBudget - (spentNeedsBudget + spentWantsBudget + spentSavingsDebtsBudget) }
    @Transient
    var remainingNeedsBudget: Double { needsBudget - spentNeedsBudget }
    @Transient
    var remainingWantsBudget: Double { wantsBudget - spentWantsBudget }
    @Transient
    var remainingSavingsDebtsBudget: Double { savingsDebtsBudget - spentSavingsDebtsBudget }
}
