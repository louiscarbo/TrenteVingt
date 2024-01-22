import UserNotifications

public class NotificationHandler {
    
    static let shared = NotificationHandler()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    let NotificationStyles = [
        NotificationStyle(title: String(localized:"🔔 Friendly Reminder"), body: String(localized:"Hey! Do you have 1 minute to log today's transactions?")),
        NotificationStyle(title: String(localized:"⏰ Just a Moment!"), body: String(localized:"Logging a transaction takes less than a minute. Open TrenteVingt and let's keep that budget in check!")),
        NotificationStyle(title: String(localized:"🌟 Quick Check-in"), body: String(localized:"Have you logged your expenses today? Let's do it now! It's a breeze!")),
        NotificationStyle(title: String(localized:"🚀 On the Right Track"), body: String(localized:"Keep your budget goals clear by logging today's transactions. It's fast!")),
        NotificationStyle(title: String(localized:"🤓 Budget Buddy"), body: String(localized:"A quick log now makes budgeting smoother later. Let's update your budget now!")),
        NotificationStyle(title: String(localized:"💼 Finances First"), body: String(localized:"Take a quick sec to log today's spendings. It's the key to mastering your budget!")),
        NotificationStyle(title: String(localized:"📊 Quick Update?"), body: String(localized:"Let's make sure we're on track. Log today's transactions in a jiffy!")),
        NotificationStyle(title: String(localized:"💰 Money Mindset"), body: String(localized:"Remember, every log helps you stay in control. Spare a minute?")),
        NotificationStyle(title: String(localized:"📆 Daily Check"), body: String(localized:"Consistency is key! Ready to log today's expenses?")),
        NotificationStyle(title: String(localized:"🎉 Budget Boost"), body: String(localized:"Give your budget a little boost. Log today's transactions, it's quick and easy!")),
        NotificationStyle(title: String(localized:"✨ Finance Flash"), body: String(localized:"A flash update can make all the difference. Ready for a quick log?")),
        NotificationStyle(title: String(localized:"🎯 On Target?"), body: String(localized:"Stay on target with your budget goals. Quick log today's expenses?")),
        NotificationStyle(title: String(localized:"🧠 Mindful Money"), body: String(localized:"Being mindful of our spendings helps you stay on track. Time for a quick update?")),
        NotificationStyle(title: String(localized:"🕰 Time's Ticking"), body: String(localized:"A minute now saves stress later. Let's quickly log today's transactions!")),
        NotificationStyle(title: String(localized:"🎈 Little Steps"), body: String(localized:"Every little step counts. Let's log today's transactions and keep moving forward!"))
    ]

    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func requestAuthorization(completion: @escaping () -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            }
            // Call the completion handler regardless of the result to proceed with the next step.
            completion()
        }
    }
    
    func scheduleNewMonthNotification(atDate: Date) {
        print("Scheduling new month notification.")
        
        let content = UNMutableNotificationContent()
        content.title = String(localized:"🚀 New Month, New Goals")
        content.body = String(localized:"Hey there! A new month just started. Let's get those budgeting goals in place!")
        content.sound = .default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: atDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let identifier = "monthStarts"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyNotifications() {
        print("Requests notifications scheduling")
        cancelAllNotifications {
            // Fetching hour and minute values from UserDefaults
            let hour = UserDefaults.standard.integer(forKey: "hoursNotification")
            let minute = UserDefaults.standard.integer(forKey: "minutesNotification")
            
            for day in 0...6 { // For the next 60 days
                let notificationStyle = self.NotificationStyles.randomElement()!
                
                let content = UNMutableNotificationContent()
                content.title = notificationStyle.title
                content.body = notificationStyle.body
                content.sound = .default
                
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute
                if let futureDate = Calendar.current.date(byAdding: .day, value: day, to: Date()) {
                    // Extract the day component from that future date
                    dateComponents.day = Calendar.current.component(.day, from: futureDate)
                    dateComponents.month = Calendar.current.component(.month, from: futureDate)
                }
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let identifier = UUID().uuidString // Unique identifier for each notification
                
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                self.notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            }
            
            let content = UNMutableNotificationContent()
            content.title = String(localized: "😢 Bye bye...")
            content.body = String(localized: "It's been a week since you didn't open the app. We'll stop sending you notifications from now on.")
            content.sound = .default
            
            let futureDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            if let futureDate = futureDate {
                dateComponents.day = Calendar.current.component(.day, from: futureDate)
                dateComponents.month = Calendar.current.component(.month, from: futureDate)
            }

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let identifier = UUID().uuidString // Unique identifier for each notification
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
            
            /* DEBUG
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
                print("Count: \(notifications.count)")
                print(notifications.first)
                print(notifications.last)
            }*/
        }
    }
    
    func scheduleRecurringTransactionNotification(recurringTransaction: RecurringTransaction) {
        print("Scheduling a new recurring transaction notification.")
        
        let transaction = recurringTransaction.transaction
        
        let content = UNMutableNotificationContent()
        if let title = transaction?.title {
            content.title = "⌛️ " + title
        } else {
            content.title = "⌛️ Recurring Transaction"
        }
        content.body = String(localized:"This transaction is set for today. Open TrenteVingt to confirm it!")
        content.sound = .default
                
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        var trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute, .month, .day, .year], from: Date().addingTimeInterval(TimeInterval(9999))), repeats: false)
        
        switch(recurringTransaction.recurrenceDetails.recurrenceType) {
        case .weekly:
            dateComponents.weekday = convertEuropeanToAmericanWeekday(recurringTransaction.recurrenceDetails.day!)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        case .monthly:
            dateComponents.day = recurringTransaction.recurrenceDetails.day
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        case .yearly:
            if let startingDate = recurringTransaction.recurrenceDetails.startingDate {
                dateComponents = Calendar.current.dateComponents([.day, .month], from: startingDate)
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            }
        }
                
        let identifier = "recurring" + recurringTransaction.identifier.entityIdentifierString
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    // TODO Don't cancel recurring transactions
    // 4. Cancel All  daily Notifications
    func cancelAllNotifications(completion: @escaping () -> Void) {
        notificationCenter.removeAllPendingNotificationRequests()
        
        notificationCenter.getPendingNotificationRequests { (requests) in
            // Filter out the request with identifier "monthStarts"
            if let requestsToKeep = requests.first(where: { $0.identifier == "monthStarts"  || $0.identifier.contains("recurring")}) {
                // Remove all pending notifications
                self.notificationCenter.removeAllPendingNotificationRequests()
                
                // Re-add the requests to keep
                self.notificationCenter.add(requestsToKeep, withCompletionHandler: { (error) in
                    if let error = error {
                        print("Error re-adding notification: \(error)")
                    }
                    completion()
                })
            } else {
                // If there's no monthStarts notification, just remove all
                self.notificationCenter.removeAllPendingNotificationRequests()
                completion()
            }
        }
    }
}

func getNextDate() -> Void {
    var dateComponents = DateComponents()
    dateComponents.day = 31
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    if let nextTriggerDate = trigger.nextTriggerDate()?.formatted(.dateTime) {
        print(nextTriggerDate)
    } else {
        print("Oops!")
    }
}

func convertEuropeanToAmericanWeekday(_ europeanWeekday: Int) -> Int {
    let americanWeekday = (europeanWeekday + 5) % 7 + 1
    return americanWeekday
}

struct NotificationStyle {
    let title: String
    let body: String
}
