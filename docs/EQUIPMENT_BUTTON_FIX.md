# Equipment Button Sidebar Fix

## Issue
The Equipment button was not visible in the sidebar, even though the code to create it existed.

## Root Cause
The `_populate_skill_sidebar()` function was clearing all buttons in the sidebar except for `upgrades_button` and `inventory_button`. The `equipment_button` was being deleted during this cleanup process.

### Code Flow
```
_ready() 
  ├─ _create_inventory_button()   → creates inventory_button
  ├─ _create_equipment_button()   → creates equipment_button
  ├─ _create_upgrades_button()    → creates upgrades_button
  └─ _populate_skill_sidebar()    → was deleting equipment_button ❌
```

### Before Fix (Line 111)
```gdscript
if child is Button and child != upgrades_button and child != inventory_button:
    child.queue_free()  # This deleted equipment_button!
```

### After Fix (Line 111)
```gdscript
if child is Button and child != upgrades_button and child != inventory_button and child != equipment_button:
    child.queue_free()  # Now equipment_button is preserved ✓
```

## Solution
Added `equipment_button` to the exclusion list in `_populate_skill_sidebar()` so it persists alongside the inventory and upgrades buttons.

## Files Changed
- `scripts/main.gd` - Added `and child != equipment_button` to the exclusion check in `_populate_skill_sidebar()`

## Testing
A new test was created to verify all three special buttons (Equipment, Inventory, Upgrades) are present in the sidebar:
- `test/test_sidebar_buttons.gd` - Tests that all special buttons exist
- `test/test_sidebar_buttons.tscn` - Test scene

## Result
The Equipment button now appears in the sidebar alongside the Inventory and Upgrades buttons, allowing players to access the equipment management screen.
