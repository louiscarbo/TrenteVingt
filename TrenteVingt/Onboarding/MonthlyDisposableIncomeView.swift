import SwiftUI

struct MonthlyDisposableIncomeView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    
    @Bindable var monthBudget : MonthBudget = MonthBudget()
    @FocusState var isFocused: Bool
    @State var myMonthlyIncomeVaries: Bool = false

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Image(colorScheme == .light ? "monthly-budget" : "monthly-budget-dark")
                        .resizable()
                        .frame(maxWidth: 320, maxHeight: 280)
                        .offset(x: 120)
                    Spacer()
                        .frame(height: 20)
                    Text("Let's get started")
                        .font(.system(.largeTitle, design: .serif, weight: .bold))
                    Text("What is your monthly disposable income?")
                        .font(.system(.headline, design: .serif, weight: .semibold))
                    Divider()
                    Text("Think of your monthly disposable income as the money you're free to spend each month, once all the taxes are taken care of.")
                        .font(.system(.callout, design: .serif))
                        .italic()
                    HStack {
                        TextField("Enter your monthly disposable income", value: $monthBudget.monthlyBudget, format: .number)
                            .focused($isFocused)
                            .font(.system(.callout, design: .serif, weight: .bold))
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        Picker("Currency", selection: $monthBudget.currencySymbolSFName) {
                            ForEach(Currency.allCases, id: \.self) { currency in
                                Image(systemName: currency.rawValue).tag(currency.rawValue)
                            }
                        }
                        .pickerStyle(.palette)
                        .onChange(of: monthBudget.currencySymbolSFName) {
                            isFocused = false
                        }
                    }
                    Button {
                        myMonthlyIncomeVaries.toggle()
                    } label: {
                        Text("My monthly income varies")
                            .font(.system(.callout, design: .serif))
                            .italic()
                    }
                    if myMonthlyIncomeVaries {
                        Divider()
                        Text("Estimate your likely spending for this month. Remember, you can adjust this at any time during or between months.")
                            .font(.system(.callout, design: .serif))
                            .italic()
                        Divider()
                    }
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
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
                    modelContext.insert(monthBudget)
                    selectedTab += 1
                } label: {
                    Text("Next")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .disabled(monthBudget.monthlyBudget == 0 || monthBudget.currencySymbolSFName == "")
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
            .padding([.leading, .trailing])
        }
    }
}
