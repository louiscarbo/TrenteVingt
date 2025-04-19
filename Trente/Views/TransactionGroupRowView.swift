//
//  TransactionRowView.swift
//  Trente
//
//  Created by Louis Carbo Estaque on 17/04/2025.
//

import SwiftUI

struct TransactionGroupRowView: View {
    @State var transactionGroup: TransactionGroup
    
    var body: some View {
        if transactionGroup.entries.count > 1 {
            DisclosureGroup {
                ForEach(transactionGroup.entries) { entry in
                    TransactionEntryRowView(transactionEntry: entry)
                }
            } label: {
                HStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 10, height: 10)
                    VStack(alignment: .leading) {
                        Text(transactionGroup.title)
                            .font(.headline)
                        Text("Income")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(transactionGroup.displayAmount)
                        .font(.title)
                }
            }
        } else if transactionGroup.entries.count == 1 {
            TransactionEntryRowView(transactionEntry: transactionGroup.entries[0], title: transactionGroup.title)
        } else {
            EmptyView()
                .onAppear {
                    print("WARNING: TransactionGroupRowView has no entries")
                }
        }
    }
}

struct TransactionEntryRowView: View {
    @State var transactionEntry: TransactionEntry
    @State var title: String?
    
    var body: some View {
        HStack {
            Circle()
                .fill(transactionEntry.category.color)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading) {
                if let title = title {
                    Text(title)
                        .font(.headline)
                }
                Text(transactionEntry.category.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(transactionEntry.displayAmount)
                .font(.title)
        }
    }
}

#Preview {
    let month = Month.month1
    
    List {
        Text("Transactions")                .modelContainer(SampleDataProvider.shared.modelContainer)
        ForEach(month.transactionGroups.sorted {
            $0.addedDate > $1.addedDate
        }) { transaction in
            TransactionGroupRowView(transactionGroup: transaction)
        }
    }
}
