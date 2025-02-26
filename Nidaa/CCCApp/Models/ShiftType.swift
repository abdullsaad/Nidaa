import SwiftUI

enum ShiftType: String, Codable, CaseIterable {
    case day = "Day Shift"
    case evening = "Evening Shift"
    case night = "Night Shift"
    case onCall = "On Call"
    
    var timeRange: String {
        switch self {
        case .day: return "7:00 AM - 3:00 PM"
        case .evening: return "3:00 PM - 11:00 PM"
        case .night: return "11:00 PM - 7:00 AM"
        case .onCall: return "24 Hours"
        }
    }
    
    var color: Color {
        switch self {
        case .day: return .blue
        case .evening: return .orange
        case .night: return .purple
        case .onCall: return .green
        }
    }
} 