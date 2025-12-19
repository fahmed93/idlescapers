# Time to Level Display Implementation

## Feature Description
Displays the estimated time required to reach the next level while actively training a skill, shown in the training panel below the action progress bar.

## Implementation Details

### UI Changes
**File: `scenes/main.tscn`**
- Added `TimeToLevelLabel` node to the TrainingPanel's VBoxContainer
- Positioned between `TrainingTimeLabel` and `StopButton`
- Styled with:
  - Font size: 12
  - Horizontal alignment: center
  - Font color: Light blue (0.6, 0.8, 1.0)

### Code Changes
**File: `scripts/main.gd`**

1. **Added node reference:**
   ```gdscript
   @onready var time_to_level_label: Label = $HSplitContainer/MainContent/TrainingPanel/VBoxContainer/TimeToLevelLabel
   ```

2. **Updated `_hide_training_panel()`:**
   - Clears the time to level label when training stops

3. **Enhanced `_update_training_progress()`:**
   - Calculates time to next level using:
     - Current XP and XP needed for next level
     - XP per action from current training method
     - Effective action time (includes speed modifiers from upgrades)
   - Formula: `ceil(xp_needed / xp_per_action) * effective_action_time`
   - Displays "Max level reached!" when at level 99

4. **Added helper function `_format_time_to_level(seconds: float)`:**
   - Formats time in human-readable format:
     - `< 60s`: "30s"
     - `< 1h`: "5m 30s" or "5m"
     - `< 24h`: "2h 30m" or "2h"
     - `>= 24h`: "3d 5h" or "3d"

## Example Display
When training Fishing at level 1, catching shrimp:
```
Training: Shrimp
[Progress Bar]
0.5s / 2.0s
Time to level 2: 18s
[Stop Training Button]
```

When training at higher levels with upgrades:
```
Training: Lobster
[Progress Bar]
1.2s / 2.5s
Time to level 51: 2h 15m
[Stop Training Button]
```

## Features
- **Real-time updates**: Recalculates every frame during training
- **Speed bonus aware**: Accounts for purchased upgrade bonuses
- **Max level handling**: Shows appropriate message at level 99
- **Consistent formatting**: Uses similar time format as other time displays in the game

## Testing
Created `test/test_time_to_level.gd` to verify:
- Correct calculation at level 1
- Proper handling of speed modifiers
- Accurate calculation at higher levels
- Max level edge case

## Technical Notes
- Uses `GameManager.get_effective_action_time()` to account for speed bonuses
- Updates only when actively training (in `_process()` loop)
- Calculation is based on current training method only (doesn't average across methods)
- XP calculation uses the RuneScape XP formula via `GameManager.get_xp_for_level()`
