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
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (_, error) in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            }
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
    
    // 4. Cancel All Notifications but the one that says that a new month started
    func cancelAllNotifications(completion: @escaping () -> Void) {
        notificationCenter.removeAllPendingNotificationRequests()
        
        notificationCenter.getPendingNotificationRequests { (requests) in
            // Filter out the request with identifier "monthStarts"
            if let monthStartsRequest = requests.first(where: { $0.identifier == "monthStarts" }) {
                // Remove all pending notifications
                self.notificationCenter.removeAllPendingNotificationRequests()
                
                // Re-add the monthStarts notification
                self.notificationCenter.add(monthStartsRequest, withCompletionHandler: { (error) in
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

struct NotificationStyle {
    let title: String
    let body: String
}
