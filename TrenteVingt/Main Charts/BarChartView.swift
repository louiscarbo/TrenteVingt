import SwiftUI
import Charts

struct BarChartView: View {
    
    @State var monthBudget: MonthBudget
    
    var barChartData: [ChartData] {
        [
            ChartData(
                value: 100*monthBudget.spentNeedsCategoryPercentage <= 100 ? 100*monthBudget.spentNeedsCategoryPercentage : 100,
                color: Color.blue.gradient,
                designation: String(localized: "Needs")),
            ChartData(
                value: 100*monthBudget.spentWantsCategoryPercentage <= 100 ? 100*monthBudget.spentWantsCategoryPercentage: 100,
                color: Color.yellow.gradient,
                designation: String(localized: "Wants")),
            ChartData(
                value: 100*monthBudget.spentSavingsDebtsCategoryPercentage <= 100 ? 100*monthBudget.spentSavingsDebtsCategoryPercentage : 100,
                color: Color.green.gradient,
                designation: String(localized: "Savings & Debts")),
            
            ChartData(
                value: 100*monthBudget.spentNeedsCategoryPercentage > 100 ? monthBudget.spentNeedsCategoryPercentage*100-100 : 0,
                color: Color.red.gradient,
                designation: String(localized: "Needs"),
                type: "Overspent"),
            ChartData(
                value: 100*monthBudget.spentWantsCategoryPercentage > 100 ? monthBudget.spentWantsCategoryPercentage*100-100 : 0,
                color: Color.red.gradient,
                designation: String(localized: "Wants"),
                type: "Overspent"),
            ChartData(
                value: 100*monthBudget.spentSavingsDebtsCategoryPercentage > 100 ? monthBudget.spentSavingsDebtsCategoryPercentage*100-100 : 0,
                color: Color.red.gradient,
                designation: String(localized: "Savings & Debts"),
                type: "Overspent"),
            
            ChartData(
                value: 100*monthBudget.spentNeedsCategoryPercentage <= 100 ? 100-monthBudget.spentNeedsCategoryPercentage*100 : 0,
                secondValue: monthBudget.remainingNeeds,
                color: Color.gray.gradient,
                designation: String(localized: "Needs"),
                type: "Remaining"),
            ChartData(
                value: 100*monthBudget.spentWantsCategoryPercentage <= 100 ? 100-monthBudget.spentWantsCategoryPercentage*100 : 0,
                secondValue: monthBudget.remainingWants,
                color: Color.gray.gradient,
                designation: String(localized: "Wants"),
                type: "Remaining"),
            ChartData(
                value: 100*monthBudget.spentSavingsDebtsCategoryPercentage <= 100 ? 100-monthBudget.spentSavingsDebtsCategoryPercentage*100 : 0,
                secondValue: monthBudget.remainingSavingsDebts,
                color: Color.gray.gradient,
                designation: String(localized: "Savings & Debts"),
                type: "Remaining")
        ]
    }
    
    var body: some View {
        
        let maxValue = max(max(monthBudget.spentNeedsCategoryPercentage, monthBudget.spentWantsCategoryPercentage), monthBudget.spentSavingsDebtsCategoryPercentage)
        
        Chart {
            ForEach(barChartData) { category in
                BarMark(
                    x: .value("Amount", category.value),
                    y: .value("Category", category.designation)
                )
                .cornerRadius(20)
                .foregroundStyle(category.color)
                .annotation(position: .overlay) {
                    if category.value != 0 && category.type != "Remaining" {
                        Text(String(format: "%.0f", category.value)+"%")
                            .font(.system(.subheadline, design: .serif, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    if category.type == "Remaining" {
                        ViewThatFits(in: .horizontal) {
                            Text("\(category.secondValue!.formatted(.currency(code: monthBudget.currency.code).presentation(.narrow).grouping(.automatic))) remaining")
                                .font(.system(.subheadline, design: .serif, weight: .semibold))
                                .foregroundStyle(.white)
                            Text("\(category.secondValue!.formatted(.currency(code: monthBudget.currency.code).presentation(.narrow).grouping(.automatic)))")
                                .font(.system(.subheadline, design: .serif, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .annotation(position: .topLeading) {
                    if category.type == "Overspent" && category.value > 0.5 {
                        Text("Over spending")
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                }
            }
        }
        .chartXScale(domain: maxValue > 1 ? 0...100*maxValue : 0...100)
        .chartXAxis {
            AxisMarks { _ in
                AxisGridLine()
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
            }
        }
    }
}

/*
#Preview {
    BarChartView()
}
*/
