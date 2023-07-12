import SwiftUI
import SwiftData

struct NewTransactionView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var currentBudget: MonthBudget
    @State var transactionTitle: String = ""
    @State var amount: Double = 0
    @State var sign: String = "+"
    @State var categoryDesignation: String = "Needs"
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Category", selection: $categoryDesignation) {
                    Text("Needs").tag("Needs")
                    Text("Wants").tag("Wants")
                    Text("Savings/Debts").tag("Savings and debts")
                }
                .pickerStyle(.segmented)
                TextField("Give a title to the transaction", text: $transactionTitle)
                HStack {
                    Picker("Sign", selection: $sign) {
                        Text("+").tag("+")
                        Text("-").tag("-")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                    TextField("Amount", value: $amount, format: .currency(code: currentBudget.currency.code))
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Transaction")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss"){
                        dismiss()
                    }
                }
            }
        }
    }
}

/*
#Preview {
    NewTransactionView()
}
*/
