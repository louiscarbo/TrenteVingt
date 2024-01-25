import SwiftUI

struct SettingsView: View {
    @State private var showCredits = false
    @State private var showRecurringTransactionsExplanations = false
    @State private var showUpdatePresentation = false
    @State private var showAboutMe = false
    
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
                        showAboutMe.toggle()
                    } label: {
                        Label("About Me", systemImage: "person")
                    }
                    .sheet(isPresented: $showAboutMe, content: {
                        AboutMe()
                    })
                    
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
                
                Section("Frequently Asked Questions") {
                    Button("What are recurring transactions and how do they work?") {
                        showRecurringTransactionsExplanations.toggle()
                    }
                    .sheet(isPresented: $showRecurringTransactionsExplanations, content: {
                        RecurringTransactionsExplanations()
                    })
                    Button("What are the new features of version 1.1.0?") {
                        showUpdatePresentation.toggle()
                    }
                    .sheet(isPresented: $showUpdatePresentation, content: {
                        UpdatePresentationView()
                    })
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
