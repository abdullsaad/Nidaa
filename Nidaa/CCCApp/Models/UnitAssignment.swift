import Foundation
import SwiftData

@Model
final class UnitAssignment {
    var id: UUID
    var userId: UUID
    var wardNumber: String
    var timestamp: Date
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        wardNumber: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.wardNumber = wardNumber
        self.timestamp = timestamp
    }
} 