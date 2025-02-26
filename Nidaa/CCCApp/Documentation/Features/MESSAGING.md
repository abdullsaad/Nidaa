# Messaging System

## Overview
The messaging system provides secure, HIPAA-compliant communication between healthcare professionals.

## Features

### 1. Message Types
```swift
enum MessageType: String, Codable {
    case text
    case image
    case document
    case audio
    case video
    case emergency
}
```

### 2. Message Status
```swift
enum MessageStatus: String, Codable {
    case sending
    case sent
    case delivered
    case read
    case failed
}
```

### 3. Attachments
```swift
struct Attachment: Identifiable, Codable {
    let id: UUID
    let url: URL
    let type: AttachmentType
    let size: Int64
    let filename: String
}
```

## Implementation

### 1. Message Sending
```swift
final class MessageManager {
    func sendMessage(
        to recipient: User,
        content: String,
        attachments: [Attachment] = []
    ) async throws -> Message {
        // 1. Encrypt message
        let encrypted = try securityManager.encryptMessage(content)
        
        // 2. Upload attachments
        let secureAttachments = try await uploadAttachments(attachments)
        
        // 3. Send message
        let message = try await apiClient.send(
            encrypted,
            attachments: secureAttachments
        )
        
        return message
    }
}
```

### 2. Message Reception
```swift
final class MessageReceiver {
    func handleIncomingMessage(_ encrypted: EncryptedMessage) async throws {
        // 1. Decrypt message
        let message = try securityManager.decryptMessage(encrypted)
        
        // 2. Validate sender
        try await validateSender(message.senderId)
        
        // 3. Store message
        try await storageManager.saveMessage(message)
        
        // 4. Notify UI
        NotificationCenter.default.post(
            name: .newMessageReceived,
            object: message
        )
    }
}
```

### 3. Message Storage
```swift
final class MessageStorage {
    func saveMessage(_ message: Message) throws {
        // 1. Encrypt for storage
        let encrypted = try securityManager.encryptForStorage(message)
        
        // 2. Store in database
        try database.save(encrypted)
        
        // 3. Update indexes
        try updateMessageIndexes(message)
    }
}
``` 