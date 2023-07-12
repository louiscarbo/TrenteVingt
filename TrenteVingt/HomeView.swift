import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Query var monthBudgets: [MonthBudget]
    
    var currentBudget: MonthBudget {
        monthBudgets.last!
    }
    @AppStorage("showOnboarding") private var showOnboarding = true
    @State private var showNewTransaction = false
    @State private var selection: Int = 1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                Text("You reached the end!")
                ForEach(monthBudgets.indices, id:\.self) { index in
                    MonthView(monthBudget: monthBudgets[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onAppear {
                selection = monthBudgets.count - 1
            }
            Button {
                showNewTransaction = true
            } label: {
                Label("Add transaction", systemImage: "plus")
                    .foregroundStyle(.white)
                    .font(.system(.title2, design: .serif, weight: .semibold))
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .tint(colorScheme == .light ? Color(.black) : Color(.systemGray6))
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showOnboarding, content: {
            OnboardingScreen(showOnboarding: $showOnboarding)
        })
        .sheet(isPresented: $showNewTransaction, content: {
            NewTransactionView(currentBudget: currentBudget)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium, .large])
        })
    }
}

#Preview {
    HomeView()
        .modelContainer(for: MonthBudget.self)
}
