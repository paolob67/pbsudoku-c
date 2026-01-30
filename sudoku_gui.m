// sudoku_gui.m
// macOS GUI for Sudoku Solver using Cocoa/AppKit
//
// Compile:
//     clang -framework Cocoa -o sudoku_gui sudoku_gui.m sudoku_solver.c -lm
//
// Run:
//     ./sudoku_gui

#import <Cocoa/Cocoa.h>
#include "sudoku_solver.h"
#include <math.h>

// Custom view for drawing the Sudoku grid
@interface SudokuGridView : NSView {
    int puzzle[MAX_SIZE][MAX_SIZE];
    int originalPuzzle[MAX_SIZE][MAX_SIZE];  // Track original values
    int size;
    NSMutableArray *textFields;
}
- (void)setPuzzle:(int[MAX_SIZE][MAX_SIZE])newPuzzle size:(int)newSize;
- (void)setPuzzle:(int[MAX_SIZE][MAX_SIZE])newPuzzle size:(int)newSize isOriginal:(BOOL)isOriginal;
- (void)getPuzzle:(int[MAX_SIZE][MAX_SIZE])outPuzzle;
- (void)clearGrid;
@end

@implementation SudokuGridView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        size = 9; // Default 9x9
        textFields = [[NSMutableArray alloc] init];
        [self clearGrid];
        [self createTextFields];
    }
    return self;
}

- (void)clearGrid {
    for (int i = 0; i < MAX_SIZE; i++) {
        for (int j = 0; j < MAX_SIZE; j++) {
            puzzle[i][j] = 0;
            originalPuzzle[i][j] = 0;
        }
    }
}

- (void)createTextFields {
    // Remove existing text fields
    for (NSTextField *field in textFields) {
        [field removeFromSuperview];
    }
    [textFields removeAllObjects];
    
    CGFloat cellSize = MIN(self.bounds.size.width, self.bounds.size.height) / size;
    
    for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
            NSRect cellRect = NSMakeRect(col * cellSize + 2, 
                                        (size - row - 1) * cellSize + 2,
                                        cellSize - 4, cellSize - 4);
            
            NSTextField *textField = [[NSTextField alloc] initWithFrame:cellRect];
            [textField setAlignment:NSTextAlignmentCenter];
            [textField setFont:[NSFont systemFontOfSize:(size == 9 ? 20 : 14)]];
            [textField setBezeled:YES];
            [textField setBezelStyle:NSTextFieldSquareBezel];
            [textField setTag:(row * MAX_SIZE + col)];
            
            // Set formatter to accept only valid numbers
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setMinimum:@0];
            [formatter setMaximum:@(size)];
            [formatter setAllowsFloats:NO];
            [textField setFormatter:formatter];
            
            [self addSubview:textField];
            [textFields addObject:textField];
        }
    }
}

- (void)setPuzzle:(int[MAX_SIZE][MAX_SIZE])newPuzzle size:(int)newSize {
    [self setPuzzle:newPuzzle size:newSize isOriginal:NO];
}

- (void)setPuzzle:(int[MAX_SIZE][MAX_SIZE])newPuzzle size:(int)newSize isOriginal:(BOOL)isOriginal {
    size = newSize;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            puzzle[i][j] = newPuzzle[i][j];
            if (isOriginal) {
                originalPuzzle[i][j] = newPuzzle[i][j];
            }
        }
    }
    
    [self createTextFields];
    
    // Update text fields with puzzle values
    for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
            NSTextField *field = textFields[row * size + col];
            BOOL isOriginalValue = (originalPuzzle[row][col] != 0);
            
            if (puzzle[row][col] != 0) {
                [field setStringValue:[NSString stringWithFormat:@"%d", puzzle[row][col]]];
                
                if (isOriginalValue) {
                    // Original values: bold font and blue color
                    [field setFont:[NSFont boldSystemFontOfSize:(size == 9 ? 20 : 14)]];
                    [field setTextColor:[NSColor blueColor]];
                    [field setEditable:NO];
                } else {
                    // Computed values: normal font and black color
                    [field setFont:[NSFont systemFontOfSize:(size == 9 ? 20 : 14)]];
                    [field setTextColor:[NSColor blackColor]];
                    [field setEditable:NO];
                }
            } else {
                [field setStringValue:@""];
                [field setFont:[NSFont systemFontOfSize:(size == 9 ? 20 : 14)]];
                [field setTextColor:[NSColor blackColor]];
                [field setEditable:YES];
            }
        }
    }
    
    [self setNeedsDisplay:YES];
}

- (void)getPuzzle:(int[MAX_SIZE][MAX_SIZE])outPuzzle {
    for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
            NSTextField *field = textFields[row * size + col];
            NSString *value = [field stringValue];
            if ([value length] > 0) {
                outPuzzle[row][col] = [value intValue];
            } else {
                outPuzzle[row][col] = 0;
            }
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
    CGFloat cellSize = MIN(self.bounds.size.width, self.bounds.size.height) / size;
    int n = (int)sqrt(size);
    
    [[NSColor blackColor] setStroke];
    
    // Draw thin grid lines first
    NSBezierPath *thinPath = [NSBezierPath bezierPath];
    [thinPath setLineWidth:0.5];
    
    for (int i = 1; i < size; i++) {
        if (i % n != 0) {  // Skip lines that will be drawn as medium/thick
            // Horizontal lines
            [thinPath moveToPoint:NSMakePoint(0, i * cellSize)];
            [thinPath lineToPoint:NSMakePoint(size * cellSize, i * cellSize)];
            
            // Vertical lines
            [thinPath moveToPoint:NSMakePoint(i * cellSize, 0)];
            [thinPath lineToPoint:NSMakePoint(i * cellSize, size * cellSize)];
        }
    }
    [thinPath stroke];
    
    // Draw medium lines for NxN squares
    NSBezierPath *mediumPath = [NSBezierPath bezierPath];
    [mediumPath setLineWidth:2.0];
    
    for (int i = n; i < size; i += n) {
        // Horizontal lines
        [mediumPath moveToPoint:NSMakePoint(0, i * cellSize)];
        [mediumPath lineToPoint:NSMakePoint(size * cellSize, i * cellSize)];
        
        // Vertical lines
        [mediumPath moveToPoint:NSMakePoint(i * cellSize, 0)];
        [mediumPath lineToPoint:NSMakePoint(i * cellSize, size * cellSize)];
    }
    [mediumPath stroke];
    
    // Draw thick outer border
    NSBezierPath *outerPath = [NSBezierPath bezierPath];
    [outerPath setLineWidth:4.0];
    
    // Draw rectangle for outer border
    [outerPath moveToPoint:NSMakePoint(0, 0)];
    [outerPath lineToPoint:NSMakePoint(size * cellSize, 0)];
    [outerPath lineToPoint:NSMakePoint(size * cellSize, size * cellSize)];
    [outerPath lineToPoint:NSMakePoint(0, size * cellSize)];
    [outerPath closePath];
    [outerPath stroke];
}

@end

// Main application delegate
@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    SudokuGridView *gridView;
    NSButton *solveButton;
    NSButton *clearButton;
    NSButton *loadButton;
    NSButton *saveButton;
    NSButton *size9Button;
    NSButton *size16Button;
    NSButton *reductionCheckbox;
    NSTextField *statusLabel;
    int currentSize;
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    currentSize = 9;
    N = 3; // Default to 9x9
    
    // Create main window
    NSRect frame = NSMakeRect(0, 0, 700, 750);
    window = [[NSWindow alloc] initWithContentRect:frame
                                         styleMask:(NSWindowStyleMaskTitled |
                                                   NSWindowStyleMaskClosable |
                                                   NSWindowStyleMaskMiniaturizable)
                                           backing:NSBackingStoreBuffered
                                             defer:NO];
    [window setTitle:@"Sudoku Solver"];
    [window center];
    
    NSView *contentView = [window contentView];
    
    // Create grid view
    NSRect gridFrame = NSMakeRect(50, 150, 600, 600);
    gridView = [[SudokuGridView alloc] initWithFrame:gridFrame];
    [contentView addSubview:gridView];
    
    // Create buttons and controls
    CGFloat buttonY = 100;
    CGFloat buttonX = 50;
    CGFloat buttonWidth = 100;
    CGFloat buttonHeight = 30;
    CGFloat spacing = 10;
    
    // Solve button
    solveButton = [[NSButton alloc] initWithFrame:NSMakeRect(buttonX, buttonY, buttonWidth, buttonHeight)];
    [solveButton setTitle:@"Solve"];
    [solveButton setBezelStyle:NSBezelStyleRounded];
    [solveButton setTarget:self];
    [solveButton setAction:@selector(solvePuzzle:)];
    [contentView addSubview:solveButton];
    buttonX += buttonWidth + spacing;
    
    // Clear button
    clearButton = [[NSButton alloc] initWithFrame:NSMakeRect(buttonX, buttonY, buttonWidth, buttonHeight)];
    [clearButton setTitle:@"Clear"];
    [clearButton setBezelStyle:NSBezelStyleRounded];
    [clearButton setTarget:self];
    [clearButton setAction:@selector(clearPuzzle:)];
    [contentView addSubview:clearButton];
    buttonX += buttonWidth + spacing;
    
    // Load button
    loadButton = [[NSButton alloc] initWithFrame:NSMakeRect(buttonX, buttonY, buttonWidth, buttonHeight)];
    [loadButton setTitle:@"Load"];
    [loadButton setBezelStyle:NSBezelStyleRounded];
    [loadButton setTarget:self];
    [loadButton setAction:@selector(loadPuzzle:)];
    [contentView addSubview:loadButton];
    buttonX += buttonWidth + spacing;
    
    // Save button
    saveButton = [[NSButton alloc] initWithFrame:NSMakeRect(buttonX, buttonY, buttonWidth, buttonHeight)];
    [saveButton setTitle:@"Save"];
    [saveButton setBezelStyle:NSBezelStyleRounded];
    [saveButton setTarget:self];
    [saveButton setAction:@selector(savePuzzle:)];
    [contentView addSubview:saveButton];
    
    // Size selection buttons
    buttonY = 60;
    buttonX = 50;
    
    NSTextField *sizeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(buttonX, buttonY, 80, 20)];
    [sizeLabel setStringValue:@"Grid Size:"];
    [sizeLabel setBezeled:NO];
    [sizeLabel setDrawsBackground:NO];
    [sizeLabel setEditable:NO];
    [sizeLabel setSelectable:NO];
    [contentView addSubview:sizeLabel];
    buttonX += 90;
    
    size9Button = [[NSButton alloc] initWithFrame:NSMakeRect(buttonX, buttonY, 60, buttonHeight)];
    [size9Button setTitle:@"9×9"];
    [size9Button setBezelStyle:NSBezelStyleRounded];
    [size9Button setTarget:self];
    [size9Button setAction:@selector(setSize9:)];
    [size9Button setState:NSControlStateValueOn];
    [contentView addSubview:size9Button];
    buttonX += 70;
    
    size16Button = [[NSButton alloc] initWithFrame:NSMakeRect(buttonX, buttonY, 70, buttonHeight)];
    [size16Button setTitle:@"16×16"];
    [size16Button setBezelStyle:NSBezelStyleRounded];
    [size16Button setTarget:self];
    [size16Button setAction:@selector(setSize16:)];
    [contentView addSubview:size16Button];
    buttonX += 80;
    
    // Reduction checkbox
    reductionCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(buttonX, buttonY, 150, buttonHeight)];
    [reductionCheckbox setTitle:@"Use Reduction"];
    [reductionCheckbox setButtonType:NSButtonTypeSwitch];
    [contentView addSubview:reductionCheckbox];
    
    // Status label
    statusLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(50, 20, 600, 30)];
    [statusLabel setStringValue:@"Ready. Enter puzzle or load from file."];
    [statusLabel setBezeled:NO];
    [statusLabel setDrawsBackground:NO];
    [statusLabel setEditable:NO];
    [statusLabel setSelectable:NO];
    [statusLabel setAlignment:NSTextAlignmentCenter];
    [contentView addSubview:statusLabel];
    
    [window makeKeyAndOrderFront:nil];
}

- (void)solvePuzzle:(id)sender {
    int puzzleData[MAX_SIZE][MAX_SIZE];
    [gridView getPuzzle:puzzleData];
    
    [statusLabel setStringValue:@"Solving..."];
    
    // Apply reduction if checkbox is checked
    bool useReduction = ([reductionCheckbox state] == NSControlStateValueOn);
    int reducedCells = 0;
    
    if (useReduction) {
        bool reduced;
        do {
            reduced = reduce_puzzle(puzzleData, currentSize);
            if (reduced) reducedCells++;
        } while (reduced);
    }
    
    // Solve the puzzle
    clock_t start = clock();
    bool solved = solve_puzzle(puzzleData, 0, 0, currentSize);
    clock_t end = clock();
    double elapsed = (double)(end - start) / CLOCKS_PER_SEC;
    
    if (solved) {
        [gridView setPuzzle:puzzleData size:currentSize];
        NSString *msg = [NSString stringWithFormat:@"Solved in %.6f seconds!", elapsed];
        if (reducedCells > 0) {
            msg = [NSString stringWithFormat:@"Solved in %.6f seconds (reduced %d cells)", elapsed, reducedCells];
        }
        [statusLabel setStringValue:msg];
    } else {
        [statusLabel setStringValue:@"No solution found!"];
    }
}

- (void)clearPuzzle:(id)sender {
    int emptyPuzzle[MAX_SIZE][MAX_SIZE] = {{0}};
    [gridView setPuzzle:emptyPuzzle size:currentSize];
    [statusLabel setStringValue:@"Grid cleared."];
}

- (void)loadPuzzle:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setMessage:@"Select a Sudoku puzzle file"];
    
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *fileURL = [[panel URLs] objectAtIndex:0];
            const char *filename = [[fileURL path] UTF8String];
            
            int puzzleData[MAX_SIZE][MAX_SIZE];
            if (read_puzzle(puzzleData, filename, self->currentSize)) {
                [self->gridView setPuzzle:puzzleData size:self->currentSize isOriginal:YES];
                [self->statusLabel setStringValue:[NSString stringWithFormat:@"Loaded: %@", [fileURL lastPathComponent]]];
            } else {
                [self->statusLabel setStringValue:@"Error loading file!"];
            }
        }
    }];
}

- (void)savePuzzle:(id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setMessage:@"Save Sudoku puzzle"];
    [panel setNameFieldStringValue:@"puzzle.txt"];
    
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *fileURL = [panel URL];
            const char *filename = [[fileURL path] UTF8String];
            
            int puzzleData[MAX_SIZE][MAX_SIZE];
            [self->gridView getPuzzle:puzzleData];
            
            FILE *file = fopen(filename, "w");
            if (file && write_puzzle(file, puzzleData, self->currentSize)) {
                fclose(file);
                [self->statusLabel setStringValue:[NSString stringWithFormat:@"Saved: %@", [fileURL lastPathComponent]]];
            } else {
                if (file) fclose(file);
                [self->statusLabel setStringValue:@"Error saving file!"];
            }
        }
    }];
}

- (void)setSize9:(id)sender {
    currentSize = 9;
    N = 3;
    [size9Button setState:NSControlStateValueOn];
    [size16Button setState:NSControlStateValueOff];
    
    int emptyPuzzle[MAX_SIZE][MAX_SIZE] = {{0}};
    [gridView setPuzzle:emptyPuzzle size:currentSize];
    [statusLabel setStringValue:@"Switched to 9×9 grid."];
}

- (void)setSize16:(id)sender {
    currentSize = 16;
    N = 4;
    [size9Button setState:NSControlStateValueOff];
    [size16Button setState:NSControlStateValueOn];
    
    int emptyPuzzle[MAX_SIZE][MAX_SIZE] = {{0}};
    [gridView setPuzzle:emptyPuzzle size:currentSize];
    [statusLabel setStringValue:@"Switched to 16×16 grid."];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [app setDelegate:delegate];
        [app run];
    }
    return 0;
}

// Made with Bob
