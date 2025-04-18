//
//  TransactionListView.swift
//  Trente
//
//  Created by Louis Carbo Estaque on 17/04/2025.
//

import SwiftUI
import SwiftData

struct TransactionListView: View {
    @State var month: Month
    
    // Transactions whose month is the current month
    @Query(
        sort: \TransactionGroup.addedDate,
        order: .reverse,
    ) var transactions: [TransactionGroup]
    
    @State private var searchText = ""
    
    var body: some View {
        List(transactions) { transaction in
            TransactionGroupRowView(transactionGroup: transaction)
        }
        #if os(iOS)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by title, amount, date..."
        )
        #else
        .searchable(
            text: $searchText,
            placement: .automatic,
            prompt: "Search by title, amount, date..."
        )
        #endif
        .navigationTitle("Transactions")
    }
}

#Preview {
    NavigationStack {
        TransactionListView(month: Month.month1)
            .modelContainer(SampleDataProvider.shared.modelContainer)
    }
}
