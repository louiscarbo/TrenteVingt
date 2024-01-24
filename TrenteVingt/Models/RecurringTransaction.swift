import Foundation
import SwiftData

@Model
final class RecurringTransaction {
    var identifier = UUID()
    var transaction: Transaction?
    var recurrenceDetails: RecurrenceDetails = RecurrenceDetails(recurrenceType: .monthly, day: 1)
    var archived: Bool = false
    var lastScheduledNotificationDate: Date?
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    var nextRecurrenceDate: Date {
        let now = Date()
        var dateComponents = DateComponents()
        
        switch recurrenceDetails.recurrenceType {
        case .weekly:
            guard let dayOfWeek = recurrenceDetails.day else {
                fatalError("Day of week must be set for weekly recurrence")
            }
            dateComponents.weekday = convertEuropeanToAmericanWeekday(dayOfWeek)
            guard let nextDate = Calendar.current.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTime) else {
                fatalError("Could not calculate next date")
            }
            return nextDate
        case .monthly:
            guard let dayOfMonth = recurrenceDetails.day else {
                fatalError("Day of month must be set for monthly recurrence")
            }
            dateComponents.day = min(dayOfMonth, Calendar.current.range(of: .day, in: .month, for: now)?.count ?? 31)
            dateComponents.month = Calendar.current.component(.month, from: now) + 1
            guard let nextDate = Calendar.current.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTime) else {
                fatalError("Could not calculate next date")
            }
            return nextDate
        case .yearly:
            guard let startingDate = recurrenceDetails.startingDate else {
                fatalError("Starting date must be set for yearly recurrence")
            }
            dateComponents.year = Calendar.current.component(.year, from: now) + 1
            dateComponents.month = Calendar.current.component(.month, from: startingDate)
            dateComponents.day = Calendar.current.component(.day, from: startingDate)
            guard let nextDate = Calendar.current.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTime) else {
                fatalError("Could not calculate next date")
            }
            return nextDate
        }
    }
}

enum RecurrenceType: Codable, CaseIterable, Identifiable {
    case weekly
    case monthly
    case yearly
    
    var id: RecurrenceType { self }
    var designation: String {
        switch self {
        case .yearly: return String(localized: "Yearly")
        case .monthly: return String(localized: "Monthly")
        case .weekly: return String(localized: "Weekly")
        }
    }
}

struct RecurrenceDetails: Codable {
    var recurrenceType: RecurrenceType = .monthly
    var day: Int? // Date or day of the week
    var startingDate: Date? // Date for .everyXMonths and .yearly
}

public func getMonth(from integer: Int) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    
    guard let date = Calendar.current.date(bySetting: .month, value: integer, of: Date()) else {
        return nil
    }
    
    return formatter.string(from: date)
}

public func getDayOfWeek(from integer: Int) -> String {
    
    switch(integer) {
    case 1: return String(localized: "Monday")
    case 2: return String(localized: "Tuesday")
    case 3: return String(localized: "Wednesday")
    case 4: return String(localized: "Thursday")
    case 5: return String(localized: "Friday")
    case 6: return String(localized: "Saturday")
    case 7: return String(localized: "Sunday")
    default: return String(localized: "Erreur")
    }
    
}

func setLastScheduledNotificationDate(atDate date: Date, for recurringTransaction: RecurringTransaction) {
    recurringTransaction.lastScheduledNotificationDate = date
}

func convertEuropeanToAmericanWeekday(_ europeanWeekday: Int) -> Int {
    let americanWeekday = europeanWeekday % 7 + 1
    return americanWeekday
}
