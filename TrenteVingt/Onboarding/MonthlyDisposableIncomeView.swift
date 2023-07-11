//
//  MonthlyBudgetView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 09/07/2023.
//

import SwiftUI

struct MonthlyDisposableIncomeView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    
    @Bindable var monthBudget : MonthBudget = MonthBudget()
    @FocusState var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Image(colorScheme == .light ? "monthly-budget" : "monthly-budget-dark")
                .resizable()
                .frame(width: 320, height: 280)
                .offset(x: 120, y: 40)
            Spacer()
            Text("Let's get started")
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text("What is your monthly budget?")
                .font(.system(.headline, design: .serif, weight: .semibold))
            HStack {
                TextField("Enter your monthly budget", value: $monthBudget.monthlyBudget, format: .number)
                    .focused($isFocused)
                    .font(.system(.callout, design: .serif, weight: .bold))
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                isFocused = false
                            } label: {
                                Text("Done")
                                    .font(.system(.title3, design: .serif))
                            }
                        }
                    }
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
                
            } label: {
                Text("I don't have a fixed monthly budget")
            }
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
                    modelContext.insert(monthBudget)
                    selectedTab += 1
                } label: {
                    Text("Next")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .disabled(monthBudget.monthlyBudget == 0)
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
        }
        .ignoresSafeArea()
        .padding()
    }
}
