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
        WidthThresholdReader(widthThreshold: 800) { proxy in
            
            Group {
                if proxy.isCompact {
                    NarrowMonthView(month: month)
                } else {
                    WideMonthView(month: month)
                }
            }
            .navigationTitle(month.name)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleDataProvider.shared.modelContainer)
}

struct NarrowMonthView: View {
    @State var month: Month
    
    var body: some View {
        List {
            ScrollView(.horizontal) {
                HStack {
                    Text("Graph Card")
                        .font(.title)
                    Text("Other Graph Card")
                        .font(.subheadline)
                    Text("Other Graph Card")
                        .font(.subheadline)
                }
            }
            
            // Transactions
            Section(header: Text("Latest transactions")) {
                ForEach(month.transactionGroups) { transaction in
                    TransactionGroupRowView(transactionGroup: transaction)
                }
            }
            
            // Recurring Transactions
            Section(header: Text("Recurring Transactions")) {
                ForEach(month.recurringInstances) { transaction in
                    Text(transaction.rule.title)
                }
            }
        }
    }
}

struct WideMonthView: View {
    @State var month: Month
    
    var body: some View {
        ScrollView {
            HStack {
                Grid {
                    // Graph Card
                    GridRow {
                        Text("Graph Card")
                    }
                    .gridCellColumns(2)
                    // Other Graph Cards
                    GridRow {
                        Text("Other Graph Card")
                        Text("Other Graph Card")
                    }
                }
                // Transactions
                LazyVStack {
                    Text("Transactions")
                        .font(.headline)
                    ForEach(month.transactionGroups) { transaction in
                        TransactionGroupRowView(transactionGroup: transaction)
                    }
                }
                // Recurring Transactions
                LazyVStack {
                    Text("Recurring Transactions")
                        .font(.headline)
                    ForEach(month.recurringInstances) { transaction in
                        Text(transaction.rule.title)
                    }
                }
            }
        }
        .background {
            #if os(iOS)
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            #else
            Color(.underPageBackgroundColor)
                .ignoresSafeArea()
            #endif
        }
    }
}
