import SwiftUI

struct ConfirmationView: View {
    @Binding var showOnboarding: Bool
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            Spacer()
            Image(colorScheme == .light ? "confirmation" : "confirmation-dark")
                .resizable()
                .frame(maxWidth: 336, maxHeight: 400)
                .offset(x: 100)
            Text("We're all set!")
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text("You can now start easily tracking your budget with TrenteVingt.")
                .font(.system(.headline, design: .serif, weight: .semibold))
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                showOnboarding = false
            } label: {
                Text("Start Tracking")
                    .font(.system(.title, design: .serif))
                    .foregroundStyle(.white)
            }
            .tint(.black)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            Button {
                selectedTab -= 1
            } label: {
                Text("Previous")
                    .font(.system(.headline, design: .serif))
                    .foregroundStyle(.white)
            }
            .tint(.black)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            Spacer()
        }
    }
}

/*
#Preview {
    ConfirmationView()
}*/
