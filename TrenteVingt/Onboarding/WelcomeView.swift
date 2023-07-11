import SwiftUI

struct WelcomeView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Welcome to TrenteVingt")
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text("The easiest budget tracker")
                .font(.system(.headline, design: .serif, weight: .semibold))
            Spacer()
            HStack {
                Spacer()
                Button {
                    selectedTab += 1
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
