import SwiftUI

struct TransactionDetailView: View {
    @Bindable var transaction: Transaction
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var sign = "-"
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var titleFocused
    @State private var title = ""
    @State private var showCategoryPicker = false
    @State private var amount = 0.0
    @FocusState private var amountFocused
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Form {
                    Section {
                        HStack {
                            TextField("Title", text: $transaction.title, axis: .vertical)
                                .lineLimit(4)
                                .focused($titleFocused)
                                .scrollDismissesKeyboard(.interactively)
                            if !titleFocused {
                                Image(systemName: "pencil")
                                    .foregroundStyle(.gray)
                                    .onTapGesture {
                                        titleFocused = true
                                    }
                            }
                        }
                        .font(.title)
                        .bold()
                    }
                    if !showCategoryPicker {
                        Button {
                            withAnimation {
                                if sign == "-" {
                                    showCategoryPicker = true
                                }
                            }
                        } label: {
                            HStack {
                                Rectangle()
                                    .foregroundStyle(transaction.categoryColor)
                                    .frame(width: 30, height: 30)
                                Text(getCategoryDesignation(category: transaction.category))
                                    .foregroundStyle(colorScheme == .light ? .black : .white)
                                    .padding(.trailing)
                            }
                            .background(.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Button {
                                transaction.category = .needs
                                withAnimation {
                                    showCategoryPicker = false
                                }
                            } label: {
                                CategoryTag(name: "Needs", color: .blue)
                            }
                            .buttonStyle(.borderless)
                            
                            Button {
                                transaction.category = .wants
                                withAnimation {
                                    showCategoryPicker = false
                                }
                            } label: {
                                CategoryTag(name: "Wants", color: .yellow)
                            }
                            .buttonStyle(.borderless)
                            
                            Button {
                                transaction.category = .savingsDebts
                                withAnimation {
                                    showCategoryPicker = false
                                }
                            } label: {
                                CategoryTag(name: "Savings and debts", color: .green)
                            }
                            .buttonStyle(.borderless)
                            
                        }
                    }
                    HStack {
                        Picker("Sign", selection: $sign) {
                            Text("+").tag("+")
                            Text("-").tag("-")
                        }
                        .onChange(of: sign) {
                            if sign == "+" {
                                transaction.category = .positiveTransaction
                                transaction.amount = abs(transaction.amount)
                            } else {
                                transaction.category = .needs
                                transaction.amount = -1 * abs(transaction.amount)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 100)
                        
                        TextField("Amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .focused($amountFocused)
                            .onAppear {
                                amount = abs(transaction.amount)
                            }
                            .onChange(of: amount) {
                                transaction.amount = (sign == "-" ? -1 * amount : amount)
                            }
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    Button("OK") {
                                        amountFocused = false
                                    }
                                    .buttonBorderShape(.capsule)
                                    .buttonStyle(.borderedProminent)
                                    .tint(colorScheme == .light ? .black : .white)
                                    .foregroundStyle(colorScheme == .light ? .white : .black)
                                }
                            }
                    }
                }
                .navigationTitle("Transaction")
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                if transaction.amount > 0 {
                    sign = "+"
                } else {
                    sign = "-"
                }
            }
            .onDisappear {
                if let monthBudget = transaction.monthBudget {
                    monthBudget.update()
                }
            }
        }
    }
}

struct CategoryTag: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var name: String
    @State var color: Color
    
    var body: some View {
        HStack {
            Rectangle()
                .foregroundStyle(color)
                .frame(width: 30, height: 30)
            Text(name)
                .foregroundStyle(colorScheme == .light ? .black : .white)
                .padding(.trailing)
            }
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
