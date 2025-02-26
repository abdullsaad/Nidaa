import Foundation

enum MessageFilter: String, CaseIterable {
    case all
    case unread
    case alerts
    case broadcasts
    
    var title: String {
        rawValue.capitalized
    }
} 