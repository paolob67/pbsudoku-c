#!/bin/bash
# Script to remove quarantine attributes from downloaded app
# Run this if you get "app is damaged" or "can't be opened" errors

APP_PATH="$1"

if [ -z "$APP_PATH" ]; then
    echo "Usage: ./fix_quarantine.sh /path/to/SudokuSolver.app"
    echo ""
    echo "This script removes macOS quarantine attributes that prevent"
    echo "unsigned apps from running after download."
    exit 1
fi

if [ ! -d "$APP_PATH" ]; then
    echo "Error: $APP_PATH not found"
    exit 1
fi

echo "Removing quarantine attribute from $APP_PATH..."
xattr -cr "$APP_PATH"

echo "✅ Done! Try opening the app again."
echo ""
echo "If it still doesn't work, try:"
echo "  1. Right-click the app"
echo "  2. Select 'Open'"
echo "  3. Click 'Open' in the dialog"

# Made with Bob
