import SwiftUI

struct NewMonthView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var modelMonthBudget: MonthBudget
    @State var newMonthBudget = MonthBudget()
    @Binding var isPresentingNewMonthView: Bool
    
    @State private var dummyIsPresenting: Bool = true
    
    var body: some View {
        NavigationStack {
            MonthDetailsView(monthBudget: newMonthBudget, isPresenting: $dummyIsPresenting, isInSettings: false, shouldDismiss: .constant(false))
            .onAppear {
                let newMonthNumber : Int = nextMonthNumber(from: modelMonthBudget.monthNumber) ?? modelMonthBudget.monthNumber
                newMonthBudget.monthlyBudget = modelMonthBudget.monthlyBudget
                newMonthBudget.needsBudgetRepartition = modelMonthBudget.needsBudgetRepartition
                newMonthBudget.wantsBudgetRepartition = modelMonthBudget.wantsBudgetRepartition
                newMonthBudget.savingsDebtsBudgetRepartition = modelMonthBudget.savingsDebtsBudgetRepartition
                newMonthBudget.currencySymbolSFName = modelMonthBudget.currencySymbolSFName
                newMonthBudget.monthNumber = newMonthNumber
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        dismiss()
                        modelContext.insert(newMonthBudget)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresentingNewMonthView = false
                    }
                }
            }
        }
    }
}

public func nextMonthNumber(from currentMonthNumber: Int) -> Int? {
    if currentMonthNumber < 1 || currentMonthNumber > 12 {
        print("Invalid month number provided")
        return nil
    }
    
    return (currentMonthNumber % 12) + 1
}

          
/*
#Preview {
    NewMonthView()
}
*/
