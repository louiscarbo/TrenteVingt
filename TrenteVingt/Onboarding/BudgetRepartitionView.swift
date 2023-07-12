import SwiftUI
import SwiftData

struct BudgetRepartitionView: View {
    @Environment(\.modelContext) var modelContext
    @Query var monthBudgets : [MonthBudget]
    
    @Binding var selectedTab: Int

    var body: some View {
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = monthBudgets.last!.currency.code
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            return formatter
        }()
        
        VStack {
            VStack(alignment: .leading) {
                Text("And now, your budget")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                Text("Adjust the handles to set the allocation of your monthly disposable income. You can change this at any time.")
                    .font(.system(.callout, design: .serif))
                    .italic()
                Divider()
                Spacer()
                HStack(alignment: .center) {
                    VerticalSlider(monthBudget: monthBudgets.last!)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        Text("\(monthBudgets.last!.needsBudgetRepartition)% - \(formatter.string(from: NSNumber(value: monthBudgets.last!.needsBudget)) ?? "")")
                            .font(.system(.title, design: .serif, weight: .bold))
                        Text("on needs")
                            .font(.system(.subheadline, design: .serif))
                        Divider()
                        Text("Housing, groceries, healthcare, transportation...")
                            .font(.system(.callout, design: .serif))
                        
                        Spacer()
                        
                        Text("\(monthBudgets.last!.wantsBudgetRepartition)% - \(formatter.string(from: NSNumber(value: monthBudgets.last!.wantsBudget)) ?? "")")
                            .font(.system(.title, design: .serif, weight: .bold))
                        Text("on wants")
                            .font(.system(.subheadline, design: .serif))
                        Divider()
                        Text("Dining out, entertainment, vacations...")
                            .font(.system(.callout, design: .serif))
                        
                        Spacer()
                        
                        Text("\(monthBudgets.last!.savingsDebtsBudgetRepartition)% - \(formatter.string(from: NSNumber(value: monthBudgets.last!.savingsDebtsBudget)) ?? "")")
                            .font(.system(.title, design: .serif, weight: .bold))
                        Text("on savings and debt repayment")
                            .font(.system(.subheadline, design: .serif))
                        Divider()
                        Text("Emergency funds, retirement savings, loans...")
                            .font(.system(.callout, design: .serif))
                        
                        Spacer()
                    }
                }
            }
            .padding()
            Spacer()
            HStack {
                Button {
                    selectedTab -= 1
                } label: {
                    Text("Previous")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                
                Spacer()
                
                Button {
                    selectedTab += 1
                    
                    let date = Date() // Current date
                    let dateFormatter = DateFormatter()

                    dateFormatter.dateFormat = "MMMM"
                    let currentMonthName = dateFormatter.string(from: date)
                    let capitalizedMonthName = currentMonthName.capitalized
                    monthBudgets.last!.monthDesignation = capitalizedMonthName
                    
                } label: {
                    Text("Next")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
            .padding([.leading, .trailing])
        }
    }
}

/*
#Preview {
    BudgetRepartitionView()
}*/
