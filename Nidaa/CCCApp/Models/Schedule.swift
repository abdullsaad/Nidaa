import Foundation
import SwiftData

@Model
final class Schedule {
    var id: UUID
    var userId: UUID
    var date: Date
    var type: ScheduleType
    var notes: String?
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        date: Date,
        type: ScheduleType,
        notes: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.date = date
        self.type = type
        self.notes = notes
    }
}

enum ScheduleType: String, Codable, CaseIterable {
    case day = "Day Shift"
    case evening = "Evening Shift"
    case night = "Night Shift"
    case onCall = "On Call"
}

enum ScheduleStatus: String, Codable {
    case scheduled
    case inProgress
    case completed
    case cancelled
}

struct RecurrenceRule: Codable {
    var frequency: Frequency
    var interval: Int
    var endDate: Date?
    var daysOfWeek: Set<DayOfWeek>?
    
    enum Frequency: String, Codable {
        case daily
        case weekly
        case monthly
    }
    
    enum DayOfWeek: Int, Codable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
} 