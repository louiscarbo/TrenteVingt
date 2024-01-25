import WidgetKit
import SwiftUI
import SwiftData

struct RemainingSpentProvider: TimelineProvider {
    @MainActor
    func placeholder(in context: Context) -> RemainingSpentBudgetEntry {
        RemainingSpentBudgetEntry(date: Date(), monthBudget: getMonthBudget())
    }

    @MainActor
    func getSnapshot(in context: Context, completion: @escaping (RemainingSpentBudgetEntry) -> ()) {
        let entry = RemainingSpentBudgetEntry(date: Date(), monthBudget: getMonthBudget())
        completion(entry)
    }

    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RemainingSpentBudgetEntry] = []
        entries.append(RemainingSpentBudgetEntry(date: Date(), monthBudget: getMonthBudget()))
        
        let date = Date()
        let nextDate = date.addingTimeInterval(60)
        
        let timeline = Timeline(entries: entries, policy: .after(nextDate))
        completion(timeline)
    }
    
    @MainActor
    private func getMonthBudget() -> MonthBudget? {
        let modelContainer = try? ModelContainer(for: MonthBudget.self)
        let descriptor = FetchDescriptor<MonthBudget>(sortBy: [SortDescriptor(\MonthBudget.creationDate, order: .forward)])
        let monthBudgets = try? modelContainer?.mainContext.fetch(descriptor)
        return monthBudgets?.last ?? nil
    }
}

struct RemainingSpentBudgetEntry: TimelineEntry {
    let date: Date
    let monthBudget: MonthBudget?
}

struct RemainingSpentWidgetView : View {
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    var entry: RemainingSpentProvider.Entry

    var body: some View {
        if let monthBudget = entry.monthBudget {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(entry.monthBudget?.monthDesignation ?? "Month")
                }
                .font(.caption)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Remaining")
                            .font(.subheadline)
                        let color = monthBudget.remaining < 0 ? Color(.red) : Color(.green)
                        let currencyCode = monthBudget.currency.code
                        let remainingBudget = monthBudget.remaining 
                        Text("\(remainingBudget.formatted(.currency(code: currencyCode).presentation(.narrow).grouping(.automatic)))")
                            .font(.system(.title, design: .serif, weight: .semibold))
                            .foregroundStyle(color)
                    }
                    
                    if family == .systemMedium || family == .systemLarge {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Spent")
                                .font(.subheadline)
                            let color = Color(.red)
                            let currencyCode = monthBudget.currency.code 
                            let spentBudget = monthBudget.totalSpent 
                            Text("\(spentBudget.formatted(.currency(code: currencyCode).presentation(.narrow).grouping(.automatic)))")
                                .font(.system(.title, design: .serif, weight: .semibold))
                                .foregroundStyle(color)
                        }
                    }
                }
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(entry.date, style: .date)
                            .font(.caption)
                        Text(entry.date, style: .time)
                            .font(.caption)
                    }
                    Spacer()
                    if family == .systemMedium || family == .systemLarge {
                        Link(destination: URL(string: "trentevingt://newtransaction/"+"\(monthBudget.identifier.uuidString)")!){
                            Button {
                            } label: {
                                Label("Add transaction", systemImage: "plus")
                                    .foregroundStyle(colorScheme == .light ? .white : .black)
                                    .font(.system(.caption, design: .serif, weight: .bold))
                            }
                            .buttonBorderShape(.capsule)
                            .buttonStyle(.borderedProminent)
                            .tint(colorScheme == .light ? Color(.black) : Color(.white))
                        }
                    }
                }
                
                if family == .systemLarge {
                    VStack(alignment: .leading, spacing: 10) {
                        if let transactions = entry.monthBudget?.transactions?.sorted(by: { return $0.addedDate > $1.addedDate }) {
                            ForEach(Array(transactions.prefix(3))) { transaction in
                                Divider()
                                TransactionRowView(transaction: transaction, currency: monthBudget.currency)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
        } else {
            Text("Start tracking your budget by opening TrenteVingt!")
        }
    }
}

struct RemainingSpentWidget: Widget {
    let kind: String = "Remaining or Spent budget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RemainingSpentProvider()) { entry in
            RemainingSpentWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Remaining / Spent budget")
        .description("See how much money remains for the month, or how much you spent.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

/*
#Preview(as: .systemSmall) {
    TrenteVingtWidgets()
} timeline: {
    //BudgetEntry(date: Date(), remainingBudget: 999, currencyCode: "EUR", month: "January")
}*/
