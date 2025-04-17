//
//  MonthView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 17/04/2025.
//

import SwiftUI

struct MonthView: View {
    var month: Month
    
    var body: some View {
        List {
            Section {
                Text("Graph")
            }
            
            Section("Transactions") {
                ForEach(month.transactions) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
                            
        }
        .navigationTitle(month.displayName)
    }
}

#Preview {
    NavigationStack {
        MonthView(month: Month.month1)
            .modelContainer(SampleData.shared.modelContainer)
    }
}

struct TransactionRowView: View {
    @State var transaction: Transaction
    
    var body: some View {
        HStack {
            Text(transaction.title)
            Spacer()
            Text(transaction.amount.formatted(.currency(code: transaction.month.currency.isoCode)))
        }
    }
}
