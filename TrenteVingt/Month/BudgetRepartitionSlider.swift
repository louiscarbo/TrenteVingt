import SwiftUI

struct BudgetRepartitionSlider: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @State var monthBudget: MonthBudget
    @State var showIndications: Bool
    @State var maxHeight: CGFloat
    
    var body: some View {
        
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = monthBudget.currency.code
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            return formatter
        }()
        VStack {
            HStack(alignment: .center) {
                VerticalSlider(maxHeight: maxHeight, monthBudget: monthBudget)
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text("\(Int(monthBudget.needsBudgetRepartition))% - \(formatter.string(from: NSNumber(value: monthBudget.needsBudget)) ?? "")")
                        .font(.system(.title, design: .serif, weight: .bold))
                    Text("on needs")
                        .font(.system(.subheadline, design: .serif))
                    if showIndications {
                        Divider()
                        Text("Housing, groceries, healthcare, transportation...")
                            .font(.system(.callout, design: .serif))
                    }
                    
                    Stepper {
                    } onIncrement: {
                        if 100 - (monthBudget.needsBudgetRepartition + 100/monthBudget.monthlyBudget) - monthBudget.wantsBudgetRepartition >= 0 {
                            monthBudget.needsBudgetRepartition += (100/monthBudget.monthlyBudget)
                            monthBudget.wantsBudgetRepartition -= (100/monthBudget.monthlyBudget)
                        } else if monthBudget.wantsBudgetRepartition - 100/monthBudget.monthlyBudget >= 0 {
                            monthBudget.wantsBudgetRepartition -= (100/monthBudget.monthlyBudget)
                        }
                        monthBudget.update()
                    } onDecrement: {
                        if monthBudget.needsBudgetRepartition - 100/monthBudget.monthlyBudget >= 0 {
                            monthBudget.needsBudgetRepartition -= (100/monthBudget.monthlyBudget)
                            monthBudget.wantsBudgetRepartition += (100/monthBudget.monthlyBudget)
                        }
                        monthBudget.update()
                    }
                    .labelsHidden()
                    
                    Spacer()
                    
                    Text("\(Int(monthBudget.wantsBudgetRepartition))% - \(formatter.string(from: NSNumber(value: monthBudget.wantsBudget)) ?? "")")
                        .font(.system(.title, design: .serif, weight: .bold))
                    Text("on wants")
                        .font(.system(.subheadline, design: .serif))
                    if showIndications {
                        Divider()
                        Text("Dining out, entertainment, vacations...")
                            .font(.system(.callout, design: .serif))
                    }
                    
                    Stepper {
                    } onIncrement: {
                        if 100 - monthBudget.needsBudgetRepartition - (monthBudget.wantsBudgetRepartition + 100/monthBudget.monthlyBudget) >= 0 {
                            monthBudget.wantsBudgetRepartition += (100/monthBudget.monthlyBudget)
                        } else if monthBudget.needsBudgetRepartition - 100/monthBudget.monthlyBudget >= 0 {
                            monthBudget.needsBudgetRepartition -= (100/monthBudget.monthlyBudget)
                        }
                        monthBudget.update()
                    } onDecrement: {
                        if monthBudget.wantsBudgetRepartition - 100/monthBudget.monthlyBudget >= 0 {
                            monthBudget.wantsBudgetRepartition -= (100/monthBudget.monthlyBudget)
                        }
                        monthBudget.update()
                    }
                    .labelsHidden()
                    
                    Spacer()
                    
                    Text("\(100 - Int(monthBudget.needsBudgetRepartition) - Int(monthBudget.wantsBudgetRepartition))% - \(formatter.string(from: NSNumber(value: monthBudget.monthlyBudget - monthBudget.needsBudget - monthBudget.wantsBudget)) ?? "")")
                        .font(.system(.title, design: .serif, weight: .bold))
                    Text("on savings and debt repayment")
                        .font(.system(.subheadline, design: .serif))
                    if showIndications {
                        Divider()
                        Text("Emergency funds, retirement savings, loans...")
                            .font(.system(.callout, design: .serif))
                    }
                    Spacer()
                }
                Spacer()
            }
            .frame(height: maxHeight)
            if !showIndications {
                Divider()
                HStack {
                    Text("Monthly disposable income")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                    let formatter: NumberFormatter = {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        return formatter
                    }()
                    TextField("Amount", value: $monthBudget.monthlyBudget, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }
}

/*
#Preview {
    BudgetRepartitionSlider()
}
*/
