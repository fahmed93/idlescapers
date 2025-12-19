# Quick Reference - Time to Level Feature

## What Was Added
A new label in the training panel that shows "Time to level X: [time]" while actively training.

## Where to Find It
**In-game**: Training Panel → Below action progress → Above Stop button

**In code**:
- UI: `scenes/main.tscn` line 115-120
- Logic: `scripts/main.gd` lines 394-436
- Test: `test/test_time_to_level.gd`

## Code Snippet
```gdscript
# Calculate and display time to next level
var current_level := GameManager.get_skill_level(GameManager.current_skill_id)
if current_level < GameManager.MAX_LEVEL:
    var current_xp := GameManager.get_skill_xp(GameManager.current_skill_id)
    var next_level_xp := GameManager.get_xp_for_level(current_level + 1)
    var xp_needed := next_level_xp - current_xp
    
    var effective_action_time := method.get_effective_action_time(GameManager.current_skill_id)
    var actions_needed := ceil(xp_needed / method.xp_per_action)
    var time_to_level := actions_needed * effective_action_time
    
    var time_text := _format_time_to_level(time_to_level)
    time_to_level_label.text = "Time to level %d: %s" % [current_level + 1, time_text]
else:
    time_to_level_label.text = "Max level reached!"
```

## How It Works
1. Gets current XP and XP needed for next level
2. Calculates actions needed: `ceil(xp_needed / xp_per_action)`
3. Multiplies by effective action time (includes speed bonuses)
4. Formats as human-readable time
5. Updates every frame while training

## Example Output
- Level 1→2: "Time to level 2: 18s"
- Level 31→32: "Time to level 32: 15m 30s"
- Level 99: "Max level reached!"

## Testing
Run: `godot --headless test/test_time_to_level.tscn`
All 4 tests should pass.

## Documentation
- Full details: `docs/TIME_TO_LEVEL_IMPLEMENTATION.md`
- Visual mockups: `docs/TIME_TO_LEVEL_VISUAL_MOCKUP.md`
- Examples: `docs/VISUAL_EXAMPLES.md`
- Summary: `docs/TIME_TO_LEVEL_SUMMARY.md`
