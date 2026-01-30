#!/bin/bash
# Script to create a simple Sudoku app icon using macOS built-in tools

echo "Creating Sudoku Solver icon..."

# Create a temporary directory for icon generation
TEMP_DIR=$(mktemp -d)
ICONSET_DIR="${TEMP_DIR}/AppIcon.iconset"
mkdir -p "$ICONSET_DIR"

# Create a simple SVG icon with a Sudoku grid
cat > "${TEMP_DIR}/icon.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="512" height="512" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="512" height="512" fill="#4A90E2" rx="90"/>
  
  <!-- Grid lines (thin) -->
  <g stroke="#FFFFFF" stroke-width="4" fill="none">
    <line x1="170" y1="100" x2="170" y2="412"/>
    <line x1="240" y1="100" x2="240" y2="412"/>
    <line x1="310" y1="100" x2="310" y2="412"/>
    <line x1="380" y1="100" x2="380" y2="412"/>
    
    <line x1="100" y1="170" x2="412" y2="170"/>
    <line x1="100" y1="240" x2="412" y2="240"/>
    <line x1="100" y1="310" x2="412" y2="310"/>
    <line x1="100" y1="380" x2="412" y2="380"/>
  </g>
  
  <!-- Grid lines (thick for 3x3 boxes) -->
  <g stroke="#FFFFFF" stroke-width="12" fill="none">
    <line x1="100" y1="100" x2="412" y2="100"/>
    <line x1="100" y1="204" x2="412" y2="204"/>
    <line x1="100" y1="308" x2="412" y2="308"/>
    <line x1="100" y1="412" x2="412" y2="412"/>
    
    <line x1="100" y1="100" x2="100" y2="412"/>
    <line x1="204" y1="100" x2="204" y2="412"/>
    <line x1="308" y1="100" x2="308" y2="412"/>
    <line x1="412" y1="100" x2="412" y2="412"/>
  </g>
  
  <!-- Sample numbers -->
  <text x="135" y="160" font-family="Helvetica" font-size="50" fill="#FFFFFF" font-weight="bold">5</text>
  <text x="275" y="160" font-family="Helvetica" font-size="50" fill="#FFFFFF" font-weight="bold">3</text>
  <text x="345" y="230" font-family="Helvetica" font-size="50" fill="#FFFFFF" font-weight="bold">7</text>
  <text x="205" y="300" font-family="Helvetica" font-size="50" fill="#FFFFFF" font-weight="bold">9</text>
  <text x="345" y="370" font-family="Helvetica" font-size="50" fill="#FFFFFF" font-weight="bold">1</text>
</svg>
EOF

# Convert SVG to PNG using qlmanage (built into macOS)
qlmanage -t -s 1024 -o "$TEMP_DIR" "${TEMP_DIR}/icon.svg" 2>/dev/null

# If qlmanage worked, we'll have a PNG
if [ -f "${TEMP_DIR}/icon.svg.png" ]; then
    BASE_PNG="${TEMP_DIR}/icon.svg.png"
elif [ -f "${TEMP_DIR}/icon.png" ]; then
    BASE_PNG="${TEMP_DIR}/icon.png"
else
    echo "Warning: Could not convert SVG. Using system icon instead."
    # Copy Calculator icon as fallback
    if [ -f "/System/Applications/Calculator.app/Contents/Resources/AppIcon.icns" ]; then
        cp "/System/Applications/Calculator.app/Contents/Resources/AppIcon.icns" "AppIcon.icns"
        echo "Using Calculator icon as fallback"
    fi
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Create all required icon sizes
echo "Generating icon sizes..."
sips -z 16 16     "$BASE_PNG" --out "${ICONSET_DIR}/icon_16x16.png" 2>/dev/null
sips -z 32 32     "$BASE_PNG" --out "${ICONSET_DIR}/icon_16x16@2x.png" 2>/dev/null
sips -z 32 32     "$BASE_PNG" --out "${ICONSET_DIR}/icon_32x32.png" 2>/dev/null
sips -z 64 64     "$BASE_PNG" --out "${ICONSET_DIR}/icon_32x32@2x.png" 2>/dev/null
sips -z 128 128   "$BASE_PNG" --out "${ICONSET_DIR}/icon_128x128.png" 2>/dev/null
sips -z 256 256   "$BASE_PNG" --out "${ICONSET_DIR}/icon_128x128@2x.png" 2>/dev/null
sips -z 256 256   "$BASE_PNG" --out "${ICONSET_DIR}/icon_256x256.png" 2>/dev/null
sips -z 512 512   "$BASE_PNG" --out "${ICONSET_DIR}/icon_256x256@2x.png" 2>/dev/null
sips -z 512 512   "$BASE_PNG" --out "${ICONSET_DIR}/icon_512x512.png" 2>/dev/null
sips -z 1024 1024 "$BASE_PNG" --out "${ICONSET_DIR}/icon_512x512@2x.png" 2>/dev/null

# Convert iconset to icns
echo "Creating .icns file..."
iconutil -c icns "$ICONSET_DIR" -o "AppIcon.icns"

# Cleanup
rm -rf "$TEMP_DIR"

if [ -f "AppIcon.icns" ]; then
    echo "✅ Icon created successfully: AppIcon.icns"
else
    echo "❌ Failed to create icon"
    exit 1
fi

# Made with Bob
