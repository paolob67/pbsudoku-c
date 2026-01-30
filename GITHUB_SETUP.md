# GitHub Setup Guide

This guide will help you commit your Sudoku Solver project to GitHub.

## Prerequisites

- Git installed on your system
- A GitHub account
- GitHub CLI (optional, but recommended)

## Step-by-Step Instructions

### 1. Initialize Git Repository (if not already done)

```bash
cd /Users/paolo/Documents/Personal/sudoku/pbsudoku_c_bob
git init
```

### 2. Add All Files

```bash
git add -A
```

This will add all files except those listed in `.gitignore`:
- Compiled executables (`sudoku_solver`, `sudoku_gui`)
- Object files (`*.o`)
- Test output files (`tests/*.out`)
- macOS system files (`.DS_Store`, etc.)

### 3. Create Initial Commit

```bash
git commit -m "Initial commit: Sudoku solver with CLI and macOS GUI

- Backtracking algorithm with constraint propagation
- Support for 9×9 and 16×16 puzzles
- Command-line interface
- Native macOS GUI with Cocoa/AppKit
- Comprehensive test suite
- Full documentation"
```

### 4. Create GitHub Repository

#### Option A: Using GitHub CLI (Recommended)

```bash
# Login to GitHub (if not already logged in)
gh auth login

# Create repository and push
gh repo create pbsudoku-c --public --source=. --remote=origin --push
```

#### Option B: Using GitHub Web Interface

1. Go to https://github.com/new
2. Repository name: `pbsudoku-c` (or your preferred name)
3. Description: "High-performance Sudoku solver in C with native macOS GUI"
4. Choose Public or Private
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

### 5. Connect to GitHub Repository (if using Option B)

```bash
# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/pbsudoku-c.git

# Verify remote
git remote -v

# Push to GitHub
git branch -M main
git push -u origin main
```

### 6. Verify Upload

Visit your repository on GitHub to confirm all files are uploaded:
```
https://github.com/YOUR_USERNAME/pbsudoku-c
```

## Repository Structure

Your repository will include:

```
pbsudoku-c/
├── .gitignore              # Git ignore rules
├── LICENSE                 # MIT License
├── README.md               # Main documentation
├── GUI_README.md           # GUI-specific documentation
├── QUICKSTART_GUI.md       # Quick start guide
├── GITHUB_SETUP.md         # This file
├── Makefile                # Build configuration
├── sudoku_solver.h         # Header file
├── sudoku_solver.c         # Main solver implementation
├── sudoku_lib.c            # Library version (for GUI)
├── sudoku_gui.m            # macOS GUI implementation
└── tests/                  # Test suite
    ├── run_tests.sh
    ├── test*.in
    ├── test*.expected
    └── sample-16x16.in
```

## Suggested Repository Settings

### Topics/Tags
Add these topics to your repository for better discoverability:
- `sudoku`
- `sudoku-solver`
- `backtracking`
- `c`
- `objective-c`
- `macos`
- `cocoa`
- `constraint-satisfaction`
- `algorithm`

### About Section
**Description:** High-performance Sudoku solver in C with backtracking algorithm and native macOS GUI

**Website:** (optional - if you have a demo or documentation site)

### Repository Features
- ✅ Issues (for bug reports and feature requests)
- ✅ Discussions (for Q&A and community)
- ✅ Projects (optional - for roadmap)

## Future Updates

To push future changes:

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "Description of changes"

# Push to GitHub
git push
```

## Branching Strategy (Optional)

For collaborative development:

```bash
# Create development branch
git checkout -b develop

# Create feature branches
git checkout -b feature/new-feature

# Merge back to main when ready
git checkout main
git merge feature/new-feature
git push
```

## Additional GitHub Features

### Add Badges to README

Consider adding these badges to the top of your README.md:

```markdown
![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![Language](https://img.shields.io/badge/language-C-orange)
```

### Create Releases

When you reach milestones:

```bash
# Tag a version
git tag -a v1.0.0 -m "Version 1.0.0: Initial release"
git push origin v1.0.0
```

Then create a release on GitHub with release notes.

## Troubleshooting

### Large Files
If you accidentally committed large files:
```bash
git rm --cached large_file
echo "large_file" >> .gitignore
git commit -m "Remove large file"
```

### Wrong Remote URL
```bash
git remote set-url origin https://github.com/YOUR_USERNAME/pbsudoku-c.git
```

### Authentication Issues
Use GitHub CLI or set up SSH keys:
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to GitHub: Settings → SSH and GPG keys
```

## Need Help?

- GitHub Docs: https://docs.github.com
- Git Documentation: https://git-scm.com/doc
- GitHub CLI: https://cli.github.com/manual/

Happy coding! 🚀