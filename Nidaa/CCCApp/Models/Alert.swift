import Foundation
import SwiftData

@Model
final class Alert {
    var id: UUID
    var type: AlertType
    var message: String
    var timestamp: Date
    var isActive: Bool
    var location: String?
    
    init(
        id: UUID = UUID(),
        type: AlertType,
        message: String,
        location: String? = nil,
        timestamp: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.type = type
        self.message = message
        self.location = location
        self.timestamp = timestamp
        self.isActive = isActive
    }
}

enum AlertType: String, Codable {
    case critical
    case urgent
    case normal
    case info
} 