//
//  RecurringTransactionsExplanations.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 24/01/2024.
//

import SwiftUI

struct RecurringTransactionsExplanations: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Image("recurring-transactions-explanation")
                    .resizable()
                    .scaledToFit()
                VStack(alignment: .leading) {
                    Text("What are recurring transactions?")
                        .font(.title)
                        .bold()
                    Text("Recurring transactions are regular expenses or income that happen at fixed intervals, whether weekly, monthly, or yearly. Think of them as your reliable bills or income sources that occur like clockwork.")
                        .padding(.bottom)
                    Text("How does it work?")
                        .font(.headline)
                    HStack(alignment: .top) {
                        Image(systemName: "1.circle")
                        Text("**Declare a New Recurring Transaction:** Tap on 'Add Transaction' and easily set up your recurring transactions, specifying the frequency – whether it's every week, month, or year.")
                    }
                    .padding(.bottom)
                    HStack {
                        Spacer()
                        Button { } label: {
                            Label("Add transaction", systemImage: "plus")
                                .foregroundStyle(colorScheme == .light ? .white : .black)
                                .font(.system(.title2, design: .serif, weight: .semibold))
                        }
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.borderedProminent)
                        .tint(colorScheme == .light ? Color(.black) : Color(.white))
                        .allowsHitTesting(false)
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack(alignment: .top) {
                        Image(systemName: "2.circle")
                        Text("**Receive Timely Notifications:** We've got your back! You'll receive notifications when a recurring transaction is due. No more forgetting those important payments or paychecks.")
                    }
                    .padding(.bottom)
                    HStack(alignment: .top) {
                        Image(systemName: "3.circle")
                        Text("**Easy Validation:** To seamlessly add or validate a transaction for the current month, a simple swipe to the right is all it takes. This validation adds the transaction to your current month's budget, and makes sure that we're not adding a transaction that didn't actually happen.")
                    }
                    .padding(.bottom)
                    Image("validating-recurring-transaction")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .offset(y: -140)
                .padding()
            }
        }
    }
}

#Preview {
    Button("See sheet") {
    }
    .sheet(isPresented: .constant(true), content: {
        RecurringTransactionsExplanations()
    })
}
