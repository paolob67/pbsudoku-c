#!/bin/bash

EXEC=../sudoku_solver
FAILED=0
TOTAL=0

for infile in *.in; do
    testname=${infile%.in}
    outfile="${testname}.out"
    outfilered="${testname}.red.out"
    expected="${testname}.expected"

    echo "Running $testname..."
    $EXEC -i "$infile" -o "$outfile" > /dev/null 2>&1

    if diff -q "$outfile" "$expected" > /dev/null; then
        echo "✅ Passed"
    else
        echo "❌ Failed"
        diff "$outfile" "$expected"
        FAILED=$((FAILED + 1))
    fi

    $EXEC -i "$infile" -o "$outfilered" -r> /dev/null 2>&1

    if diff -q "$outfilered" "$expected" > /dev/null; then
        echo "✅ Passed with reduction"
    else
        echo "❌ Failed  with reduction"
        diff "$outfilered" "$expected"
        FAILED=$((FAILED + 1))
    fi

    TOTAL=$((TOTAL + 1))
done

echo ""
echo "$((TOTAL - FAILED)) / $TOTAL tests passed."
exit $FAILED
