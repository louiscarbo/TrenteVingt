import SwiftUI
import SwiftData
import WidgetKit
import StoreKit

struct AllMonthsView: View {
    @Query var monthBudgets: [MonthBudget]
    
    @AppStorage("showOnboarding") private var showOnboarding = true
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.requestReview) var requestReview
    
    @State private var isPresentingNewMonthView = false
    @State private var showDeletionAlert = false
    @State private var navigateToLatestMonth = false
    @State private var showSettings = false
    @State private var monthBudgetToDelete: MonthBudget?
    @State private var currentMonth: MonthBudget?
    
    @State private var updateView = false
    
    private var monthBudgetsInDisplay: [MonthBudget] {
        Array(monthBudgets.reversed().dropFirst())
    }

    var body: some View {
        NavigationStack {
            if monthBudgets.count > 0 && !showOnboarding {
                List {
                    Section("Current Month") {
                        NavigationLink {
                            MonthView(monthBudget: monthBudgets.last ?? MonthBudget())
                        } label: {
                            CurrentMonthView(currentMonth: monthBudgets.last ?? MonthBudget())
                                .id(updateView)
                                .onChange(of: monthBudgets) {
                                    updateView.toggle()
                                }
                        }
                        .swipeActions {
                            Button {
                                withAnimation {
                                    showDeletionAlert.toggle()
                                    monthBudgetToDelete = monthBudgets.last!
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .symbolVariant(.fill)
                            }
                            .tint(.red)
                        }
                        .confirmationDialog(
                            Text("Deleting this month will also delete all associated transactions. This action is definitive."),
                            isPresented: $showDeletionAlert,
                            titleVisibility: .visible
                        ) {
                            Button("Delete", role: .destructive) {
                                withAnimation {
                                    modelContext.delete(monthBudgetToDelete ?? monthBudgets.last!)
                                    WidgetCenter.shared.reloadAllTimelines()
                                }
                            }
                        }
                    }
                    if monthBudgetsInDisplay.count >= 1 {
                        Section("Archived months") {
                            ForEach(monthBudgetsInDisplay) { monthBudget in
                                NavigationLink {
                                    MonthView(monthBudget: monthBudget)
                                } label: {
                                    MonthRowView(monthBudget: monthBudget, remaining: monthBudget.remaining, monthDesignation: monthBudget.monthDesignation)
                                }
                                .swipeActions {
                                    Button {
                                        withAnimation {
                                            showDeletionAlert.toggle()
                                            monthBudgetToDelete = monthBudget
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            .symbolVariant(.fill)
                                    }
                                    .tint(.red)
                                }
                                .confirmationDialog(
                                    Text("Deleting this month will also delete all associated transactions. This action is definitive."),
                                    isPresented: $showDeletionAlert,
                                    titleVisibility: .visible
                                ) {
                                    Button("Delete", role: .destructive) {
                                        withAnimation {
                                            modelContext.delete(monthBudgetToDelete ?? monthBudget)
                                            WidgetCenter.shared.reloadAllTimelines()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Section {
                        Button {
                            isPresentingNewMonthView = true
                        } label: {
                            Label("Start a new month", systemImage: "calendar.badge.plus")
                        }
                        .sheet(isPresented: $isPresentingNewMonthView) {
                            NewMonthView(
                                modelMonthBudget: monthBudgets.last!,
                                isPresentingNewMonthView: $isPresentingNewMonthView
                            )
                        }
                    }
                }
                .toolbar {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                }
                .navigationTitle("All Months")
                .navigationDestination(isPresented: $navigateToLatestMonth) {
                    MonthView(monthBudget: monthBudgets.last!)
                }
                .navigationDestination(isPresented: $showSettings) {
                    SettingsView()
                }
                .onAppear {
                    navigateToLatestMonth = true
                }
            } else {
                VStack {
                    Text("Welcome to TrenteVingt!")
                    Button("Start tracking my budget") {
                        showOnboarding = true
                    }
                    .font(.system(.title2, design: .serif, weight: .semibold))
                    .foregroundStyle(colorScheme == .light ? .white : .black)
                    .tint(colorScheme == .light ? .black : .white)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .sheet(isPresented: $showOnboarding, content: {
                        OnboardingScreen(showOnboarding: $showOnboarding)
                    })
                }
                .padding()
            }
        }
        .onAppear {
            if monthBudgets.count > 1 {
                requestReview()
            }
        }
    }
}

struct CurrentMonthView: View {
    @State var currentMonth: MonthBudget
    
    var body: some View {
        VStack(alignment: .leading) {
            MonthRowView(monthBudget: currentMonth, remaining: currentMonth.remaining, monthDesignation: currentMonth.monthDesignation)
            
            Divider()
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Remaining")
                            .font(.subheadline)
                        let color = currentMonth.remaining < 0 ? Color(.red) : Color(.green)
                        let currencyCode = currentMonth.currency.code
                        let remainingBudget = currentMonth.remaining
                        Text("\(remainingBudget.formatted(.currency(code: currencyCode).presentation(.narrow).grouping(.automatic)))")
                            .font(.system(.title, design: .serif, weight: .semibold))
                            .foregroundStyle(color)
                    }
                    
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Spent")
                            .font(.subheadline)
                        let color = Color(.red)
                        let currencyCode = currentMonth.currency.code
                        let spentBudget = currentMonth.totalSpent
                        Text("\(spentBudget.formatted(.currency(code: currencyCode).presentation(.narrow).grouping(.automatic)))")
                            .font(.system(.title, design: .serif, weight: .semibold))
                            .foregroundStyle(color)
                    }
                }
            }
        }
    }
}

#Preview {
    AllMonthsView()
        .modelContainer(for: MonthBudget.self)
}
