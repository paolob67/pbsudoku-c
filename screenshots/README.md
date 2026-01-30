# Screenshots

This folder contains screenshots of the Sudoku Solver GUI application.

## Required Screenshots

Please add the following screenshots to this folder:

1. **gui-main-window.png** - Main window with empty 9×9 grid
2. **gui-puzzle-loaded.png** - A puzzle loaded (before solving)
3. **gui-puzzle-solved.png** - The same puzzle after solving
4. **gui-16x16-example.png** - Example of a 16×16 puzzle (optional)

## How to Take Screenshots on macOS

### Method 1: Using Keyboard Shortcuts
- **Cmd + Shift + 4** - Select area to capture
- **Cmd + Shift + 4, then Space** - Capture specific window
- **Cmd + Shift + 3** - Capture entire screen

### Method 2: Using Screenshot App
1. Press **Cmd + Shift + 5**
2. Choose capture mode
3. Click "Capture"

## Tips for Good Screenshots

- Use a clean, uncluttered desktop background
- Capture the entire window (use Cmd + Shift + 4, then Space, then click the window)
- Make sure the window is in focus and fully visible
- For puzzle examples, use interesting but solvable puzzles from the `tests/` folder
- Save as PNG format for best quality

## Naming Convention

Use descriptive, lowercase names with hyphens:
- `gui-main-window.png`
- `gui-puzzle-loaded.png`
- `gui-puzzle-solved.png`
- `gui-16x16-example.png`
- `gui-reduction-enabled.png`

## After Adding Screenshots

Once you've added the screenshots, commit them:

```bash
git add screenshots/
git commit -m "Add GUI screenshots"
git push
```

The README.md will automatically display them!