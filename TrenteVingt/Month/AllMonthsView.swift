import SwiftUI
import SwiftData
import WidgetKit
import StoreKit
import TipKit

struct AllMonthsView: View {
    @Query(sort: [SortDescriptor(\MonthBudget.creationDate, order: .forward)]) var monthBudgets: [MonthBudget]
    
    @AppStorage("showOnboarding") private var showOnboarding = true
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.requestReview) var requestReview
    @AppStorage("showedUpdatePresentation110") private var showedUpdatePresentation = false
    
    @State private var isPresentingNewMonthView = false
    @State private var showDeletionAlert = false
    @State private var navigateToLatestMonth = false
    @State private var showSettings = false
    @State private var monthBudgetToDelete: MonthBudget?
    @State private var currentMonth: MonthBudget?
    
    @State private var updateView = false
    @State private var showRecurringTransactionsSheet = false
    @State private var showUpdatePresentation = false
    
    var tip = CurrentMonthTip()
    
    private var monthBudgetsInDisplay: [MonthBudget] {
        Array(monthBudgets.reversed().dropFirst())
    }

    var body: some View {
        NavigationStack {
            if monthBudgets.count > 0 && !showOnboarding {
                List {
                    Section("Current Month") {
                        NavigationLink {
                            MonthView(monthBudget: monthBudgets.last!)
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
                            TipKit.TipView(tip, arrowEdge: .bottom)
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
                                .swipeActions(edge: .leading) {
                                    Button {
                                        tip.invalidate(reason: .actionPerformed)
                                        withAnimation {
                                            monthBudget.creationDate = Date()
                                        }
                                        WidgetCenter.shared.reloadAllTimelines()
                                    } label: {
                                        Label("Make main month", systemImage: "star")
                                            .symbolVariant(.fill)
                                    }
                                    .tint(.yellow)
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
                NoDataView(showOnboarding: $showOnboarding)
            }
        }
        .onAppear {
            if monthBudgets.count > 1 {
                requestReview()
            }
            if !showedUpdatePresentation && monthBudgets.count > 0 {
                showUpdatePresentation.toggle()
                showedUpdatePresentation = true
            }
        }
        .onOpenURL { url in
            guard
                url.scheme == "trentevingt",
                url.host == "recurringtransactionsevent"
            else {
                return
            }
            showRecurringTransactionsSheet = true
        }
        .sheet(isPresented: $showRecurringTransactionsSheet) {
            RecurringTransactionsExplanations()
        }
        .sheet(isPresented: $showUpdatePresentation) {
            UpdatePresentationView()
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

struct CurrentMonthTip: Tip {
    var title: Text {
        Text("Set the current month")
    }
    var message: Text? {
        Text("You can set any month in the list as the current month by swiping it right. This month will be displayed in the widgets on your home screen.")
    }
    var image: Image? {
        Image(systemName: "hand.draw")
    }
    var options: [Option] {
        MaxDisplayCount(3)
    }
}

#Preview {
    AllMonthsView()
        .modelContainer(for: MonthBudget.self)
}

struct NoDataView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showOnboarding: Bool
    
    var body: some View {
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
