import SwiftUI

struct SettingsView: View {
    @State private var showCredits = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Preferences") {
                    NavigationLink {
                        NotificationsSettingsView()
                    } label: {
                        Label("Daily Reminders", systemImage: "bell")
                    }
                    NavigationLink {
                        MonthStartingDayView()
                    } label: {
                        Label("Month Starting Day", systemImage: "calendar.badge.clock")
                    }
                }
                
                Section("About TrenteVingt") {
                    NavigationLink {
                        CreditsView()
                    } label: {
                        Label("App Credits", systemImage: "scroll")
                    }
                    
                    Button {
                        let mailTo = String(localized: "mailto:TrenteVingt@carbo-estaque.fr?subject=TrenteVingt Feedback").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let mailToUrl = URL(string: mailTo!)!
                        if UIApplication.shared.canOpenURL(mailToUrl) {
                                UIApplication.shared.open(mailToUrl, options: [:])
                        }
                    } label: {
                        Label("Contact me", systemImage: "message")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}