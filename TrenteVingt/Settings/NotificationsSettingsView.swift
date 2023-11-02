import SwiftUI
import UserNotifications

struct NotificationsSettingsView: View {
    @State private var notificationsAreOn: Bool = true
    @State private var notificationsStatus: UNAuthorizationStatus?
    
    @State private var hours: Int = 18
    @State private var minutes: Int = 0
    
    @State private var dummyDate: Date = Date()
    
    var body: some View {
        List {
            Text("TrenteVingt can remind you to log new transactions each day at a time you chose.")
            
            if notificationsStatus == .authorized {
                Section {
                    Toggle("Turn on daily reminders?", isOn: $notificationsAreOn)
                        .onChange(of: notificationsAreOn) {
                            guard notificationsAreOn else {
                                NotificationHandler.shared.cancelAllNotifications{}
                                return
                            }
                            updateHoursMinutesInMemory()
                            NotificationHandler.shared.scheduleDailyNotifications()
                            storeNotificationsAreOn()
                        }
                }
                if notificationsAreOn {
                    Section("Time") {
                        HStack {
                            Picker("Hours", selection: $hours) {
                                ForEach(0..<24) { i in
                                    Text("\(i)").tag(i)
                                }
                            }
                            .pickerStyle(.wheel)
                            .onChange(of: hours) {
                                updateHoursMinutesInMemory()
                                NotificationHandler.shared.scheduleDailyNotifications()
                            }
                            Text(":")
                            Picker("Minutes", selection: $minutes) {
                                ForEach(0..<13) { i in
                                    Text("\(i*5)").tag(i*5)
                                }
                            }
                            .pickerStyle(.wheel)
                            .onChange(of: minutes) {
                                updateHoursMinutesInMemory()
                                NotificationHandler.shared.scheduleDailyNotifications()
                            }
                        }
                        .frame(height: 120)
                        Text("Each day, TrenteVingt will remind you to log your transactions at \(hours):\(String(format: "%02d", minutes)).")
                    }
                }
                
            } else if notificationsStatus == .denied {
                Section("Notification Settings") {
                    Text("You disabled notifications for TrenteVingt. You can turn them on in the Settings app.")
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    } label: {
                        Label("Turn on notifications in Settings", systemImage: "bell")
                    }
                }
            }
        }
        .navigationTitle("Daily Reminders")
        .onAppear {
            NotificationHandler.shared.requestAuthorization()
            getNotificationStatus()
            retrieveHoursMinutes()
            retrieveNotificationsAreOn()
        }
    }
    
    func getNotificationStatus() -> Void {
        NotificationHandler.shared.checkAuthorizationStatus { status in
            notificationsStatus = status
        }
    }
    
    func retrieveHoursMinutes() -> Void {
        hours = UserDefaults.standard.integer(forKey: "hoursNotification")
        minutes = UserDefaults.standard.integer(forKey: "minutesNotification")
    }
    
    func updateHoursMinutesInMemory() -> Void {
        UserDefaults.standard.set(hours, forKey: "hoursNotification")
        UserDefaults.standard.set(minutes, forKey: "minutesNotification")
    }
    
    func storeNotificationsAreOn() -> Void {
        UserDefaults.standard.set(notificationsAreOn, forKey: "notificationsAreOn")
    }
    
    func retrieveNotificationsAreOn() -> Void {
        notificationsAreOn = UserDefaults.standard.bool(forKey: "notificationsAreOn")
    }
}

#Preview {
    NotificationsSettingsView()
}
