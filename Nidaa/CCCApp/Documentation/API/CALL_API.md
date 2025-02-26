# Call API

## Overview
Video and voice calling endpoints for secure healthcare communication.

## Endpoints

### Initiate Call
```http
POST /calls/initiate
Content-Type: application/json
Authorization: Bearer token

{
    "recipientId": "uuid",
    "type": "video", // or "voice"
    "metadata": {
        "deviceInfo": "iPhone 15 Pro",
        "networkType": "wifi"
    }
}

Response:
{
    "callId": "uuid",
    "token": "webrtc_token",
    "iceServers": [{
        "urls": ["stun:stun.example.com:3478"],
        "username": "optional_username",
        "credential": "optional_credential"
    }]
}
```

### Update Call Status
```http
PUT /calls/{id}/status
Authorization: Bearer token
Content-Type: application/json

{
    "status": "connected", // or "ended", "rejected", "missed"
    "duration": 120, // seconds, optional
    "metadata": {
        "quality": "good",
        "reason": "user_ended" // optional
    }
}
```

## Implementation

### Swift Usage
```swift
final class CallManager {
    func initiateCall(
        with recipient: User,
        type: CallType
    ) async throws -> Call {
        // 1. Request call setup
        let response = try await apiClient.request(
            endpoint: .calls,
            method: .post,
            body: CallRequest(
                recipientId: recipient.id,
                type: type
            )
        )
        
        // 2. Configure WebRTC
        try await webRTCManager.configure(
            with: response.iceServers
        )
        
        // 3. Start local media
        try await mediaManager.startLocalMedia(for: type)
        
        return response.call
    }
}
```

### WebRTC Integration
```swift
final class WebRTCManager {
    func configure(with servers: [RTCIceServer]) async throws {
        let configuration = RTCConfiguration()
        configuration.iceServers = servers
        
        peerConnection = factory.peerConnection(
            with: configuration,
            constraints: mediaConstraints,
            delegate: self
        )
    }
    
    func handleRemoteSessionDescription(_ sdp: RTCSessionDescription) {
        // Handle remote SDP
    }
}
``` 