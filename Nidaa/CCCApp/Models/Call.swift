import Foundation

struct Call: Identifiable {
    let id: UUID
    let initiatorId: UUID
    let recipientId: UUID
    let timestamp: Date
    let type: CallType
    var status: CallStatus
    var duration: TimeInterval?
    
    init(
        id: UUID = UUID(),
        initiatorId: UUID,
        recipientId: UUID,
        type: CallType,
        status: CallStatus = .connecting,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.initiatorId = initiatorId
        self.recipientId = recipientId
        self.type = type
        self.status = status
        self.timestamp = timestamp
    }
}

enum CallType: String, Codable {
    case voice
    case video
}

enum CallStatus {
    case connecting
    case ringing
    case connected
    case ended
    case declined
    case missed
    case failed
} 