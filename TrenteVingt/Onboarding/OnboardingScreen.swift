import SwiftUI

struct OnboardingScreen: View {
    @Binding var showOnboarding: Bool
    @State var selectedTab: Int = 1

    var body: some View {
        TabView {
            Color(.blue)
            Color(.red)
            Color(.yellow)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    OnboardingScreen(showOnboarding: .constant(true))
}
