#ifndef SUDOKU_SOLVER_H
#define SUDOKU_SOLVER_H

#define DEFAULT_N 3
#define TO_FILL 0
#define MAX_N 4
#define MAX_SIZE (MAX_N * MAX_N)

#include <stdbool.h>

extern int N; // Global variable for puzzle size

void print_help(void);
bool read_puzzle(int puzzle[MAX_SIZE][MAX_SIZE], const char* filename, int size);
bool write_puzzle(FILE* out, int puzzle[MAX_SIZE][MAX_SIZE], int size);
bool reduce_puzzle(int puzzle[MAX_SIZE][MAX_SIZE], int size);
bool solve_puzzle(int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int size);
bool can_place(const int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int val, int size);
bool must_place(const int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int val, int size);
bool is_row_ok(const int row[MAX_SIZE], int col, int val, int size);
bool is_col_ok(const int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int val, int size);
bool is_sqr_ok(const int puzzle[MAX_SIZE][MAX_SIZE], int row, int col, int val, int size);

#endif