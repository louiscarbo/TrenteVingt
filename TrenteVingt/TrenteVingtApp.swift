import SwiftUI
import SwiftData
import BackgroundTasks
import UserNotifications
import WidgetKit
import TipKit

@main
struct TrenteVingtApp: App {
    var body: some Scene {
        WindowGroup {
            AllMonthsView()
                .modelContainer(for: MonthBudget.self)
                .onAppear {
                    scheduleAppRefresh()
                }
        }
        .backgroundTask(.appRefresh("NewMonth")) {
            await startNewMonthInBackground()
        }
    }
    
    init() {
        print("Notifications are on : \(UserDefaults.standard.bool(forKey: "notificationsAreOn"))")
        if UserDefaults.standard.bool(forKey: "notificationsAreOn") {
            NotificationHandler.shared.scheduleDailyNotifications()
        }
        try? Tips.configure()
        updateMonthBudgetsValues()
    }
    
    @MainActor func startNewMonthInBackground() async {
        print("Background task is running.")
        
        if let container = try? ModelContainer(for: MonthBudget.self) {
            let context = container.mainContext
            let monthBudgetsFetchDescriptor = FetchDescriptor<MonthBudget>()
            let monthBudgets = try? context.fetch(monthBudgetsFetchDescriptor)
            
            guard let modelMonthBudget = monthBudgets?.last else {
                return
            }
            let newMonthBudget = MonthBudget()
            
            // Crée le nouveau mois et l'insère dans la mémoire
            let newMonthNumber : Int = nextMonthNumber(from: modelMonthBudget.monthNumber) ?? modelMonthBudget.monthNumber
            newMonthBudget.monthlyBudget = modelMonthBudget.monthlyBudget
            newMonthBudget.needsBudgetRepartition = modelMonthBudget.needsBudgetRepartition
            newMonthBudget.wantsBudgetRepartition = modelMonthBudget.wantsBudgetRepartition
            newMonthBudget.savingsDebtsBudgetRepartition = modelMonthBudget.savingsDebtsBudgetRepartition
            newMonthBudget.currencySymbolSFName = modelMonthBudget.currencySymbolSFName
            newMonthBudget.monthNumber = newMonthNumber
            context.insert(newMonthBudget)
            newMonthBudget.update()
            
            // Programmer une notification à la nouvelle date, en dehors de la nuit
            let currentHour = Calendar.current.component(.hour, from: Date())
            var notificationDate = Date().addingTimeInterval(120)
            if currentHour < 7 || currentHour >= 22 {
                notificationDate = setTo9AM(from: Date())
            }
            NotificationHandler.shared.scheduleNewMonthNotification(atDate: notificationDate)
            
            WidgetCenter.shared.reloadAllTimelines()
            
            return
        }
    }
    
    @MainActor func updateMonthBudgetsValues() {
        if let container = try? ModelContainer(for: MonthBudget.self, Transaction.self, RecurringTransaction.self) {
            let context = container.mainContext
            let monthBudgetsFetchDescriptor = FetchDescriptor<MonthBudget>()
            
            if let monthBudgets = try? context.fetch(monthBudgetsFetchDescriptor) {
                for monthBudget in monthBudgets {
                    monthBudget.update()
                }
            }
            
            // DEBUG
//            if let recurrings = try? context.fetch(FetchDescriptor<RecurringTransaction>()) {
//                for recurring in recurrings {
//                    context.delete(recurring)
//                    NotificationHandler.shared.cancelRecurringTransactionNotification(completion: {}, recurringTransaction: recurring)
//                    print("Deleted \(recurring.transaction?.title ?? "TITLE") of type \(recurring.recurrenceDetails.recurrenceType)")
//                }
//            }
        }
    }

    func setTo9AM(from date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        // Extract the components from the given date
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        
        // Set the hour to 9 AM
        components.hour = 9
        components.minute = 0
        components.second = 0
        
        // Create a new date based on these components
        if let targetDate = calendar.date(from: components) {
            // If 9 AM has already passed for today, move to the next day
            if targetDate <= date {
                components.day! += 1
            }
            
            // Generate the new target date
            if let nextDate = calendar.date(from: components) {
                return nextDate
            } else {
                fatalError("Unable to calculate the next 9 AM.")
            }
        } else {
            fatalError("Unable to create a target date.")
        }
    }
}
