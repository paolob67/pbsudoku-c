#!/bin/bash
# Script to create a distributable release package for Sudoku Solver

VERSION="1.0.0"
RELEASE_NAME="SudokuSolver-v${VERSION}"
RELEASE_DIR="release"

echo "Creating release package for Sudoku Solver v${VERSION}..."

# Clean and build
echo "Building application..."
make clean
make gui

# Create app bundle
echo "Creating app bundle..."
./create_app_bundle.sh

# Create release directory
rm -rf "${RELEASE_DIR}"
mkdir -p "${RELEASE_DIR}"

# Copy app bundle
echo "Packaging app bundle..."
cp -R SudokuSolver.app "${RELEASE_DIR}/"

# Create a DMG with Applications folder symlink
echo "Creating DMG image..."
DMG_NAME="${RELEASE_NAME}.dmg"
DMG_TEMP_DIR="${RELEASE_DIR}/dmg_temp"

# Create temporary directory for DMG contents
mkdir -p "${DMG_TEMP_DIR}"

# Copy app to temp directory
cp -R "${RELEASE_DIR}/SudokuSolver.app" "${DMG_TEMP_DIR}/"

# Create symlink to Applications folder
ln -s /Applications "${DMG_TEMP_DIR}/Applications"

# Create the DMG
hdiutil create -volname "Sudoku Solver" -srcfolder "${DMG_TEMP_DIR}" -ov -format UDZO "${RELEASE_DIR}/${DMG_NAME}"

# Clean up temp directory
rm -rf "${DMG_TEMP_DIR}"

echo "✅ DMG created with Applications folder shortcut"

# Create a ZIP archive (alternative to DMG)
echo "Creating ZIP archive..."
cd "${RELEASE_DIR}"
zip -r "${RELEASE_NAME}.zip" SudokuSolver.app
cd ..

# Copy fix script to release
cp fix_quarantine.sh "${RELEASE_DIR}/"
chmod +x "${RELEASE_DIR}/fix_quarantine.sh"

# Create release notes
cat > "${RELEASE_DIR}/RELEASE_NOTES.md" << 'EOF'
# Sudoku Solver v1.0.0

A high-performance Sudoku solver with native macOS GUI.

## ⚠️ Important: First-Time Setup

Since this app is not code-signed, macOS may show a warning. To open:

### Method 1: Right-Click Open (Recommended)
1. Download and extract the app
2. **Right-click** (or Control-click) on SudokuSolver.app
3. Select **"Open"** from the menu
4. Click **"Open"** in the dialog that appears
5. The app will now open and be trusted

### Method 2: Remove Quarantine (Advanced)
If you get "app is damaged" error:
```bash
xattr -cr /path/to/SudokuSolver.app
```

Or use the included script:
```bash
./fix_quarantine.sh SudokuSolver.app
```

## Features

✨ **Manual Puzzle Creation**
- Create puzzles directly in the GUI
- Lock clues to mark starting positions
- No input file needed

🎨 **Native macOS Experience**
- Custom Sudoku grid icon
- Proper Dock integration
- Keyboard input support

🔢 **Puzzle Support**
- 9×9 standard Sudoku
- 16×16 large puzzles
- Load/save puzzle files

⚡ **Performance**
- Backtracking algorithm
- Optional constraint propagation
- Solve times displayed

## Installation

### Option 1: DMG (Recommended)
1. Download `SudokuSolver-v1.0.0.dmg`
2. Open the DMG file
3. Drag SudokuSolver.app to Applications folder
4. Launch from Applications

### Option 2: ZIP
1. Download `SudokuSolver-v1.0.0.zip`
2. Extract the ZIP file
3. Move SudokuSolver.app to Applications folder
4. **Right-click** and select **"Open"** (first time only)

### Troubleshooting

**"App is damaged" or "can't be opened" error?**
- Use the included `fix_quarantine.sh` script
- Or run: `xattr -cr SudokuSolver.app`
- Then right-click → Open

**Still not working?**
- Make sure you're on macOS 10.13 or later
- Try moving the app to Applications folder first
- Check that you have permission to run apps from unidentified developers (System Preferences → Security & Privacy)

## Usage

1. **Launch** the app from Applications
2. **Enter numbers** by clicking cells and typing
3. **Lock Clues** to mark starting positions (turns blue)
4. **Solve** to find the solution
5. **Save** your puzzle for later

## System Requirements

- macOS 10.13 (High Sierra) or later
- 64-bit Intel or Apple Silicon processor

## Known Issues

- First launch may show Gatekeeper warning (right-click → Open to bypass)
- App is not code-signed (requires Apple Developer account)

## Support

For issues, questions, or contributions:
- GitHub: https://github.com/YOUR_USERNAME/pbsudoku-c
- Report bugs via GitHub Issues

## License

MIT License - See LICENSE file for details
EOF

echo ""
echo "✅ Release package created in ${RELEASE_DIR}/"
echo ""
echo "Contents:"
ls -lh "${RELEASE_DIR}/"
echo ""
echo "Next steps:"
echo "1. Test the app: open ${RELEASE_DIR}/SudokuSolver.app"
echo "2. Create a GitHub release:"
echo "   - Go to your repo → Releases → Draft a new release"
echo "   - Tag: v${VERSION}"
echo "   - Title: Sudoku Solver v${VERSION}"
echo "   - Upload: ${RELEASE_DIR}/${DMG_NAME} and ${RELEASE_DIR}/${RELEASE_NAME}.zip"
echo "   - Copy release notes from ${RELEASE_DIR}/RELEASE_NOTES.md"
echo "3. Publish the release"
echo ""

# Made with Bob
