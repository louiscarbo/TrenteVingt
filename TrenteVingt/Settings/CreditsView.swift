import SwiftUI

struct CreditsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Illustrations") {
                    
                    VStack(alignment: .leading) {
                        Text("App Icon and Onboarding Screen")
                            .font(.headline)
                        Text("Piggy Savings by Vectors Market from Noun Project (CCBY3.0)")
                    }
                    VStack(alignment: .leading) {
                        Text("Onboarding Screen")
                            .font(.headline)
                        Text("Payment Schedule by Vectors Market from Noun Project (CCBY3.0)")
                    }
                    VStack(alignment: .leading) {
                        Text("App Icon and Onboarding Screen")
                            .font(.headline)
                        Text("Financial Report by Vectors Market from Noun Project (CCBY3.0)")
                    }
                }
            }
            .navigationTitle("Credits")
        }
    }
}

#Preview {
    CreditsView()
}
