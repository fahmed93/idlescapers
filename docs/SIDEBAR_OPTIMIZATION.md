# Sidebar Skill Button Optimization

## Problem Statement
The sidebar implementation had a pattern that suggested dynamic skill repopulation, but the clearing and recreating logic was unnecessary and error-prone.

## Issues with Previous Implementation

### 1. Misleading Function Name
**Before:** `_populate_skill_sidebar()`
- Name suggests it can be called multiple times to "populate" skills
- Implies skills might be added/removed dynamically
- Only called once during `_ready()`

**After:** `_create_skill_buttons()`
- Clearly indicates single-use, creation-only purpose
- Matches naming convention of other UI creation functions
- Better reflects actual behavior

### 2. Unnecessary Clearing Logic
**Before:**
```gdscript
# Clear existing skill buttons (but not the headers or player section buttons or info section buttons)
for child in skill_sidebar.get_children():
    if child is Button and child != upgrades_button and child != inventory_button and child != equipment_button and child != skill_summary_button and child != settings_button:
        child.queue_free()
    # Also remove TotalLevelLabel if it exists to recreate it
    elif child.name == "TotalLevelLabel":
        child.queue_free()
skill_buttons.clear()
```

**Issues:**
- Manual exclusion list for special buttons (error-prone)
- Led to Equipment button bug when it wasn't added to exclusion list
- Clearing logic unnecessary since function is only called once
- Pattern suggests skills might change dynamically (they don't)

**After:**
```gdscript
# No clearing logic - buttons are created once
# Skills are static (defined at startup in GameManager._load_skills())
```

### 3. Why Skills Don't Need Repopulation

**Skills are Static:**
- All skills defined in `GameManager._load_skills()` during autoload initialization
- No runtime skill addition/removal
- Skill list is final at game startup

**Updates are Targeted:**
- Individual skill button updates use `_update_sidebar_button(skill_id)`
- Only updates button text when XP/levels change
- Much more efficient than recreating all buttons

## Benefits of Refactoring

### 1. Performance
- No unnecessary object destruction and recreation
- More predictable memory usage
- Simpler code execution path

### 2. Maintainability
- No manual exclusion list to maintain
- New special buttons don't require adding to exclusion list
- Eliminates category of bugs (like the Equipment button issue)

### 3. Code Clarity
- Function name accurately describes behavior
- Code intent is clear (create once, update as needed)
- Consistent with pattern used for other UI elements

## Implementation Details

### Button Creation Flow
```
_ready()
  ├─ _create_player_section_buttons()  → Equipment, Inventory, Upgrades
  ├─ _create_info_section_buttons()    → Progress, Settings
  └─ _create_skill_buttons()           → All skill buttons + Total Level label
```

### Button Update Flow
```
GameManager.skill_xp_gained signal
  └─ _on_skill_xp_gained()
      └─ _update_sidebar_button(skill_id)  → Updates single button text

GameManager.skill_level_up signal
  └─ _on_skill_level_up()
      └─ _update_sidebar_button(skill_id)  → Updates single button text
```

## Testing
Updated test to reflect new function name:
- `test/test_progress_settings_persist.gd` - Tests that special buttons persist when skill buttons are recreated

## Files Changed
1. `scripts/main.gd`
   - Renamed `_populate_skill_sidebar()` → `_create_skill_buttons()`
   - Removed clearing logic
   - Added clarifying comment about static skills

2. `test/test_progress_settings_persist.gd`
   - Updated function call to `_create_skill_buttons()`
   - Updated test descriptions

3. `docs/EQUIPMENT_BUTTON_FIX.md`
   - Updated to explain the refactoring
   - Documented root cause analysis

## Future Considerations
If skills ever need to be added/removed dynamically:
1. Keep the `_create_skill_buttons()` function as-is
2. Add a separate `_remove_skill_button(skill_id)` function
3. Add a separate `_add_skill_button(skill_id)` function
4. Use targeted add/remove instead of clear-and-recreate pattern

This maintains performance and avoids the exclusion list problem.
