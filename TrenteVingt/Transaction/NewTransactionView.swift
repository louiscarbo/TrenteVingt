import SwiftUI
import WidgetKit

struct NewTransactionView: View {
    @State var currentMonthBudget : MonthBudget
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var falseText = ""
    @State private var transactionTitle = ""
    @State private var dummyCategory : transactionCategory? = nil
    @FocusState private var amountFocus
    @FocusState private var titleFocus
    @State private var showTitleField = false
    
    private var doubleAmount : Double {
        let stringWithPeriod = falseText.replacingOccurrences(of: ",", with: ".")
        return Double(stringWithPeriod) ?? 0.00
    }
    
    private var descriptionText : String {
        switch dummyCategory {
        case .needs:
            return String(localized: "Basics like rent, food, and healthcare.")
        case .wants:
            return String(localized: "Extras like dining out and shopping.")
        case .savingsDebts:
            return String(localized: "Money saved and debts due.")
        case .positiveTransaction:
            return String(localized: "What you earn, after deductions.")
        default:
            return String(localized: "Pick a category for this transaction.")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if !showTitleField {
                    Picker("Category", selection: $dummyCategory) {
                        Text("Income").tag(Optional(transactionCategory.positiveTransaction))
                        Text("Needs").tag(Optional(transactionCategory.needs))
                        Text("Wants").tag(Optional(transactionCategory.wants))
                        Text("Savings").tag(Optional(transactionCategory.savingsDebts))
                    }
                    .pickerStyle(.segmented)
                    HStack {
                        Label(descriptionText, systemImage: "questionmark.circle")
                        Spacer()
                    }
                    Spacer()
                    TextField("0.00", text: $falseText)
                        .transition(.move(edge: .leading))
                        .font(.system(size: 80, weight: .bold))
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .focused($amountFocus)
                        .onChange(of: falseText) {
                            checkMinus()
                        }
                        .onChange(of: dummyCategory) {
                            checkMinus()
                        }
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                showTitleField.toggle()
                                titleFocus = true
                            }
                        } label: {
                            Text("Next")
                                .foregroundStyle(colorScheme == .light ? .white : .black)
                                .font(.system(.title3, design: .serif))
                        }
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.borderedProminent)
                        .tint(colorScheme == .light ? Color(.black) : Color(.white))
                        .disabled(falseText == "" || dummyCategory == nil || falseText == "-")
                    }
                } else {
                    HStack {
                        Label("Enter a title for this transaction.", systemImage: "questionmark.circle")
                        Spacer()
                    }
                    Spacer()
                    TextField("Title", text: $transactionTitle)
                        .submitLabel(.done)
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.center)
                        .transition(.move(edge: .trailing))
                        .focused($titleFocus)
                        .onSubmit {
                            addAndClose()
                        }
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                showTitleField.toggle()
                                amountFocus = true
                            }
                        } label: {
                            Text("Previous")
                                .foregroundStyle(colorScheme == .light ? .white : .black)
                                .font(.system(.title3, design: .serif))
                        }
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.borderedProminent)
                        .tint(colorScheme == .light ? Color(.black) : Color(.white))
                        .disabled(falseText == "" || dummyCategory == nil || falseText == "-")
                        Spacer()
                    }
                }
            }
            .onAppear {
                amountFocus = true
            }
            .navigationTitle("New Transaction")
            .toolbarTitleDisplayMode(.inline)
            .padding()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") {
                        addAndClose()
                    }
                    .disabled(falseText == "" || transactionTitle == "")
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func checkMinus() -> Void {
        if dummyCategory == .needs || dummyCategory == .wants || dummyCategory == .savingsDebts {
            if falseText.first != "-" {
                falseText = "-" + falseText
            }
        } else {
            if falseText.first == "-" {
                falseText = String(falseText.dropFirst())
            }
        }
    }
    
    func addAndClose() -> Void {
        let newTransaction = Transaction(
            title: transactionTitle,
            amount: doubleAmount,
            category: dummyCategory ?? .needs)
        modelContext.insert(newTransaction)
        newTransaction.monthBudget = currentMonthBudget
        currentMonthBudget.transactions?.append(newTransaction) ?? (currentMonthBudget.transactions = [newTransaction])
        currentMonthBudget.update()
        WidgetCenter.shared.reloadAllTimelines()
        
        dismiss()
    }
}
