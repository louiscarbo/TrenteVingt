import WidgetKit
import SwiftUI
import SwiftData

struct Provider: @preconcurrency TimelineProvider {
    
    @MainActor
    func placeholder(in context: Context) -> BudgetEntry {
        BudgetEntry(date: Date(), monthBudget: getMonthBudget())
    }

    @MainActor
    func getSnapshot(in context: Context, completion: @escaping (BudgetEntry) -> ()) {
        let entry = BudgetEntry(date: Date(), monthBudget: getMonthBudget())
        completion(entry)
    }

    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [BudgetEntry] = []
        entries.append(BudgetEntry(date: Date(), monthBudget: getMonthBudget()))

        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 5, to: Date())!

        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
    @MainActor
    private func getMonthBudget() -> MonthBudget? {
        let modelContainer = try? ModelContainer(for: MonthBudget.self)
        let descriptor = FetchDescriptor<MonthBudget>()
        let monthBudgets = try? modelContainer?.mainContext.fetch(descriptor)
        return monthBudgets?.last ?? nil
    }
}

struct BudgetEntry: TimelineEntry {
    let date: Date
    let monthBudget: MonthBudget?
}

struct PieChartWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        PieChartView(showRemaining: .constant(true), monthBudget: entry.monthBudget!)
    }
}

struct PieChartWidget: Widget {
    let kind: String = "Pie Chart Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PieChartWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PieChartWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Pie Chart")
        .description("See how you spent your money with a Pie Chart.")
        .supportedFamilies([.systemLarge])
    }
}

/*
#Preview(as: .systemSmall) {
    TrenteVingtWidgets()
} timeline: {
    //BudgetEntry(date: Date(), remainingBudget: 999, currencyCode: "EUR", month: "January")
}*/
