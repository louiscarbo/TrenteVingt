import SwiftUI
import SwiftData

@main
struct TrenteVingtApp: App {

    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: MonthBudget.self)
        }
    }
}
