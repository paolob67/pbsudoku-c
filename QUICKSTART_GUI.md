# Quick Start Guide - Sudoku Solver GUI

## Installation

1. **Build the GUI**:
   ```bash
   make gui
   ```

2. **Launch the application**:
   ```bash
   ./sudoku_gui
   ```
   
   Or double-click `sudoku_gui` in Finder.

## First Steps

### Solving Your First Puzzle

1. **Launch the app**: Run `./sudoku_gui`
2. **Load a test puzzle**: Click "Load" and select `tests/test1.in`
3. **Solve it**: Click the "Solve" button
4. **See the result**: The solution appears instantly with timing info

### Manual Entry

1. **Select grid size**: Click "9×9" (default) or "16×16"
2. **Click a cell**: Click any empty cell in the grid
3. **Type a number**: Enter 1-9 (or 1-16 for 16×16 puzzles)
4. **Fill the puzzle**: Continue entering known values
5. **Solve**: Click "Solve" when ready

### Using Reduction

1. **Check the box**: Enable "Use Reduction" checkbox
2. **Load or enter puzzle**: Get your puzzle ready
3. **Solve**: Click "Solve"
4. **See the benefit**: Status shows how many cells were reduced

## Tips

- **Blue numbers** = Original clues (can't edit)
- **Black numbers** = Your entries or solutions (editable)
- **Tab key** = Move between cells
- **Delete/Backspace** = Clear a cell
- **Load test files** = Use puzzles from `tests/` directory

## Example Workflow

```bash
# 1. Build
make gui

# 2. Launch
./sudoku_gui

# 3. In the GUI:
#    - Click "Load"
#    - Navigate to tests/test1.in
#    - Click "Open"
#    - Click "Solve"
#    - Watch it solve in milliseconds!

# 4. Try with reduction:
#    - Click "Clear"
#    - Click "Load" again
#    - Check "Use Reduction"
#    - Click "Solve"
#    - Compare the timing
```

## Troubleshooting

**App won't launch?**
- Make sure you're on macOS 11+
- Run from terminal to see errors: `./sudoku_gui`

**Can't load files?**
- Check file format matches expected input
- Use test files as examples

**Grid looks wrong?**
- Try resizing the window
- Switch grid size and back

## Next Steps

- Read [GUI_README.md](GUI_README.md) for complete documentation
- Try the 16×16 puzzles in `tests/sample-16x16.in`
- Experiment with manual solving
- Save your solutions with the "Save" button

Enjoy solving Sudoku puzzles! 🎉