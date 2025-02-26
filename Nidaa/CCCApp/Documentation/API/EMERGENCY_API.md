# Emergency API

## Overview
Emergency response and coordination endpoints for healthcare emergencies.

## Endpoints

### Initiate Emergency
```http
POST /emergency/alert
Content-Type: application/json
Authorization: Bearer token

{
    "type": "medical",
    "priority": "high",
    "location": {
        "latitude": 37.7749,
        "longitude": -122.4194,
        "description": "Room 302"
    },
    "details": {
        "patientId": "uuid",
        "condition": "cardiac_arrest",
        "notes": "Patient needs immediate attention"
    }
}

Response:
{
    "emergencyId": "uuid",
    "timestamp": "2024-01-20T10:00:00Z",
    "status": "active",
    "respondingTeam": []
}
```

### Update Emergency Status
```http
PUT /emergency/{id}/status
Authorization: Bearer token
Content-Type: application/json

{
    "status": "responding",
    "responder": {
        "id": "uuid",
        "role": "doctor",
        "eta": "2 minutes"
    }
}
```

### Get Active Emergencies
```http
GET /emergency/active
Authorization: Bearer token

Response:
{
    "emergencies": [{
        "id": "uuid",
        "type": "medical",
        "priority": "high",
        "status": "active",
        "location": {
            "latitude": 37.7749,
            "longitude": -122.4194,
            "description": "Room 302"
        },
        "respondingTeam": [{
            "id": "uuid",
            "name": "Dr. Smith",
            "role": "doctor",
            "status": "en_route"
        }]
    }]
}
```

## Implementation

### Swift Usage
```swift
final class EmergencyManager {
    func initiateEmergency(
        type: EmergencyType,
        location: Location
    ) async throws -> Emergency {
        // 1. Create emergency alert
        let emergency = try await apiClient.request(
            endpoint: .emergency,
            method: .post,
            body: EmergencyRequest(
                type: type,
                location: location
            )
        )
        
        // 2. Notify relevant staff
        try await notificationManager.sendEmergencyAlert(
            emergency
        )
        
        // 3. Start monitoring responses
        startMonitoring(emergency)
        
        return emergency
    }
    
    func respondToEmergency(
        _ emergency: Emergency
    ) async throws {
        // Update emergency status
        try await apiClient.request(
            endpoint: .emergency(emergency.id),
            method: .put,
            body: EmergencyResponse(
                status: .responding,
                responder: currentUser
            )
        )
    }
}
```

### Real-time Updates
```swift
final class EmergencyWebSocket {
    func connect() async throws {
        let socket = try await webSocketManager.connect()
        
        for await event in socket.events {
            switch event {
            case .newEmergency(let emergency):
                handleNewEmergency(emergency)
            case .statusUpdate(let update):
                handleStatusUpdate(update)
            case .teamUpdate(let team):
                handleTeamUpdate(team)
            }
        }
    }
} 