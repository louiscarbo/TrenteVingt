import SwiftUI

struct OnboardingScreen: View {
    @Binding var showOnboarding: Bool
    @State var selectedTab: Int = 1
    
    @State var newMonthBudget = MonthBudget()

    var body: some View {
        TabView(selection: $selectedTab) {
            WelcomeView(selectedTab: $selectedTab).tag(1)
            MonthlyDisposableIncomeView(selectedTab: $selectedTab, monthBudget: newMonthBudget).tag(2)
            BudgetRepartitionView(newMonthBudget: newMonthBudget, selectedTab: $selectedTab).tag(3)
            OnboardingNotificationsView(selectedTab: $selectedTab).tag(4)
            ConfirmationView(showOnboarding: $showOnboarding, selectedTab: $selectedTab).tag(5)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut, value: 1)
    }
}

#Preview {
    OnboardingScreen(showOnboarding: .constant(true))
        .modelContainer(for: MonthBudget.self)
}
