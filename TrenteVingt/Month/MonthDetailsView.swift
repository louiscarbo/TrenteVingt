import SwiftUI

struct MonthDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var monthBudget: MonthBudget
    @Binding var isPresenting: Bool
    @State var isInSettings: Bool
    @Binding var shouldDismiss: Bool
    
    @State private var needsAmount: Double = 0
    @State private var wantsAmount: Double = 0
    @State private var savingsDebtsAmount: Double = 0
    @State private var showDeletionAlert = false
    
    var body: some View {
        List {
            Section("Month") {
                let months = [
                    String(localized: "January"),
                    String(localized: "February"),
                    String(localized: "March"),
                    String(localized: "April"),
                    String(localized: "May"),
                    String(localized: "June"),
                    String(localized: "July"),
                    String(localized: "August"),
                    String(localized: "September"),
                    String(localized: "October"),
                    String(localized: "November"),
                    String(localized: "December")
                ]
                Picker("Month", selection: $monthBudget.monthNumber) {
                    ForEach(0..<12) { index in
                        Text(months[index]).tag(index + 1)
                    }
                }
            }
            
            Section("Currency") {
                Picker("Currency", selection: $monthBudget.currencySymbolSFName) {
                    ForEach(Currency.allCases, id: \.self) { currency in
                        Image(systemName: currency.rawValue).tag(currency.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section("Budget repartition") {
                BudgetRepartitionSlider(monthBudget: monthBudget, showIndications: false, maxHeight: 400)
                Button("Reset repartition") {
                    monthBudget.needsBudgetRepartition = 50
                    monthBudget.wantsBudgetRepartition = 30
                    monthBudget.savingsDebtsBudgetRepartition = 20
                    monthBudget.update()
                }
            }
            
            if isInSettings {
                Button {
                    showDeletionAlert.toggle()
                } label: {
                    Label("Delete month", systemImage: "trash")
                        .foregroundStyle(.white)
                }
                .tint(.white)
                .listRowBackground(Color(.red))
                .alert("Are you sure you want to delete this month?", isPresented: $showDeletionAlert) {
                    Button(role: .cancel) {
                        showDeletionAlert.toggle()
                    } label: {
                        Text("Cancel")
                    }
                    Button(role: .destructive) {
                        showDeletionAlert.toggle()
                        isPresenting = false
                        shouldDismiss = true
                        if let transactions = monthBudget.transactions {
                            for transaction in transactions {
                                modelContext.delete(transaction)
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            modelContext.delete(monthBudget)
                        }
                    } label: {
                        Text("Delete")
                    }
                } message: {
                    Text("Deleting this month will also delete all associated transactions. This action is permanent.")
                }
            }
        }
        .onAppear {
            needsAmount = monthBudget.needsBudget
            wantsAmount = monthBudget.wantsBudget
            savingsDebtsAmount = monthBudget.savingsDebtsBudget
        }
        .onDisappear {
            monthBudget.update()
        }
    }
}
