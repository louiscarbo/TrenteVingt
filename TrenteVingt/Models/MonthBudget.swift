import SwiftData

@Model
final class MonthBudget {
    @Relationship(.cascade) var transactions: [Transaction] = []
    var monthlyBudget: Double = 0
    var needsBudgetRepartition: Int = 50
    var wantsBudgetRepartition: Int = 30
    var savingsDebtsBudgetRepartition: Int = 20
    var monthDesignation: String = "January"
    var currencySymbolSFName: String = ""
    
    init(monthlyBudget: Double = 0, needsBudgetRepartition: Int = 50, wantsBudgetRepartition: Int = 30, savingsDebtsBudgetRepartition: Int = 20, monthDesignation: String = "january", currencySymbolSFName: String = "") {
        self.monthlyBudget = monthlyBudget
        self.needsBudgetRepartition = needsBudgetRepartition
        self.wantsBudgetRepartition = wantsBudgetRepartition
        self.savingsDebtsBudgetRepartition = savingsDebtsBudgetRepartition
        self.monthDesignation = monthDesignation
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
    @Transient
    var month: monthsDesignation {
        switch monthDesignation {
        case "January": return .january
        case "February": return .february
        case "March": return .march
        case "April": return .april
        case "May": return .may
        case "June": return .june
        case "July": return .july
        case "August": return .august
        case "September": return .september
        case "October": return .october
        case "November": return .november
        case "December": return .december
        default: return .january
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
    var spentNeedsBudget: Double { transactions.filter { $0.categoryDesignation == "Needs" && $0.amount < 0 }.reduce(0, { $0 + $1.amount }) }
    @Transient
    var spentWantsBudget: Double { transactions.filter { $0.categoryDesignation == "Wants" && $0.amount < 0 }.reduce(0, { $0 + $1.amount }) }
    @Transient
    var spentSavingsDebtsBudget: Double { transactions.filter { $0.categoryDesignation == "Savings and debts" && $0.amount < 0 }.reduce(0, { $0 + $1.amount }) }

    @Transient
    var remainingTotalBudget: Double { monthlyBudget - (spentNeedsBudget + spentWantsBudget + spentSavingsDebtsBudget) }
    @Transient
    var remainingNeedsBudget: Double { needsBudget - spentNeedsBudget }
    @Transient
    var remainingWantsBudget: Double { wantsBudget - spentWantsBudget }
    @Transient
    var remainingSavingsDebtsBudget: Double { savingsDebtsBudget - spentSavingsDebtsBudget }
}
