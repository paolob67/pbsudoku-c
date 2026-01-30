# Release Guide

This guide explains how to create and publish releases for the Sudoku Solver.

## Creating a Release Package

### 1. Prepare the Release

```bash
# Make the release script executable (first time only)
chmod +x create_release.sh

# Create the release package
./create_release.sh
```

This will:
- Build the application from source
- Create the app bundle with custom icon
- Generate a DMG disk image
- Create a ZIP archive
- Generate release notes

### 2. Test the Release

```bash
# Test the app bundle
open release/SudokuSolver.app

# Test the DMG
open release/SudokuSolver-v1.0.0.dmg

# Test the ZIP
unzip -q release/SudokuSolver-v1.0.0.zip -d /tmp/test
open /tmp/test/SudokuSolver.app
```

## Publishing to GitHub

### Option 1: Using GitHub Web Interface

1. **Go to your repository** on GitHub
2. **Click "Releases"** in the right sidebar
3. **Click "Draft a new release"**
4. **Fill in the details:**
   - **Tag version:** `v1.0.0` (create new tag)
   - **Release title:** `Sudoku Solver v1.0.0`
   - **Description:** Copy from `release/RELEASE_NOTES.md`
5. **Upload files:**
   - Drag and drop `SudokuSolver-v1.0.0.dmg`
   - Drag and drop `SudokuSolver-v1.0.0.zip`
6. **Click "Publish release"**

### Option 2: Using GitHub CLI

```bash
# Install GitHub CLI (if not already installed)
brew install gh

# Login to GitHub
gh auth login

# Create the release
gh release create v1.0.0 \
  release/SudokuSolver-v1.0.0.dmg \
  release/SudokuSolver-v1.0.0.zip \
  --title "Sudoku Solver v1.0.0" \
  --notes-file release/RELEASE_NOTES.md
```

## After Publishing

### Update README Badge

The release badge in README.md will automatically show the latest version:
```markdown
[![Release](https://img.shields.io/badge/release-v1.0.0-green.svg)](https://github.com/yourusername/pbsudoku-c/releases)
```

### Announce the Release

Consider announcing on:
- Repository README
- Social media
- Developer forums
- Project website (if any)

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.x.x): Breaking changes
- **MINOR** (x.1.x): New features, backwards compatible
- **PATCH** (x.x.1): Bug fixes, backwards compatible

Examples:
- `v1.0.0` - Initial release
- `v1.1.0` - Added 25×25 puzzle support
- `v1.0.1` - Fixed icon display bug
- `v2.0.0` - Complete UI redesign (breaking change)

## Release Checklist

Before creating a release:

- [ ] All tests pass (`make test`)
- [ ] Code is committed and pushed
- [ ] Version number updated in `create_release.sh`
- [ ] Release notes written
- [ ] App tested on clean macOS installation
- [ ] DMG and ZIP tested
- [ ] README updated with new features
- [ ] Screenshots updated (if UI changed)

## Troubleshooting

### DMG Creation Fails

If `hdiutil` fails, you can skip DMG creation and just use ZIP:
```bash
# Comment out DMG creation in create_release.sh
# Users can still download the ZIP file
```

### Gatekeeper Warning

Users may see a warning on first launch because the app is not code-signed. Instruct them to:
1. Right-click the app
2. Select "Open"
3. Click "Open" in the dialog

To avoid this, you need an Apple Developer account ($99/year) to code-sign the app.

### App Won't Launch

Common issues:
- **Wrong architecture**: Rebuild on the target macOS version
- **Missing dependencies**: Ensure all libraries are included
- **Permissions**: Check that executable has correct permissions

## Future Improvements

Consider adding:
- [ ] Automatic code signing
- [ ] Notarization for Gatekeeper
- [ ] Homebrew formula
- [ ] Continuous Integration (GitHub Actions)
- [ ] Automatic release creation on tag push