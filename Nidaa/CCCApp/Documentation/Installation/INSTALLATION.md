# Installation Guide

## Prerequisites

### Development Environment
- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 17.0+ for deployment
- Swift 5.9+
- Active Apple Developer Account

### Required Tools
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install development tools
brew install swiftlint
brew install carthage
brew install fastlane
```

## Installation Steps

### 1. Clone Repository
```bash
git clone https://github.com/your-org/ccc-app.git
cd ccc-app
```

### 2. Install Dependencies
```bash
# Install CocoaPods dependencies
pod install

# Install Carthage frameworks
carthage bootstrap --platform iOS --use-xcframeworks
```

### 3. Configure Certificates
```bash
# Setup development certificates
fastlane match development

# Setup distribution certificates
fastlane match appstore
```

### 4. Configure Environment
```bash
# Copy environment configuration
cp .env.example .env.development
cp .env.example .env.production

# Edit configurations with your settings
vim .env.development
```

### 5. Configure Push Notifications
1. Enable Push Notifications capability in Xcode
2. Create APNs certificates in Apple Developer Portal
3. Configure notification categories in the app

### 6. Setup Encryption
1. Generate encryption keys
2. Configure keychain access
3. Set up secure storage

## Configuration

### Environment Variables
```bash
# .env.development
API_BASE_URL=https://api.dev.cccapp.com
ENVIRONMENT=development
ENABLE_LOGGING=true

# .env.production
API_BASE_URL=https://api.cccapp.com
ENVIRONMENT=production
ENABLE_LOGGING=false
```

### Build Configurations
```xcconfig
// Development.xcconfig
PRODUCT_BUNDLE_IDENTIFIER = com.ccc.app.dev
DEVELOPMENT_TEAM = YOUR_TEAM_ID
CODE_SIGN_IDENTITY = iPhone Developer

// Production.xcconfig
PRODUCT_BUNDLE_IDENTIFIER = com.ccc.app
DEVELOPMENT_TEAM = YOUR_TEAM_ID
CODE_SIGN_IDENTITY = iPhone Distribution
```

## Running the App

### Development
1. Open `CCCApp.xcworkspace`
2. Select `CCCApp-Development` scheme
3. Choose your target device
4. Press ⌘R to build and run

### Production
1. Open `CCCApp.xcworkspace`
2. Select `CCCApp-Production` scheme
3. Choose your target device
4. Press ⌘R to build and run

## Troubleshooting

### Common Issues

#### 1. Certificate Issues
```bash
# Reset certificates
fastlane match nuke development
fastlane match development
```

#### 2. Dependency Issues
```bash
# Reset CocoaPods
pod deintegrate
pod cache clean --all
pod install

# Reset Carthage
carthage clean
carthage bootstrap --platform iOS --use-xcframeworks
```

#### 3. Build Issues
```bash
# Clean build folder
xcodebuild clean -workspace CCCApp.xcworkspace -scheme CCCApp-Development

# Reset derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## Verification

### Security Checks
1. Verify encryption setup
2. Test secure storage
3. Validate certificate configuration
4. Check HIPAA compliance settings

### Functionality Checks
1. Test push notifications
2. Verify video calling
3. Test message encryption
4. Validate file sharing

## Next Steps

1. Read the [Quick Start Guide](QUICK_START.md)
2. Configure [Security Settings](../Security/SECURITY_SETUP.md)
3. Set up [Monitoring](../Deployment/MONITORING.md)
4. Review [HIPAA Compliance](../Security/HIPAA_COMPLIANCE.md) 