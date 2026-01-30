# Makefile for sudoku_solver in C

CC = gcc
CFLAGS = -Wall -O3

.PHONY: all clean test gui app
TARGET = sudoku_solver
GUI_TARGET = sudoku_gui
OBJS = sudoku_solver.o

.PHONY: all clean gui test

all: $(TARGET)

gui: $(GUI_TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

$(GUI_TARGET): sudoku_gui.m sudoku_lib.c sudoku_solver.h
	clang -framework Cocoa -o $(GUI_TARGET) sudoku_gui.m sudoku_lib.c -lm -O3

sudoku_solver.o: sudoku_solver.c sudoku_solver.h
	$(CC) $(CFLAGS) -c sudoku_solver.c

# Create macOS app bundle
app: gui
	@echo "Creating macOS app bundle..."
	@./create_app_bundle.sh
	@echo "Done! Launch with: open SudokuSolver.app"

clean:
	rm -f $(TARGET) $(GUI_TARGET) $(OBJS)
	rm -rf SudokuSolver.app

test:
	cd tests && ./run_tests.sh
