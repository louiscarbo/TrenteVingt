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
    var interval: Int? // Interval in days or months
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

func getNextOccurenceDate(for recurringTransaction: RecurringTransaction) -> Date? {
    let calendar = Calendar.current
    if let lastOccurrence = recurringTransaction.lastScheduledNotificationDate == nil ? recurringTransaction.recurrenceDetails.startingDate : recurringTransaction.lastScheduledNotificationDate {
        if let interval = recurringTransaction.recurrenceDetails.interval {
            if let nextOccurrenceDate = calendar.date(byAdding: .day, value: interval, to: lastOccurrence) {
                return nextOccurrenceDate
            }
        }
    }
   print("Error calculating next occurrence date.")
   return nil
}

func setLastScheduledNotificationDate(atDate date: Date, for recurringTransaction: RecurringTransaction) {
    recurringTransaction.lastScheduledNotificationDate = date
}
