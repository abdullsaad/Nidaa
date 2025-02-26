import Foundation

enum MessageFilterType: String, CaseIterable {
    case all = "All"
    case unread = "Unread"
    case alerts = "Alerts"
    case broadcasts = "Broadcasts"
} 