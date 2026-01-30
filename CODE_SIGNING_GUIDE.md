# Code Signing Guide for macOS

This guide explains how to properly sign your Sudoku Solver app so users can open it without Gatekeeper warnings.

## Overview

macOS requires apps to be **code-signed** and **notarized** to run without warnings. This involves:

1. **Code Signing** - Cryptographically sign the app with your developer certificate
2. **Notarization** - Submit to Apple for automated security scan
3. **Stapling** - Attach the notarization ticket to your app

## Prerequisites

### 1. Apple Developer Account

**Cost:** $99/year

**Sign up:** https://developer.apple.com/programs/

**What you get:**
- Developer certificate for code signing
- Ability to notarize apps
- App Store distribution (optional)
- TestFlight for beta testing

### 2. Install Xcode Command Line Tools

```bash
xcode-select --install
```

## Step-by-Step Code Signing

### Step 1: Get Your Developer Certificate

1. **Join Apple Developer Program** ($99/year)
2. **Open Xcode** → Preferences → Accounts
3. **Add your Apple ID**
4. **Download certificates**:
   - "Developer ID Application" certificate (for distribution outside App Store)
   - "Developer ID Installer" certificate (for pkg installers)

Or use the command line:
```bash
# List available certificates
security find-identity -v -p codesigning

# You should see something like:
# 1) ABC123... "Developer ID Application: Your Name (TEAM_ID)"
```

### Step 2: Sign Your App

Create a signing script:

```bash
#!/bin/bash
# sign_app.sh

APP_PATH="SudokuSolver.app"
IDENTITY="Developer ID Application: Your Name (TEAM_ID)"

# Sign the app
codesign --force --deep --sign "$IDENTITY" \
  --options runtime \
  --entitlements entitlements.plist \
  "$APP_PATH"

# Verify signature
codesign --verify --verbose "$APP_PATH"
spctl --assess --verbose "$APP_PATH"
```

### Step 3: Create Entitlements File

Create `entitlements.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.cs.allow-jit</key>
    <true/>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <true/>
    <key>com.apple.security.cs.disable-library-validation</key>
    <true/>
</dict>
</plist>
```

### Step 4: Notarize Your App

```bash
#!/bin/bash
# notarize_app.sh

APP_PATH="SudokuSolver.app"
BUNDLE_ID="com.sudoku.solver"
APPLE_ID="your@email.com"
TEAM_ID="YOUR_TEAM_ID"

# Create a ZIP for notarization
ditto -c -k --keepParent "$APP_PATH" "SudokuSolver.zip"

# Submit for notarization
xcrun notarytool submit "SudokuSolver.zip" \
  --apple-id "$APPLE_ID" \
  --team-id "$TEAM_ID" \
  --password "app-specific-password" \
  --wait

# Staple the notarization ticket
xcrun stapler staple "$APP_PATH"

# Verify
xcrun stapler validate "$APP_PATH"
```

### Step 5: Create App-Specific Password

1. Go to https://appleid.apple.com
2. Sign in with your Apple ID
3. Go to "Security" → "App-Specific Passwords"
4. Generate a new password
5. Use this password in the notarization command

## Automated Signing Script

Create `create_signed_release.sh`:

```bash
#!/bin/bash
# Automated signing and notarization

# Configuration
IDENTITY="Developer ID Application: Your Name (TEAM_ID)"
APPLE_ID="your@email.com"
TEAM_ID="YOUR_TEAM_ID"
APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"  # App-specific password

# Build the app
make clean
make gui
./create_app_bundle.sh

# Sign the app
echo "Signing app..."
codesign --force --deep --sign "$IDENTITY" \
  --options runtime \
  --entitlements entitlements.plist \
  SudokuSolver.app

# Verify signature
codesign --verify --verbose SudokuSolver.app

# Create ZIP for notarization
echo "Creating archive for notarization..."
ditto -c -k --keepParent SudokuSolver.app SudokuSolver.zip

# Submit for notarization
echo "Submitting for notarization..."
xcrun notarytool submit SudokuSolver.zip \
  --apple-id "$APPLE_ID" \
  --team-id "$TEAM_ID" \
  --password "$APP_PASSWORD" \
  --wait

# Staple the ticket
echo "Stapling notarization ticket..."
xcrun stapler staple SudokuSolver.app

# Create release package
./create_release.sh

echo "✅ Signed and notarized release created!"
```

## Alternative: Self-Signed Certificate (Development Only)

For testing purposes, you can create a self-signed certificate:

```bash
# Create self-signed certificate
security create-keychain -p test test.keychain
security default-keychain -s test.keychain
security unlock-keychain -p test test.keychain

# Generate certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# Import to keychain
security import cert.pem -k test.keychain -T /usr/bin/codesign

# Sign app
codesign --force --sign "Your Certificate Name" SudokuSolver.app
```

**Note:** Self-signed apps still show Gatekeeper warnings. This is only for development/testing.

## Cost-Benefit Analysis

### With Apple Developer Account ($99/year)

**Pros:**
- ✅ No Gatekeeper warnings
- ✅ Professional appearance
- ✅ Users trust signed apps more
- ✅ Can distribute via App Store
- ✅ Access to beta testing tools

**Cons:**
- ❌ Annual cost
- ❌ Setup complexity
- ❌ Notarization takes time

### Without Code Signing (Current)

**Pros:**
- ✅ Free
- ✅ Simple distribution
- ✅ Works for technical users

**Cons:**
- ❌ Gatekeeper warnings
- ❌ Users must right-click → Open
- ❌ Less professional
- ❌ Some users may not trust it

## Recommendation

### For Open Source / Free Apps
- **Start without signing** - Use the current approach with clear instructions
- **Add signing later** - When you have more users or want to monetize

### For Commercial Apps
- **Get Apple Developer account** - Essential for professional distribution
- **Sign and notarize** - Required for good user experience

## Current Workaround (No Developer Account)

Your current approach is perfectly valid for open-source projects:

1. **Clear documentation** - Explain the right-click method
2. **Include fix script** - `fix_quarantine.sh` for advanced users
3. **GitHub releases** - Users expect this from open-source projects
4. **Trust builds over time** - As more users download and verify

Many successful open-source Mac apps use this approach initially.

## Resources

- [Apple Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [Notarization Documentation](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [Developer Program](https://developer.apple.com/programs/)

## Questions?

Feel free to add code signing later when:
- You have a larger user base
- You want to monetize
- You need App Store distribution
- Professional appearance becomes important

For now, your current approach with clear instructions is perfectly acceptable for an open-source project! 🎉