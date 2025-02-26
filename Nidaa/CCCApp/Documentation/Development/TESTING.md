# Testing Guidelines

## Overview
Comprehensive testing strategy for ensuring app quality and security.

## Test Categories

### 1. Unit Tests
```swift
final class MessageEncryptionTests: XCTestCase {
    var sut: MessageEncryption!
    var mockKeyManager: MockKeyManager!
    
    override func setUp() {
        super.setUp()
        mockKeyManager = MockKeyManager()
        sut = MessageEncryption(keyManager: mockKeyManager)
    }
    
    func testMessageEncryption() throws {
        // Given
        let message = Message(content: "Test")
        
        // When
        let encrypted = try sut.encryptMessage(message)
        
        // Then
        XCTAssertNotNil(encrypted)
        XCTAssertNotEqual(encrypted.content, message.content)
    }
}
```

### 2. Integration Tests
```swift
final class CallIntegrationTests: XCTestCase {
    func testCompleteCallFlow() async throws {
        // Given
        let caller = User.mock
        let recipient = User.mock
        
        // When
        let call = try await callManager.startCall(
            from: caller,
            to: recipient
        )
        
        // Then
        XCTAssertEqual(call.status, .connecting)
        try await Task.sleep(nanoseconds: 1_000_000_000)
        XCTAssertEqual(call.status, .connected)
    }
}
```

### 3. UI Tests
```swift
final class EmergencyResponseUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    func testEmergencyAlert() {
        // Navigate to emergency
        app.tabBars.buttons["Emergency"].tap()
        
        // Trigger alert
        app.buttons["Trigger Alert"].tap()
        
        // Verify alert shown
        XCTAssertTrue(app.alerts["Emergency Alert"].exists)
    }
}
```

### 4. Performance Tests
```swift
final class PerformanceTests: XCTestCase {
    func testMessageEncryptionPerformance() {
        measure {
            // Test encryption performance
            let message = Message(content: String(repeating: "a", count: 1000))
            _ = try? encryptionManager.encryptMessage(message)
        }
    }
}
```

## Test Coverage Requirements

### Minimum Coverage
- Models: 95%
- ViewModels: 90%
- Views: 80%
- Managers: 85%
- Utilities: 90%

### Critical Paths
```swift
// Must have tests for:
1. Authentication flows
2. Message encryption/decryption
3. Call setup/teardown
4. Emergency response
5. Data persistence
```

## Continuous Integration

### GitHub Actions
```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Tests
        run: |
          xcodebuild test \
            -scheme CCCApp \
            -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

### Test Reports
```swift
final class TestReporter {
    func generateReport() -> TestReport {
        return TestReport(
            coverage: calculateCoverage(),
            failures: getFailures(),
            performance: getPerformanceMetrics()
        )
    }
}
``` 