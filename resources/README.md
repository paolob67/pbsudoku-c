# Resources Folder

This folder contains resources for the Sudoku Solver application.

## Contents

### AppIcon.icns
The custom application icon for SudokuSolver.app

**Design:**
- Blue background (#4A90E2)
- White Sudoku grid (9×9)
- Sample numbers (5, 3, 7, 9, 1)
- Rounded corners for modern macOS look

### create_icon.sh
Script to generate the AppIcon.icns file from an SVG template.

**Usage:**
```bash
cd resources
./create_icon.sh
```

This will create `AppIcon.icns` which is used by the app bundle.

## Customizing the Icon

To create your own custom icon:

1. **Edit the SVG** in `create_icon.sh` (lines 15-50)
2. **Run the script** to generate the .icns file
3. **Rebuild the app** with `make app`

Or replace `AppIcon.icns` directly with your own .icns file.

## Icon Specifications

The icon includes all required sizes for macOS:
- 16×16, 32×32, 64×64, 128×128, 256×256, 512×512, 1024×1024
- Both standard and @2x retina versions
- Proper .icns format for macOS compatibility