import Foundation
import SwiftData

@Model
final class RecurringTransaction {
    var transaction: Transaction?
    var recurrenceDetails: RecurrenceDetails = RecurrenceDetails(recurrenceType: .monthly, day: 1)
    var monthBudgetsWhereAdded: [MonthBudget] = []
    var archived: Bool = false
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
}

enum RecurrenceType: Codable, CaseIterable, Identifiable {
    case everyXDays
    case weekly
    case monthly
    case everyXMonths
    case yearly
    
    var id: RecurrenceType { self }
    var designation: String {
        switch self {
        case .everyXMonths: return String(localized: "Every X months")
        case .yearly: return String(localized: "Yearly")
        case .monthly: return String(localized: "Monthly")
        case .everyXDays: return String(localized: "Every X days")
        case .weekly: return String(localized: "Weekly")
        }
    }
}

struct RecurrenceDetails: Codable {
    var recurrenceType: RecurrenceType
    var interval: Int? // Interval in days or months
    var day: Int? // Date or day of the week
    var month: Int? // Date
}

public func getMonth(from integer: Int) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    
    guard let date = Calendar.current.date(bySetting: .month, value: integer, of: Date()) else {
        return nil
    }
    
    return formatter.string(from: date)
}

public func getDayOfWeek(from integer: Int) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    
    guard let date = Calendar.current.date(bySetting: .weekday, value: integer, of: Date()) else {
        return nil
    }
    
    return formatter.string(from: date)
}

