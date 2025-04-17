//
//  MonthListView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 16/04/2025.
//

import SwiftUI
import SwiftData

struct MonthListView: View {
    @Query(
        sort: \Month.startDate,
        order: .reverse,
        animation: .default
    ) var months: [Month]
        
    var currentMonth: Month? {
        months.first
    }
    
    var archivedMonths: [Month] {
        months.filter { $0 != currentMonth }
    }
        
    var body: some View {
        NavigationSplitView {
            List {
                if let currentMonth = currentMonth {
                    Section(header: Text("Current Month")) {
                        NavigationLink {
                            MonthView(month: currentMonth)
                        } label: {
                            CurrentMonthRowView(currentMonth: currentMonth)
                        }
                    }
                }
                
                if !archivedMonths.isEmpty {
                    Section(header: Text("Archived Months")) {
                        ForEach(archivedMonths) { month in
                            NavigationLink {
                                MonthView(month: month)
                            } label: {
                                MonthRowView(month: month)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Months")
        } detail : {
            ContentUnavailableView("Let's get started!", systemImage: "calendar", description: Text("Start tracking your budget by adding your first month."))
        }
    }
}

#Preview {
    MonthListView()
        .modelContainer(SampleData.shared.modelContainer)
}

// MARK: - MonthRowView
struct MonthRowView: View {
    var month: Month
    
    var overSpent : Bool {
        month.overSpent
    }
    
    var body: some View {
        HStack {
            Image(systemName: overSpent ? "xmark.circle.fill" : "checkmark.circle.fill")
                .foregroundColor(overSpent ? . red : .green)
            
            VStack(alignment: .leading) {
                Text(month.displayName)
                    .font(.headline)
                Text(overSpent ? "Over Spent" : "Under Budget")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
            }
            
            Spacer()
            
            Text("Graph")
        }
    }
}

// MARK: - Remaining/Spent View
struct RemainingSpentView: View {
    @State var month: Month
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Remaining")
                    .font(.subheadline)
                Text("\(month.remainingAmount.formatted(.currency(code: month.currency.isoCode)))")
                    .font(.title2)
                    .foregroundStyle(month.overSpent ? .red : .green)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Spent")
                    .font(.subheadline)
                Text("\(month.negativeSpentAmount.formatted(.currency(code: month.currency.isoCode)))")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
        }
    }
}

// MARK: - New Month Button
struct NewMonthButtonView: View {
    var body: some View {
        Button {
            
        } label: {
            Label("New Month", systemImage: "calendar.badge.plus")
        }
    }
}

// MARK: - Current Month Row View
struct CurrentMonthRowView: View {
    @State var currentMonth: Month
    
    var body: some View {
        VStack(alignment: .leading) {
            MonthRowView(month: currentMonth)
            Divider()
            RemainingSpentView(month: currentMonth)
        }
    }
}
