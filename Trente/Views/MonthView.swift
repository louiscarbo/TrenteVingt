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
                            ForEach(month.transactions) { transaction in
                                TransactionRowView(transaction: transaction)
                            }
                        }
                        
                        // Recurring Transactions
                        Section(header: Text("Recurring Transactions")) {
                            ForEach(month.recurringInstances) { transaction in
                                Text(transaction.rule.title)
                            }
                        }
                    }
                } else {
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
                                ForEach(month.transactions) { transaction in
                                    TransactionRowView(transaction: transaction)
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
                        Color(uiColor: .systemGroupedBackground)
                            .ignoresSafeArea()
                    }
                }
            }
            .navigationTitle(month.name)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}

struct TransactionRowView: View {
    @State var transaction: Transaction
    
    var body: some View {
        HStack {
            Circle()
                .fill(transaction.category.color)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.category.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(transaction.amount.formatted(.currency(code: transaction.month.currency.isoCode)))
                .font(.title)
        }
    }
}
