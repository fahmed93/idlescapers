#!/bin/bash
# Run all Godot test scenes and report results

set -e  # Exit on first error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==================================================="
echo "Running Godot Tests"
echo "==================================================="
echo ""

# Find all test scene files, excluding manual verification tests
TEST_SCENES=$(find test -name "test_*.tscn" -type f | sort)

# Count tests
TOTAL_TESTS=$(echo "$TEST_SCENES" | wc -l)
PASSED_TESTS=0
FAILED_TESTS=0
FAILED_TEST_LIST=""

echo "Found $TOTAL_TESTS test(s) to run"
echo ""

# Run each test
for test_scene in $TEST_SCENES; do
    test_name=$(basename "$test_scene" .tscn)
    echo "---------------------------------------------------"
    echo "Running: $test_name"
    echo "---------------------------------------------------"
    
    # Run the test in headless mode
    if godot --headless --path . "$test_scene" 2>&1; then
        echo "✅ PASSED: $test_name"
        ((PASSED_TESTS++))
    else
        EXIT_CODE=$?
        echo "❌ FAILED: $test_name (exit code: $EXIT_CODE)"
        ((FAILED_TESTS++))
        FAILED_TEST_LIST="$FAILED_TEST_LIST\n  - $test_name"
    fi
    echo ""
done

echo "==================================================="
echo "Test Results Summary"
echo "==================================================="
echo "Total:  $TOTAL_TESTS"
echo "Passed: $PASSED_TESTS"
echo "Failed: $FAILED_TESTS"
echo ""

if [ $FAILED_TESTS -gt 0 ]; then
    echo "Failed tests:$FAILED_TEST_LIST"
    echo ""
    echo "❌ Some tests failed"
    exit 1
else
    echo "✅ All tests passed!"
    exit 0
fi
