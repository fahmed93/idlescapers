# Testing Documentation

## Overview
This project uses scene-based automated tests written in GDScript that run in Godot's headless mode. Tests validate game mechanics, skill systems, and core functionality.

## Test Structure

### Location
All tests are located in the `/test` directory with two files per test:
- `test_<name>.tscn` - Scene file that loads the test
- `test_<name>.gd` - GDScript test implementation

### Test Format
Tests follow this pattern:
```gdscript
extends Node

func _ready() -> void:
    print("\n=== TEST NAME ===")
    
    # Wait for autoloads to initialize
    await get_tree().process_frame
    
    # Run test assertions
    assert(condition, "Error message")
    print("  ✓ Test passed")
    
    # Clean up and quit
    await get_tree().create_timer(0.5).timeout
    get_tree().quit()
```

### Running Tests

#### Locally
Run all tests using the provided script:
```bash
./run_tests.sh
```

Run a specific test:
```bash
godot --headless --path . test/test_<name>.tscn
```

#### In CI/CD
Tests automatically run in the PR workflow (`.github/workflows/pr-build.yml`) after the import step and before the build step.

The workflow will:
1. Import project assets
2. Run all automated tests
3. Build HTML5 export (only if tests pass)
4. Upload build artifacts

### Test Results
- **Exit Code 0**: All tests passed
- **Non-zero Exit Code**: One or more tests failed
- Failed assertions will cause Godot to exit with a non-zero code
- The test runner script (`run_tests.sh`) aggregates results and reports failures

### Test Coverage
Current automated tests cover:
- Skill systems (fishing, woodcutting, mining, smithing, etc.)
- Character management
- Inventory system
- Upgrade shop
- Crafting mechanics
- XP and leveling
- Item handling
- UI components

### Adding New Tests
1. Create `test/<name>.tscn` scene with a Node root
2. Attach `test/<name>.gd` script to the root node
3. Implement test logic in `_ready()` function
4. Use `assert()` for validation
5. Call `get_tree().quit()` at the end
6. Tests will automatically be picked up by the test runner

### Manual Tests
Some tests are marked as `manual_verify_*.gd` and are intended for visual verification during development. These can still run in headless mode but are primarily for developer use.
