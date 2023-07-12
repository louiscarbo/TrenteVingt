import SwiftUI

struct OnboardingScreen: View {
    @Binding var showOnboarding: Bool
    @State var selectedTab: Int = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            WelcomeView(selectedTab: $selectedTab)
                .tag(1)
                .toolbar(.hidden, for: .tabBar)
            MonthlyDisposableIncomeView(selectedTab: $selectedTab)
                .tag(2)
                .toolbar(.hidden, for: .tabBar)
            BudgetRepartitionView(selectedTab: $selectedTab)
                .tag(3)
                .toolbar(.hidden, for: .tabBar)
            ConfirmationView(showOnboarding: $showOnboarding, selectedTab: $selectedTab)
                .tag(4)
                .toolbar(.hidden, for: .tabBar)
        }
        .toolbar(.hidden, for: .tabBar)
        .interactiveDismissDisabled()
    }
}

#Preview {
    OnboardingScreen(showOnboarding: .constant(true))
}
