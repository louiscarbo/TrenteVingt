import SwiftUI
import Charts
import TipKit

struct remainingSpentTip: Tip {
    var title: Text {
        Text("Show remaining")
    }
    var message: Text? {
        Text("Show and hide your remaining budget by tapping on the amount.")
    }
    var image: Image? {
        Image(systemName: "hand.tap.fill")
    }
    var options: [Option] {
        MaxDisplayCount(3)
    }
}

struct PieChartView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    
    
    @Binding var showRemaining: Bool
    @State var monthBudget: MonthBudget
    @State var showText = true
    
    @State private var presentsSpentMoney = false
    
    var withoutRemainingData: [ChartData] {
        [
            ChartData(value: monthBudget.spentNeedsPercentage, color: Color.blue.gradient, designation: "Needs"),
            ChartData(value: monthBudget.spentWantsPercentage, color: Color.yellow.gradient, designation: "Wants"),
            ChartData(value: monthBudget.spentSavingsDebtsPercentage, color: Color.green.gradient, designation: "Savings & Debts")
        ]
    }
    
    var withoutRemainingIdealBudget: [ChartData] {
        [
            ChartData(value: monthBudget.needsBudget / monthBudget.totalAvailableFunds, color: Color.blue.gradient, designation: "Needs"),
            ChartData(value: monthBudget.wantsBudget / monthBudget.totalAvailableFunds, color: Color.yellow.gradient, designation: "Wants"),
            ChartData(value: monthBudget.savingsDebtsBudget / monthBudget.totalAvailableFunds, color: Color.green.gradient, designation: "Savings & Debts")
        ]
    }
    
    // Permet de gérer le cas où le budget est dépassé
    var totalToDivide : Double { max(monthBudget.totalAvailableFunds, monthBudget.totalAvailableFunds - monthBudget.remaining) }
    
    var withRemainingData: [ChartData] {
        [
            ChartData(
                value: fabs(monthBudget.spentNeedsBudget) / totalToDivide,
                color: Color.blue.gradient,
                designation: "Needs"),
            ChartData(
                value: fabs(monthBudget.spentWantsBudget) / totalToDivide,
                color: Color.yellow.gradient,
                designation: "Wants"),
            ChartData(
                value: fabs(monthBudget.spentSavingsDebtsBudget) / totalToDivide,
                color: Color.green.gradient,
                designation: "Savings & Debts"),
            ChartData(
                value: fabs(monthBudget.remaining) / totalToDivide,
                color: monthBudget.remaining >= 0 ? Color.gray.gradient : Color.red.gradient,
                designation: "Remaining")
        ]
    }
    
    var withRemainingIdealBudget: [ChartData] {
        [
            ChartData(
                value: fabs(monthBudget.needsPercentage * monthBudget.totalSpent / totalToDivide),
                color: Color.blue.gradient,
                designation: "Needs"),
            ChartData(
                value: fabs(monthBudget.wantsPercentage * monthBudget.totalSpent / totalToDivide),
                color: Color.yellow.gradient,
                designation: "Wants"),
            ChartData(
                value: fabs(monthBudget.savingsDebtsPercentage * monthBudget.totalSpent / totalToDivide),
                color: Color.green.gradient,
                designation: "Savings & Debts"),
            ChartData(
                value: fabs(monthBudget.remaining / totalToDivide),
                color: monthBudget.remaining >= 0 ? Color.gray.gradient : Color.red.gradient,
                designation: "Remaining")
        ]
    }
    
    var tip = remainingSpentTip()
    
    var body: some View {
        ZStack {
            Chart{
                ForEach(showRemaining ? withRemainingIdealBudget : withoutRemainingIdealBudget ) { category in
                    SectorMark(
                        angle: .value("Label", category.value),
                        innerRadius: .ratio(0.9),
                        outerRadius: .ratio(0.55),
                        angularInset: 4
                    )
                    .cornerRadius(8)
                    .foregroundStyle(category.color)
                }
            }
            Chart {
                ForEach(showRemaining ? withRemainingData : withoutRemainingData) { category in
                    SectorMark(
                        angle: .value("Label", category.value),
                        innerRadius: .ratio(0.6),
                        angularInset: 4
                    )
                    .cornerRadius(8)
                    .foregroundStyle(category.color)
                }
            }
            if showText {
                Button {
                    tip.invalidate(reason: .actionPerformed)
                    withAnimation {
                        presentsSpentMoney.toggle()
                        showRemaining.toggle()
                    }
                } label: {
                    VStack {
                        if presentsSpentMoney {
                            Text("Spent")
                            Text("\(monthBudget.totalSpent.formatted(.currency(code: monthBudget.currency.code).presentation(.narrow).grouping(.automatic)))")
                                .font(.system(.title, design: .serif, weight: .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        } else {
                            Text("Remaining")
                            Text("\(monthBudget.remaining.formatted(.currency(code: monthBudget.currency.code).presentation(.narrow).grouping(.automatic)))")
                                .foregroundStyle(monthBudget.remaining < 0 ? .red : .green)
                                .font(.system(.title, design: .serif, weight: .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                }
                .popoverTip(tip)
                .buttonStyle(.borderless)
                .frame(width: 130)
            }
        }
    }
}
