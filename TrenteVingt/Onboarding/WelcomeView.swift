import SwiftUI

struct WelcomeView: View {
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("piggy-bank")
                .resizable()
                .frame(width: 317, height: 380)
                .offset(x: 120, y: 20)
            Text("Welcome to TrenteVingt")
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text("The simplest budget tracker")
                .font(.system(.headline, design: .serif, weight: .semibold))
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        selectedTab += 1
                    }
                } label: {
                    Text("Next")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
            }
            .tint(.black)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .ignoresSafeArea()
        .padding()
    }
}

#Preview {
    WelcomeView(selectedTab: .constant(1))
}
