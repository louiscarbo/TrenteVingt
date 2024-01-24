import SwiftUI
import WidgetKit

struct NewTransactionView: View {
    @State var currentMonthBudget : MonthBudget
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // Transaction Data
    @State private var falseText = ""
    @State private var transactionTitle = ""
    @State private var dummyCategory : transactionCategory? = nil
    
    // View Data
    @FocusState private var amountFocus
    @FocusState private var titleFocus
    @State private var currentScreen = CurrentScreen.amount
    
    // Recurring Transaction Data
    @State private var isRecurring = false
    @State private var recurrenceType: RecurrenceType = .monthly
    @State private var interval: Int = 1
    @State private var day: Int = 1
    @State private var startingDate: Date = Date()
    
    private var doubleAmount : Double {
        let stringWithPeriod = falseText.replacingOccurrences(of: ",", with: ".")
        return Double(stringWithPeriod) ?? 0.00
    }
    
    private enum CurrentScreen {
        case amount, title, recurrence
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
                switch(currentScreen) {
                case CurrentScreen.amount:
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
                        Toggle("This is recurring",isOn: $isRecurring)
                            .toggleStyle(CheckToggleStyle(color: colorScheme == .light ? .black : .white))
                            .tint(Color.black)
                            .sensoryFeedback(.selection, trigger: isRecurring)
                        Spacer()
                        Button {
                            withAnimation {
                                currentScreen = .title
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
                case CurrentScreen.title:
                    HStack {
                        Label("Enter a title for this transaction.", systemImage: "questionmark.circle")
                        Spacer()
                    }
                    Spacer()
                    TextField("Title", text: $transactionTitle)
                        .submitLabel(.done)
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.center)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        .focused($titleFocus)
                        .onSubmit {
                            addAndClose()
                        }
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                currentScreen = .amount
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
                        if isRecurring {
                            Button {
                                withAnimation {
                                    currentScreen = .recurrence
                                    titleFocus = false
                                }
                            } label: {
                                Text("Next")
                                    .foregroundStyle(colorScheme == .light ? .white : .black)
                                    .font(.system(.title3, design: .serif))
                            }
                            .buttonBorderShape(.capsule)
                            .buttonStyle(.borderedProminent)
                            .tint(colorScheme == .light ? Color(.black) : Color(.white))
                            .disabled(transactionTitle == "")
                        }
                    }
                case CurrentScreen.recurrence:
                    RecurrenceTypePicker(selectedRecurrenceType: $recurrenceType)
                    Spacer()
                        .frame(height: 30)
                    RecurrenceDetailsPicker(recurrenceType: $recurrenceType, interval: $interval, day: $day, startingDate: $startingDate)
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                currentScreen = .title
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
                    .disabled(falseText == "" || transactionTitle == "" || (isRecurring && currentScreen != .recurrence))
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
        
        if isRecurring {
            let newRecurringTransaction = RecurringTransaction(transaction: newTransaction)
            
            var newRecurrenceDetails = RecurrenceDetails(recurrenceType: recurrenceType)
            switch(recurrenceType) {
            case .weekly:
                newRecurrenceDetails.day = day
            case .monthly:
                newRecurrenceDetails.day = day
            case .yearly:
                newRecurrenceDetails.startingDate = startingDate
            }
            
            newRecurringTransaction.recurrenceDetails = newRecurrenceDetails
            modelContext.insert(newRecurringTransaction)
            NotificationHandler.shared.scheduleRecurringTransactionNotification(recurringTransaction: newRecurringTransaction)
        } else {
            modelContext.insert(newTransaction)
            newTransaction.monthBudget = currentMonthBudget
            currentMonthBudget.transactions?.append(newTransaction) ?? (currentMonthBudget.transactions = [newTransaction])
            currentMonthBudget.update()
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        dismiss()
    }
    
    struct RecurrenceTypePicker: View {
        @Binding var selectedRecurrenceType : RecurrenceType
        @Environment (\.colorScheme) private var colorScheme
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("RECURRENCE TYPE :")
                    .font(.caption)
                    .padding(.leading)
                    .foregroundStyle(.gray)
                VStack(spacing: 0) {
                    ForEach(RecurrenceType.allCases) { recurrenceType in
                        let isSelected = recurrenceType == selectedRecurrenceType
                        HStack {
                            Button {
                                selectedRecurrenceType = recurrenceType
                            } label: {
                                Text(recurrenceType.designation)
                                    .foregroundStyle(colorScheme == .light ? .black : .white)
                                    .padding(4)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .buttonBorderShape(.roundedRectangle(radius: 0))
                            .buttonStyle(.bordered)
                        }
                        Divider()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
