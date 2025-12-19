# Time to Level Feature

## Overview
This feature adds a "time to level" indicator in the training panel that shows players how long it will take to reach the next level at their current training rate.

## Implementation Details

### Core Logic (GameManager)
- **`get_time_to_next_level()`**: Calculates time in seconds until the next level
  - Returns -1 if not training or at max level (99)
  - Returns -1 if XP per action is 0 (division by zero guard)
  - Accounts for:
    - Current XP and XP remaining to next level
    - Training method's XP per action
    - Success rate of the training method
    - Speed modifiers from purchased upgrades

### UI Updates

#### Training Panel Display
- Shows time to level in the training panel: "Time to level: 5m 30s"
- Updates dynamically as the player trains
- Displays "Time to level: MAX" when at level 99
- Displays "Time to level: --" when not training

#### Real-time Updates
- Time to level recalculates every frame during training
- Automatically updates when:
  - Player gains XP
  - Training method changes
  - Speed upgrades are purchased

## Calculation Formula

```gdscript
XP remaining = XP for next level - Current XP
XP per action = Method XP × Success rate
Actions needed = XP remaining / XP per action
Time to level = Actions needed × Effective action time
```

Where:
- `Effective action time = Base action time / (1 + Speed modifier)`
- `Speed modifier` comes from purchased upgrades (e.g., 0.1 for +10% speed)

## Example Scenarios

### Basic Training (No Upgrades)
**Fishing Shrimp at Level 1**
- Current XP: 0
- XP to Level 2: 83
- XP per action: 10
- Action time: 3s
- **Time to level**: (83 / 10) × 3s = 24.9s

**Fishing Salmon at Level 30**
- Current XP: 13,363 (exactly level 30)
- XP to Level 31: 368 (13,731 - 13,363)
- XP per action: 70
- Action time: 5s
- **Time to level**: (368 / 70) × 5s ≈ 26.3s

### With Speed Upgrades
**Fishing Shrimp with +10% Speed Bonus**
- XP to Level 2: 83
- XP per action: 10
- Base action time: 3s
- Effective action time: 3s / 1.1 ≈ 2.73s
- **Time to level**: (83 / 10) × 2.73s ≈ 22.6s

## Time Display Format
Uses the same formatting as "time remaining" feature:
- **< 60s**: "30s"
- **< 1 hour**: "5m 30s"
- **≥ 1 hour**: "2h 15m"

## Testing
Run the test scene: `test/test_time_to_level.tscn`

The test validates:
1. Returns -1 when not training
2. Correct calculation at level 1
3. Correct calculation at level 30
4. Returns -1 at max level (99)
5. Uses dynamic XP values from the XP table

## Files Changed
1. `autoload/game_manager.gd` - Core calculation logic
2. `scenes/main.tscn` - UI Label addition
3. `scripts/main.gd` - Display updates
4. `test/test_time_to_level.gd` - Test script
5. `test/test_time_to_level.tscn` - Test scene
