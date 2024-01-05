import SwiftUI

struct MonthlyDisposableIncomeView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    
    var monthBudget : MonthBudget
    @FocusState var isFocused: Bool
    @State var myMonthlyIncomeVaries: Bool = false
    @State var monthlyBudget: Double = 0
    @State var currencySymbolSFName: String = ""

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
                        TextField("Enter your monthly disposable income", value: $monthlyBudget, format: .number)
                            .focused($isFocused)
                            .font(.system(.callout, design: .serif, weight: .bold))
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .onChange(of: monthlyBudget) {
                                monthBudget.monthlyBudget = monthlyBudget
                            }
                        Picker("Currency", selection: $currencySymbolSFName) {
                            ForEach(Currency.allCases, id: \.self) { currency in
                                Image(systemName: currency.rawValue).tag(currency.rawValue)
                            }
                        }
                        .pickerStyle(.palette)
                        .onChange(of: currencySymbolSFName) {
                            isFocused = false
                            monthBudget.currencySymbolSFName = currencySymbolSFName
                        }
                    }
                    Button {
                        withAnimation {
                            myMonthlyIncomeVaries.toggle()
                        }
                    } label: {
                        Text("My monthly income varies")
                            .font(.system(.callout, design: .serif))
                            .italic()
                    }
                    if myMonthlyIncomeVaries {
                        Divider()
                        Text("You can try to estimate your likely income for this month, or you can set it to 0 and log new income as your receive it.")
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
                    withAnimation {
                        selectedTab -= 1
                    }
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
                    monthBudget.update()
                    withAnimation {
                        selectedTab += 1
                    }
                } label: {
                    Text("Next")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .disabled(monthBudget.currencySymbolSFName == "")
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
            .padding([.leading, .trailing, .bottom])
        }
    }
}
