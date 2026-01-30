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

# Create a simple icon using SF Symbols or system icon
echo "Creating app icon..."
# This creates a simple colored icon - you can replace with a custom .icns file
cat > "${RESOURCES_DIR}/create_icon.py" << 'PYEOF'
#!/usr/bin/env python3
import os
from PIL import Image, ImageDraw, ImageFont

# Create a simple 512x512 icon
size = 512
img = Image.new('RGB', (size, size), color='#4A90E2')

# Draw a simple grid pattern
draw = ImageDraw.Draw(img)
grid_size = 3
cell_size = size // grid_size

# Draw grid lines
for i in range(grid_size + 1):
    pos = i * cell_size
    draw.line([(pos, 0), (pos, size)], fill='white', width=8)
    draw.line([(0, pos), (size, pos)], fill='white', width=8)

# Draw some numbers
try:
    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 120)
except:
    font = ImageFont.load_default()

# Draw "9x9" in center
text = "9×9"
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]
x = (size - text_width) // 2
y = (size - text_height) // 2
draw.text((x, y), text, fill='white', font=font)

# Save as PNG first
img.save('icon.png')
print("Icon created: icon.png")
PYEOF

# Try to create icon with Python (if available)
if command -v python3 &> /dev/null; then
    python3 "${RESOURCES_DIR}/create_icon.py" 2>/dev/null
    if [ -f "icon.png" ]; then
        # Convert PNG to ICNS using sips (macOS built-in)
        mkdir -p icon.iconset
        sips -z 16 16     icon.png --out icon.iconset/icon_16x16.png
        sips -z 32 32     icon.png --out icon.iconset/icon_16x16@2x.png
        sips -z 32 32     icon.png --out icon.iconset/icon_32x32.png
        sips -z 64 64     icon.png --out icon.iconset/icon_32x32@2x.png
        sips -z 128 128   icon.png --out icon.iconset/icon_128x128.png
        sips -z 256 256   icon.png --out icon.iconset/icon_128x128@2x.png
        sips -z 256 256   icon.png --out icon.iconset/icon_256x256.png
        sips -z 512 512   icon.png --out icon.iconset/icon_256x256@2x.png
        sips -z 512 512   icon.png --out icon.iconset/icon_512x512.png
        sips -z 1024 1024 icon.png --out icon.iconset/icon_512x512@2x.png
        
        iconutil -c icns icon.iconset -o "${RESOURCES_DIR}/AppIcon.icns"
        rm -rf icon.iconset icon.png
        echo "Custom icon created!"
    fi
fi

rm -f "${RESOURCES_DIR}/create_icon.py"

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
