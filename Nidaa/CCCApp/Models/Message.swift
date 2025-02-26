import Foundation
import SwiftData

// Move enums outside the class to avoid ambiguity
enum MessageType: String, Codable {
    case text
    case alert
    case broadcast
}

enum MessageStatus: String, Codable {
    case sent
    case delivered
    case read
}

@Model
final class Message: Codable {
    var id: UUID
    var senderId: UUID
    var recipientId: UUID
    var content: String
    var timestamp: Date
    var messageType: MessageType
    var attachments: [Attachment]
    var status: MessageStatus
    var readTimestamp: Date?
    var patientId: UUID?  // Optional reference to related patient
    
    var isRead: Bool {
        readTimestamp != nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, senderId, recipientId, content, timestamp, messageType, attachments, status, readTimestamp, patientId
    }
    
    init(
        id: UUID = UUID(),
        senderId: UUID,
        recipientId: UUID,
        content: String,
        messageType: MessageType = .text,
        attachments: [Attachment] = [],
        status: MessageStatus = .sent,
        timestamp: Date = Date(),
        patientId: UUID? = nil
    ) {
        self.id = id
        self.senderId = senderId
        self.recipientId = recipientId
        self.content = content
        self.messageType = messageType
        self.attachments = attachments
        self.status = status
        self.timestamp = timestamp
        self.patientId = patientId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        senderId = try container.decode(UUID.self, forKey: .senderId)
        recipientId = try container.decode(UUID.self, forKey: .recipientId)
        content = try container.decode(String.self, forKey: .content)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        messageType = try container.decode(MessageType.self, forKey: .messageType)
        attachments = try container.decode([Attachment].self, forKey: .attachments)
        status = try container.decode(MessageStatus.self, forKey: .status)
        readTimestamp = try container.decodeIfPresent(Date.self, forKey: .readTimestamp)
        patientId = try container.decodeIfPresent(UUID.self, forKey: .patientId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(recipientId, forKey: .recipientId)
        try container.encode(content, forKey: .content)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(messageType, forKey: .messageType)
        try container.encode(attachments, forKey: .attachments)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(readTimestamp, forKey: .readTimestamp)
        try container.encodeIfPresent(patientId, forKey: .patientId)
    }
}


