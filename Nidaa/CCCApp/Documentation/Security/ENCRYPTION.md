# Encryption Implementation

## Overview
End-to-end encryption system for secure healthcare communication.

## Components

### 1. Key Management
```swift
final class KeyManager {
    private let keychain = KeychainManager.shared
    
    func generateKeys() throws -> (public: SecKey, private: SecKey) {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048
        ]
        
        return try generateKeyPair(attributes)
    }
    
    func storeKeys(_ keys: KeyPair) throws {
        try keychain.store(keys.public, for: "public_key")
        try keychain.store(keys.private, for: "private_key")
    }
}
```

### 2. Message Encryption
```swift
final class MessageEncryption {
    func encryptMessage(_ message: Message) throws -> EncryptedMessage {
        // 1. Generate AES key
        let messageKey = try generateAESKey()
        
        // 2. Encrypt message with AES
        let encryptedContent = try encrypt(
            message.content,
            with: messageKey
        )
        
        // 3. Encrypt AES key with recipient's public key
        let encryptedKey = try encryptKey(
            messageKey,
            for: message.recipientId
        )
        
        return EncryptedMessage(
            content: encryptedContent,
            key: encryptedKey
        )
    }
}
```

### 3. Secure Storage
```swift
final class SecureStorage {
    func securelyStore(_ data: Data, key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw StorageError.saveFailed(status: status)
        }
    }
}
``` 