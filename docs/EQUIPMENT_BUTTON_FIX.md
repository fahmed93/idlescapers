# Equipment Button Sidebar Fix

## Issue
The Equipment button was not visible in the sidebar, even though the code to create it existed.

## Root Cause
The `_create_skill_buttons()` function (formerly `_populate_skill_sidebar()`) was clearing all buttons in the sidebar except for `upgrades_button` and `inventory_button`. The `equipment_button` was being deleted during this cleanup process.

### Code Flow
```
_ready() 
  ├─ _create_inventory_button()   → creates inventory_button
  ├─ _create_equipment_button()   → creates equipment_button
  ├─ _create_upgrades_button()    → creates upgrades_button
  └─ _create_skill_buttons()      → was deleting equipment_button ❌
```

### Before Fix (Line 211)
```gdscript
# Clear existing skill buttons (but not the headers or player section buttons or info section buttons)
for child in skill_sidebar.get_children():
    if child is Button and child != upgrades_button and child != inventory_button:
        child.queue_free()  # This deleted equipment_button!
```

### After Fix
The clearing logic was removed entirely because:
1. Skills are static (defined at startup in `GameManager._load_skills()`)
2. No dynamic skill addition/removal during gameplay
3. The function is only called once during `_ready()`
4. Individual skill button updates use `_update_sidebar_button()` which just updates text

The function was also renamed from `_populate_skill_sidebar()` to `_create_skill_buttons()` to better reflect its single-use, creation-only purpose.

## Solution
Refactored the sidebar skill button creation to:
- Remove the clearing/repopulation pattern (unnecessary since skills are static)
- Rename function to `_create_skill_buttons()` for clarity
- Eliminate error-prone manual exclusion list maintenance

## Files Changed
- `scripts/main.gd` - Refactored `_populate_skill_sidebar()` → `_create_skill_buttons()`, removed clearing logic
- `test/test_progress_settings_persist.gd` - Updated test to use new function name

## Testing
Tests verify that special buttons (Equipment, Inventory, Upgrades, Progress, Settings) persist correctly:
- `test/test_sidebar_buttons.gd` - Tests that all special buttons exist
- `test/test_progress_settings_persist.gd` - Tests button persistence after skill button recreation

## Result
The Equipment button now appears in the sidebar alongside the Inventory and Upgrades buttons, allowing players to access the equipment management screen. The refactored code is clearer, more maintainable, and eliminates the manual exclusion list that led to this bug.
