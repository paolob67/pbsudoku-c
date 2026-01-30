# Sudoku Solver - macOS GUI

A native macOS graphical user interface for the Sudoku Solver, built with Cocoa (AppKit).

## Features

✅ **Interactive Grid**: Click and type directly into cells  
✅ **9×9 and 16×16 Support**: Switch between puzzle sizes  
✅ **Visual Feedback**: Color-coded cells (blue for given clues, black for solutions)  
✅ **Reduction Option**: Enable constraint propagation optimization  
✅ **File Operations**: Load and save puzzles  
✅ **Performance Timing**: See how fast puzzles are solved  
✅ **Native macOS Look**: Uses AppKit for a true Mac experience  

## Building

### Prerequisites
- macOS (tested on macOS 11+)
- Xcode Command Line Tools (for `clang`)

### Compile
```bash
make gui
```

This creates the `sudoku_gui` executable.

## Running

### Launch the GUI
```bash
./sudoku_gui
```

Or double-click the `sudoku_gui` file in Finder.

## Usage

### Manual Entry (New!)
You can now create puzzles directly in the GUI without needing an input file!

1. **Select Grid Size**: Click "9×9" or "16×16" button
2. **Enter Numbers**: Click on cells and type the starting clues (leave empty cells blank)
3. **Lock Clues**: Click "Lock Clues" to mark your entries as the original puzzle
   - Locked clues turn **blue** and become read-only
   - This prevents accidentally changing them while solving
4. **Solve**: Click "Solve" to find the solution
5. **Save**: Optionally save your puzzle for later use

**Workflow Example:**
```
1. Start with empty grid
2. Enter known numbers (e.g., 5, 3, 7 in first row)
3. Click "Lock Clues" → numbers turn blue
4. Click "Solve" → solution appears in black
5. Click "Save" → save puzzle to file
```

### Loading Puzzles
1. Click the "Load" button
2. Select a puzzle file (same format as command-line version)
3. The puzzle will appear in the grid with original clues in blue

### Saving Puzzles
You can save puzzles at any stage:
- **Before solving**: Save your manually entered puzzle
- **After solving**: Save the complete solution
- **Partial entry**: Save work in progress

Steps:
1. Enter or solve a puzzle
2. Click the "Save" button
3. Choose a location and filename
4. The current grid state will be saved in standard format

### Options
- **Use Reduction**: Check this box to enable constraint propagation before solving
  - This can significantly speed up solving for easier puzzles
  - Shows how many cells were reduced in the status message

## Interface Layout

```
┌──────────────────────────────────────────────────────────┐
│                   Sudoku Solver                          │
├──────────────────────────────────────────────────────────┤
│                                                          │
│   ┌────────────────────────────────────────────────┐   │
│   │                                                │   │
│   │                                                │   │
│   │         Sudoku Grid (9×9/16×16)               │   │
│   │                                                │   │
│   │                                                │   │
│   └────────────────────────────────────────────────┘   │
│                                                          │
│   Grid Size: [9×9] [16×16]  [✓] Use Reduction          │
│                                                          │
│   [Solve] [Clear] [Lock Clues] [Load] [Save]           │
│                                                          │
│   Status: Ready. Enter puzzle or load from file.        │
└──────────────────────────────────────────────────────────┘
```

## Grid Interaction

### Cell Colors
- **Blue Text**: Original puzzle clues (locked, read-only)
  - Set by loading a file OR clicking "Lock Clues" after manual entry
- **Black Text**: User-entered values or solutions (editable until locked)

### Keyboard Input
- Type numbers directly into cells (1-9 for 9×9, 1-16 for 16×16)
- Use Tab to move between cells
- Delete/Backspace to clear a cell
- Press 0 or delete to make a cell empty

### Grid Lines
- **Thick Lines**: Sub-grid boundaries (3×3 or 4×4)
- **Thin Lines**: Individual cell boundaries

### Button Functions
- **Solve**: Solves the current puzzle
- **Clear**: Resets the entire grid to empty
- **Lock Clues**: Marks current entries as original clues (turns them blue)
- **Load**: Opens a puzzle file
- **Save**: Saves current grid state to a file

## File Format

The GUI uses the same file format as the command-line solver:

### 9×9 Puzzle
```
5 3 0 0 7 0 0 0 0
6 0 0 1 9 5 0 0 0
0 9 8 0 0 0 0 6 0
8 0 0 0 6 0 0 0 3
4 0 0 8 0 3 0 0 1
7 0 0 0 2 0 0 0 6
0 6 0 0 0 0 2 8 0
0 0 0 4 1 9 0 0 5
0 0 0 0 8 0 0 7 9
```

### 16×16 Puzzle
```
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
... (16 lines with 16 numbers each)
```

## Performance

The GUI uses the same high-performance solver as the command-line version:

- **9×9 puzzles**: Typically < 0.01 seconds
- **16×16 puzzles**: 0.01 - 1 second (varies by difficulty)
- **With reduction**: Often 2-10× faster

Solve times are displayed in the status bar after solving.

## Troubleshooting

### Application Won't Launch
- Ensure you have macOS 11 or later
- Try running from Terminal to see error messages: `./sudoku_gui`
- Check that Xcode Command Line Tools are installed: `xcode-select --install`

### Compilation Errors
- Make sure you have the latest Xcode Command Line Tools
- Verify all source files are present: `sudoku_gui.m`, `sudoku_lib.c`, `sudoku_solver.h`

### Grid Not Displaying
- Try resizing the window
- Check that the puzzle size matches the loaded file

## Architecture

### Components

```
sudoku_gui.m
├── AppDelegate: Main application controller
│   ├── Window management
│   ├── Button handlers
│   └── File I/O operations
│
└── SudokuGridView: Custom grid view
    ├── Grid rendering
    ├── Text field management
    └── Puzzle data handling

sudoku_lib.c
└── Solver library (no main function)
    ├── solve_puzzle()
    ├── reduce_puzzle()
    └── Validation functions
```

### Technology Stack
- **Language**: Objective-C
- **Framework**: Cocoa (AppKit)
- **Solver**: C (shared with command-line version)
- **Graphics**: Core Graphics (via NSBezierPath)

## Comparison with Command-Line Version

| Feature | GUI | Command-Line |
|---------|-----|--------------|
| Interactive input | ✅ | ❌ |
| Visual grid | ✅ | ❌ |
| File operations | ✅ | ✅ |
| Batch processing | ❌ | ✅ |
| Scripting | ❌ | ✅ |
| Performance | Same | Same |

## Tips

1. **Quick Testing**: Use the test files in the `tests/` directory
2. **Large Puzzles**: 16×16 puzzles work best with reduction enabled
3. **Manual Solving**: Enter partial solutions and click Solve to complete
4. **Verification**: Load a puzzle, solve it, save it, then compare with expected output

## Future Enhancements

Possible improvements:
- [ ] Undo/Redo functionality
- [ ] Hint system (show next logical move)
- [ ] Step-by-step solving visualization
- [ ] Puzzle generator
- [ ] Difficulty rating
- [ ] Timer for manual solving
- [ ] Multiple puzzle tabs

## License

This GUI is part of the Sudoku Solver project and is provided as-is for educational purposes.

## See Also

- [Main README](README.md) - Command-line solver documentation
- [Algorithm Overview](README.md#algorithm-overview) - How the solver works
- [Testing](README.md#testing) - Test suite information