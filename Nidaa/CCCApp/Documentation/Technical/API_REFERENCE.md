# API Reference

## Authentication API

### Login
```swift
func login(credentials: Credentials) async throws -> User

// Example:
let credentials = Credentials(username: "doctor@hospital.com", password: "****")
let user = try await AuthManager.shared.login(credentials)
```

### Logout
```swift
func logout() async throws

// Example:
try await AuthManager.shared.logout()
```

## Messaging API

### Send Message
```swift
func sendMessage(to: UUID, content: String, type: MessageType) async throws

// Example:
try await MessageManager.shared.sendMessage(
    to: recipientId,
    content: "Patient update",
    type: .text
)
```

## Call API

### Start Call
```swift
func startCall(with: User, type: CallType) async throws

// Example:
try await CallManager.shared.startCall(
    with: recipient,
    type: .video
)
```

## Emergency API

### Initiate Emergency
```swift
func initiateEmergency(type: EmergencyType) async throws

// Example:
try await EmergencyManager.shared.initiateEmergency(type: .medical)
``` 