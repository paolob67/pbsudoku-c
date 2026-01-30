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

### Manual Entry (Create Your Own Puzzle!)

1. **Select grid size**: Click "9×9" (default) or "16×16"
2. **Click a cell**: Click any empty cell in the grid
3. **Type numbers**: Enter 1-9 (or 1-16 for 16×16 puzzles) for starting clues
4. **Lock clues**: Click "Lock Clues" to mark them as original (turns blue)
5. **Solve**: Click "Solve" to find the solution
6. **Save**: Optionally save your puzzle for later

### Using Reduction

1. **Check the box**: Enable "Use Reduction" checkbox
2. **Load or enter puzzle**: Get your puzzle ready
3. **Solve**: Click "Solve"
4. **See the benefit**: Status shows how many cells were reduced

## Tips

- **Blue numbers** = Original clues (locked, can't edit)
- **Black numbers** = Your entries or solutions (editable until locked)
- **Tab key** = Move between cells
- **Delete/Backspace** = Clear a cell
- **Lock Clues button** = Marks your entries as the starting puzzle
- **Load test files** = Use puzzles from `tests/` directory

## Example Workflows

### Workflow 1: Load and Solve
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
```

### Workflow 2: Create Your Own Puzzle
```bash
# 1. Launch
./sudoku_gui

# 2. In the GUI:
#    - Enter some numbers (e.g., 5, 3, 7 in first row)
#    - Click "Lock Clues" (numbers turn blue)
#    - Click "Solve" (solution appears in black)
#    - Click "Save" to save your puzzle
```

### Workflow 3: Try Reduction Optimization
```bash
# In the GUI:
#    - Load a puzzle
#    - Check "Use Reduction"
#    - Click "Solve"
#    - Compare the timing with/without reduction
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