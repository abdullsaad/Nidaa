# Security Protocols

## Overview
Comprehensive security implementation for HIPAA compliance and data protection.

## Encryption Protocols

### 1. Data at Rest
```swift
final class DataEncryption {
    // AES-256 for data at rest
    func encryptData(_ data: Data) throws -> EncryptedData {
        let key = try getEncryptionKey()
        let iv = AES.GCM.Nonce()
        
        return try AES.GCM.seal(
            data,
            using: key,
            nonce: iv
        )
    }
    
    // Secure key storage
    private func getEncryptionKey() throws -> SymmetricKey {
        if let existingKey = try keychain.retrieveKey() {
            return existingKey
        }
        
        let newKey = SymmetricKey(size: .bits256)
        try keychain.storeKey(newKey)
        return newKey
    }
}
```

### 2. Data in Transit
```swift
final class NetworkSecurity {
    // TLS configuration
    func configureTLS() {
        let configuration = URLSessionConfiguration.default
        configuration.tlsMinimumSupportedProtocolVersion = .TLSv13
        configuration.tlsMaximumSupportedProtocolVersion = .TLSv13
        
        // Certificate pinning
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    }
}
```

## Authentication

### 1. Multi-Factor Authentication
```swift
final class MFAManager {
    func setupMFA() async throws {
        // 1. Generate secret
        let secret = try generateTOTPSecret()
        
        // 2. Create QR code
        let qrCode = try generateQRCode(for: secret)
        
        // 3. Verify setup
        try await verifyMFASetup(secret)
    }
    
    func verifyCode(_ code: String) async throws -> Bool {
        // Verify TOTP code
        let secret = try retrieveTOTPSecret()
        return TOTP.verify(code, secret: secret)
    }
}
```

### 2. Biometric Authentication
```swift
final class BiometricAuth {
    func authenticateWithBiometrics() async throws {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            throw BiometricError.notAvailable
        }
        
        return try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate to access the app"
        )
    }
}
```

## Audit Logging

### 1. Access Logging
```swift
final class AuditLogger {
    func logAccess(
        user: User,
        resource: String,
        action: AuditAction
    ) async throws {
        let log = AuditLog(
            userId: user.id,
            timestamp: Date(),
            resource: resource,
            action: action,
            deviceInfo: getDeviceInfo(),
            networkInfo: getNetworkInfo()
        )
        
        try await saveAuditLog(log)
    }
}
```

### 2. Security Events
```swift
final class SecurityEventMonitor {
    func monitorSecurityEvents() async {
        for await event in securityEvents {
            switch event.type {
            case .failedLogin:
                handleFailedLogin(event)
            case .unauthorizedAccess:
                handleUnauthorizedAccess(event)
            case .dataExport:
                handleDataExport(event)
            case .encryptionFailure:
                handleEncryptionFailure(event)
            }
        }
    }
}
```

## Data Protection

### 1. Secure Storage
```swift
final class SecureStorage {
    func securelyStore(_ data: Data, key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecUseDataProtectionKeychain as String: true
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw StorageError.saveFailed(status: status)
        }
    }
}
```

### 2. Data Sanitization
```swift
final class DataSanitizer {
    func sanitizeUserInput(_ input: String) -> String {
        // Remove potential injection attempts
        var sanitized = input.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
        
        // Remove potential SQL injection
        sanitized = sanitized.replacingOccurrences(
            of: "'|;|--",
            with: "",
            options: .regularExpression
        )
        
        return sanitized
    }
}
```

## Network Security

### 1. Certificate Pinning
```swift
final class CertificatePinning {
    func validateCertificate(_ serverTrust: SecTrust) throws {
        let certificates = [
            "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="
        ]
        
        guard let serverCertificate = SecTrustGetCertificateAtIndex(
            serverTrust,
            0
        ) else {
            throw CertificateError.invalidCertificate
        }
        
        let serverPublicKey = SecCertificateCopyKey(serverCertificate)
        let serverPublicKeyData = SecKeyCopyExternalRepresentation(
            serverPublicKey!,
            nil
        )!
        
        let keyHash = SHA256.hash(data: serverPublicKeyData as Data)
        let keyHashString = keyHash.map { String(format: "%02hhx", $0) }.joined()
        
        guard certificates.contains("sha256/\(keyHashString)") else {
            throw CertificateError.certificateMismatch
        }
    }
}
```

### 2. Request Signing
```swift
final class RequestSigner {
    func signRequest(_ request: URLRequest) throws -> URLRequest {
        var request = request
        
        // Add timestamp
        let timestamp = ISO8601DateFormatter().string(from: Date())
        request.addValue(timestamp, forHTTPHeaderField: "X-Timestamp")
        
        // Generate signature
        let signature = try generateSignature(
            method: request.httpMethod ?? "",
            path: request.url?.path ?? "",
            timestamp: timestamp,
            body: request.httpBody
        )
        
        request.addValue(signature, forHTTPHeaderField: "X-Signature")
        return request
    }
}
``` 