// sudoku_lib.c
// Library version of sudoku solver (without main function)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <time.h>
#include <math.h>
#include "sudoku_solver.h"

int N = DEFAULT_N; // Global variable for puzzle size

void print_help() {
    printf("\nUsage: sudoku_solver -i <input_file> -o <output_file> [options]\n\n");
    printf("Solves a 9x9 or 16x16 Sudoku puzzle using backtracking.\n\n");
    printf("Options:\n");
    printf("  -i, --input <input_file>     Path to puzzle input file\n");
    printf("  -o, --output <output_file>   Path for solved puzzle output\n");
    printf("  -r, --reduce                 Apply reduction step before solving\n");
    printf("  -s, --size <size>            Puzzle size: 3 for 9x9, 4 for 16x16 [default: 3]\n");
    printf("  -h, --help                   Show this help message\n\n");
    printf("Input Format:\n");
    printf("  For 9x9: 9 lines, 9 integers per line (0–9), space-separated\n");
    printf("  For 16x16: 16 lines, 16 integers per line (0–16), space-separated\n");
    printf("  Use 0 for empty cells\n\n");
    printf("Example (9x9):\n");
    printf("  5 3 0 0 7 0 0 0 0\n");
    printf("  6 0 0 1 9 5 0 0 0\n");
    printf("  0 9 8 0 0 0 0 6 0\n");
    printf("  8 0 0 0 6 0 0 0 3\n");
    printf("  4 0 0 8 0 3 0 0 1\n");
    printf("  7 0 0 0 2 0 0 0 6\n");
    printf("  0 6 0 0 0 0 2 8 0\n");
    printf("  0 0 0 4 1 9 0 0 5\n");
    printf("  0 0 0 0 8 0 0 7 9\n\n");
}

bool read_puzzle(int puzzle[MAX_SIZE][MAX_SIZE], const char* filename, int size) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Error: Cannot open input file.\n");
        return false;
    }

    for (int row = 0; row < size; ++row) {
        for (int col = 0; col < size; ++col) {
            int val;
            if (fscanf(file, "%d", &val) != 1 || val < 0 || val > size) {
                fprintf(stderr, "Error: Invalid input at row %d, column %d. Expected 0-%d, got %d.\n", 
                        row + 1, col + 1, size, val);
                fclose(file);
                return false;
            }
            puzzle[row][col] = val;
        }
    }

    fclose(file);
    return true;
}

bool write_puzzle(FILE* out, int puzzle[MAX_SIZE][MAX_SIZE], int size) {
    if (!out) {
        fprintf(stderr, "Error: Output file not writable.\n");
        return false;
    }

    for (int i = 0; i < size; ++i) {
        for (int j = 0; j < size; ++j) {
            if (size == 16 && puzzle[i][j] >= 10) {
                fprintf(out, "%2d ", puzzle[i][j]); // Use 2-character width for 16x16
            } else {
                fprintf(out, "%d ", puzzle[i][j]);
            }
        }
        fprintf(out, "\n");
    }

    return true;
}

bool must_place(const int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int val, int size) {
    int n = (int)sqrt(size); // Get the sub-grid size (3 for 9x9, 4 for 16x16)
    int row_start = (row / n) * n;
    int col_start = (col / n) * n;

    if(can_place(puzzle, row, col, val, size)) {
        for (int i = row_start; i < row_start + n; ++i) {
            for (int j = col_start; j < col_start + n; ++j) {
                if (((i != row) || (j != col)) && (puzzle[i][j] == TO_FILL) && 
                    can_place(puzzle, i, j, val, size)) 
                    return false;
            }
        }
        return true;
    }
    return false;
}

bool can_place(const int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int val, int size) {
    return is_row_ok(puzzle[row], col, val, size) &&
           is_col_ok(puzzle, row, col, val, size) &&
           is_sqr_ok(puzzle, row, col, val, size);
}

bool is_row_ok(const int row[MAX_SIZE], int col, int val, int size) {
    for (int i = 0; i < size; ++i)
        if (i != col && row[i] == val)
            return false;
    return true;
}

bool is_col_ok(const int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int val, int size) {
    for (int i = 0; i < size; ++i)
        if (i != row && puzzle[i][col] == val)
            return false;
    return true;
}

bool is_sqr_ok(const int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int val, int size) {
    int n = (int)sqrt(size); // Get the sub-grid size
    int row_start = (row / n) * n;
    int col_start = (col / n) * n;

    for (int i = row_start; i < row_start + n; ++i)
        for (int j = col_start; j < col_start + n; ++j)
            if ((i != row || j != col) && puzzle[i][j] == val)
                return false;

    return true;
}

bool reduce_puzzle(int puzzle[MAX_SIZE][MAX_SIZE], int size) {
    for (int val = 1; val <= size; ++val) {
        for (int row = 0; row < size; ++row) {
            for (int col = 0; col < size; ++col) {
                if (((puzzle[row][col] == TO_FILL)) && must_place(puzzle, row, col, val, size)) {
                    puzzle[row][col] = val;
                    return true;
                }
            }
        }
    }

    return false;
}

bool solve_puzzle(int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int size) {
    if (row == size)
        return true;

    int next_row = (col == size - 1) ? row + 1 : row;
    int next_col = (col + 1) % size;

    if (puzzle[row][col] != TO_FILL)
        return solve_puzzle(puzzle, next_row, next_col, size);
    
    
    for (int val = 1; val <= size; ++val) {
        puzzle[row][col] = val;

        if (can_place(puzzle, row, col, val, size) &&
            solve_puzzle(puzzle, next_row, next_col, size))
            return true;

        puzzle[row][col] = TO_FILL;
    }

    return false;
}

// Made with Bob
