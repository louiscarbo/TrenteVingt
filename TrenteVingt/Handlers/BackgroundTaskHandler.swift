import BackgroundTasks
import Foundation
        
func scheduleAppRefresh() {
    BGTaskScheduler.shared.cancelAllTaskRequests()
    
    // Get the date for the next refresh
    var refreshDayNumber = UserDefaults.standard.integer(forKey: "refreshDayNumber")
    if refreshDayNumber == 0 { refreshDayNumber = 1 }
    let nextRefreshDate = nextDateForDay(refreshDayNumber)
            
    // Create the request
    let request = BGAppRefreshTaskRequest(identifier: "NewMonth")
    request.earliestBeginDate = nextRefreshDate
    
    // Submit the request
    try? BGTaskScheduler.shared.submit(request)
    
    // DEBUG
//    print("Background task was succesfully scheduled.")
//    print("Refresh day number: \(refreshDayNumber)")
//    print("Corresponding date: \(nextDateForDay(refreshDayNumber))")
}

func nextDateForDay(_ day: Int) -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let currentDate = Date()
    
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
    components.hour = 0
    components.minute = 0
    components.second = 0
    
    if let range = calendar.range(of: .day, in: .month, for: currentDate) {
        let maxDay = range.upperBound - 1
        components.day = min(day, maxDay)
    }
    
    if var targetDate = calendar.date(from: components) {
        if targetDate <= currentDate {
            components.month! += 1
            if components.month! > 12 {
                components.month = 1
                components.year! += 1
            }
            
            if let newDate = calendar.date(from: components),
               let newRange = calendar.range(of: .day, in: .month, for: newDate) {
                let newMaxDay = newRange.upperBound - 1
                components.day = min(day, newMaxDay)
            }
            
            targetDate = calendar.date(from: components)!
        }
        
        return targetDate
    } else {
        fatalError("Unable to calculate the next date.")
    }
}
