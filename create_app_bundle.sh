#!/bin/bash
# Script to create a macOS app bundle for Sudoku Solver

APP_NAME="SudokuSolver"
BUNDLE_DIR="${APP_NAME}.app"
CONTENTS_DIR="${BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Creating app bundle structure..."

# Clean up existing bundle
rm -rf "${BUNDLE_DIR}"

# Create directory structure
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# Copy executable
echo "Copying executable..."
cp sudoku_gui "${MACOS_DIR}/${APP_NAME}"
chmod +x "${MACOS_DIR}/${APP_NAME}"

# Create Info.plist
echo "Creating Info.plist..."
cat > "${CONTENTS_DIR}/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.sudoku.solver</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2026. All rights reserved.</string>
</dict>
</plist>
EOF

# Copy app icon from resources folder
echo "Adding app icon..."

if [ -f "resources/AppIcon.icns" ]; then
    cp "resources/AppIcon.icns" "${RESOURCES_DIR}/AppIcon.icns"
    echo "✅ Custom Sudoku icon added"
else
    echo "⚠️  Icon not found in resources/, generating it..."
    # Generate icon if it doesn't exist
    if [ -f "resources/create_icon.sh" ]; then
        (cd resources && ./create_icon.sh)
        if [ -f "resources/AppIcon.icns" ]; then
            cp "resources/AppIcon.icns" "${RESOURCES_DIR}/AppIcon.icns"
            echo "✅ Icon generated and added"
        else
            echo "❌ Failed to generate icon, using system default"
        fi
    else
        echo "❌ Icon creation script not found, using system default"
    fi
fi

echo ""
echo "✅ App bundle created: ${BUNDLE_DIR}"
echo ""
echo "To use:"
echo "  1. Open Finder and navigate to this directory"
echo "  2. Double-click ${BUNDLE_DIR} to launch"
echo "  3. Or drag to Applications folder"
echo ""
echo "To launch from terminal:"
echo "  open ${BUNDLE_DIR}"
echo ""

# Made with Bob
