# Messaging API

## Overview
Secure messaging endpoints for HIPAA-compliant communication.

## Endpoints

### Send Message
```http
POST /messages
Content-Type: application/json
Authorization: Bearer token

{
    "recipientId": "uuid",
    "content": "encrypted_content",
    "type": "text",
    "attachments": [{
        "id": "uuid",
        "type": "image",
        "url": "https://..."
    }]
}

Response:
{
    "id": "uuid",
    "senderId": "uuid",
    "recipientId": "uuid",
    "content": "encrypted_content",
    "timestamp": "2024-01-20T10:00:00Z",
    "status": "sent"
}
```

### Get Messages
```http
GET /messages?limit=20&before=timestamp
Authorization: Bearer token

Response:
{
    "messages": [{
        "id": "uuid",
        "senderId": "uuid",
        "recipientId": "uuid",
        "content": "encrypted_content",
        "timestamp": "2024-01-20T10:00:00Z",
        "status": "delivered"
    }],
    "hasMore": true
}
```

### Update Message Status
```http
PUT /messages/{id}/status
Authorization: Bearer token
Content-Type: application/json

{
    "status": "read"
}

Response: 204 No Content
```

## Implementation

### Swift Usage
```swift
final class MessageAPI {
    func sendMessage(_ message: Message) async throws -> Message {
        // Encrypt message
        let encrypted = try securityManager.encryptMessage(message)
        
        // Send to API
        return try await apiClient.request(
            endpoint: .messages,
            method: .post,
            body: encrypted
        )
    }
    
    func fetchMessages(
        limit: Int = 20,
        before: Date? = nil
    ) async throws -> [Message] {
        let response = try await apiClient.request(
            endpoint: .messages,
            method: .get,
            query: [
                "limit": limit,
                "before": before?.ISO8601Format()
            ]
        )
        
        return try response.messages.map {
            try securityManager.decryptMessage($0)
        }
    }
}
```

### WebSocket Events
```swift
enum MessageEvent: String {
    case messageSent = "message.sent"
    case messageDelivered = "message.delivered"
    case messageRead = "message.read"
    case messageDeleted = "message.deleted"
}

final class MessageWebSocket {
    func connect() async throws {
        let socket = try await webSocketManager.connect()
        
        for await event in socket.events {
            handle(event)
        }
    }
} 