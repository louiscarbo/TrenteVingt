import SwiftUI

struct MonthStartingDayView: View {
    @Environment(\.refresh) private var refresh
    @State private var monthNumber = 1
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("By default, TrenteVingt starts a new month on the 1st of each month. Adjust this in the settings below.")
                }
                
                Section("Day") {
                    Picker("Month Starting Day", selection: $monthNumber) {
                        ForEach(1..<32) { i in
                            Text("\(i)").tag(i)
                        }
                    }
                    .onChange(of: monthNumber) {
                        UserDefaults.standard.set(monthNumber, forKey: "refreshDayNumber")
                        scheduleAppRefresh()
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                    .onAppear {
                        monthNumber = UserDefaults.standard.integer(forKey: "refreshDayNumber")
                    }
                    
                    let nextMonthStartDay = nextDateForDay(monthNumber)
                    Text("The next month will start on \(nextMonthStartDay.formatted(date: .complete, time: .omitted))")
                }
            }
            .navigationTitle("Month Starting Day")
        }
    }
}

#Preview {
    MonthStartingDayView()
}
