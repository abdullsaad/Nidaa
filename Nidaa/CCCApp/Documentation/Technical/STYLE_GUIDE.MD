# Swift Style Guide

## Table of Contents
1. [Code Organization](#code-organization)
2. [Naming](#naming)
3. [SwiftUI Best Practices](#swiftui-best-practices)
4. [Concurrency Guidelines](#concurrency-guidelines)
5. [Security Best Practices](#security-best-practices)

## Code Organization

### File Structure
```swift
// 1. Imports
import SwiftUI
import SwiftData

// 2. Protocols
protocol MessageHandling {
    func sendMessage(_ message: Message) async throws
}

// 3. Types
struct Message: Identifiable, Codable {
    let id: UUID
    let content: String
}

// 4. Main Type Implementation
final class MessageViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var messages: [Message] = []
    
    // MARK: - Dependencies
    private let messageManager: MessageManager
    
    // MARK: - Initialization
    init(messageManager: MessageManager = .shared) {
        self.messageManager = messageManager
    }
    
    // MARK: - Public Methods
    func sendMessage(_ content: String) async throws {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func validateMessage(_ message: Message) -> Bool {
        // Implementation
    }
}

// 5. Extensions
extension MessageViewModel: MessageHandling {
    // Implementation
}
```

### Property Organization
```swift
final class UserProfileViewModel {
    // 1. Type Properties
    static let shared = UserProfileViewModel()
    
    // 2. Published Properties
    @Published private(set) var user: User?
    @Published var isLoading = false
    
    // 3. Stored Properties
    private let userManager: UserManager
    private var cancellables: Set<AnyCancellable> = []
    
    // 4. Computed Properties
    var isAuthenticated: Bool {
        user != nil
    }
}
```

## Naming

### General Rules
```swift
// Types are UpperCamelCase
struct HealthcareProvider {}
class PatientRecord {}
enum UserRole {}

// Variables and functions are lowerCamelCase
var firstName: String
func updateUserProfile() {}

// Constants are lowerCamelCase
let maximumRetryCount = 3
```

### SwiftUI View Naming
```swift
// Main views end with "View"
struct PatientDetailView: View {}
struct MessageListView: View {}

// Components end with descriptive names
struct UserAvatar: View {}
struct MessageBubble: View {}
```

## SwiftUI Best Practices

### View Organization
```swift
struct PatientDetailView: View {
    // 1. Properties
    let patient: Patient
    @StateObject private var viewModel: PatientViewModel
    
    // 2. View Builder Properties
    @ViewBuilder
    private var headerView: some View {
        PatientHeaderView(patient: patient)
    }
    
    // 3. Body Implementation
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerView
                
                PatientInfoSection(patient: patient)
                
                if viewModel.showMedicalHistory {
                    MedicalHistoryView(records: viewModel.medicalRecords)
                }
            }
            .padding()
        }
        .navigationTitle(patient.fullName)
    }
}
```

### View Modifiers
```swift
// Custom modifiers use extension
extension View {
    func secureBackground() -> some View {
        self.modifier(SecureContentModifier())
    }
}

// Complex modifiers are separate types
struct SecureContentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 5)
    }
}
```

## Concurrency Guidelines

### Async/Await Usage
```swift
// Prefer async/await over completion handlers
final class DataManager {
    // Good
    func fetchData() async throws -> Data {
        // Implementation
    }
    
    // Avoid
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        // Implementation
    }
}
```

### Task Management
```swift
struct ContentView: View {
    var body: some View {
        List(items) { item in
            ItemRow(item: item)
                .task(id: item.id) {
                    await loadItemDetails(item)
                }
        }
    }
}
```

## Security Best Practices

### Sensitive Data Handling
```swift
// Use SecureStorage for sensitive data
final class SecureStorage {
    static func store(_ data: Data, key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw StorageError.saveFailed
        }
    }
}
```

### Input Validation
```swift
struct InputValidator {
    static func validateUserInput(_ input: String) -> Bool {
        // Remove any potential injection attempts
        let sanitizedInput = input.replacingOccurrences(
            of: "[<>]",
            with: "",
            options: .regularExpression
        )
        
        return sanitizedInput == input
    }
}
```

### Error Handling
```swift
enum SecurityError: LocalizedError {
    case invalidInput
    case authenticationFailed
    case encryptionFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input provided"
        case .authenticationFailed:
            return "Authentication failed"
        case .encryptionFailed:
            return "Failed to encrypt data"
        }
    }
}
```

## SwiftUI Preview Guidelines
```swift
struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode preview
            MessageView(message: .previewMessage)
                .previewDisplayName("Light Mode")
            
            // Dark mode preview
            MessageView(message: .previewMessage)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            // Different device sizes
            MessageView(message: .previewMessage)
                .previewDevice("iPhone 15 Pro")
                .previewDisplayName("iPhone 15 Pro")
        }
    }
}

// Preview helpers
extension Message {
    static let previewMessage = Message(
        id: UUID(),
        content: "Preview message content",
        timestamp: Date()
    )
}
```

