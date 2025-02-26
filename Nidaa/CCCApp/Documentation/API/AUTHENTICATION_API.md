# Authentication API

## Overview
Authentication endpoints for secure user access and session management.

## Endpoints

### Login
```http
POST /auth/login
Content-Type: application/json

{
    "email": "doctor@hospital.com",
    "password": "secure_password"
}

Response:
{
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
        "id": "uuid",
        "firstName": "John",
        "lastName": "Doe",
        "role": "doctor"
    }
}
```

### Refresh Token
```http
POST /auth/refresh
Authorization: Bearer refresh_token

Response:
{
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

### Logout
```http
POST /auth/logout
Authorization: Bearer token

Response: 204 No Content
```

## Implementation

### Swift Usage
```swift
final class AuthManager {
    func login(credentials: Credentials) async throws -> User {
        let response = try await apiClient.request(
            endpoint: .login,
            method: .post,
            body: credentials
        )
        
        // Store tokens
        await keychain.store(response.token)
        await keychain.store(response.refreshToken)
        
        return response.user
    }
}
```

### Error Handling
```swift
enum AuthError: LocalizedError {
    case invalidCredentials
    case sessionExpired
    case unauthorized
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .sessionExpired:
            return "Session expired, please login again"
        case .unauthorized:
            return "Unauthorized access"
        case .networkError:
            return "Network error occurred"
        }
    }
} 