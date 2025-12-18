# Time Remaining Feature Implementation

## Overview
This feature adds a display showing how much time it will take to run out of items when performing actions that consume items (e.g., cooking raw fish, making potions).

## Implementation Details

### Core Logic (TrainingMethodData)
- **`calculate_time_until_out_of_items(speed_modifier)`**: Calculates time in seconds until running out of consumed items
  - Returns -1 if the method doesn't consume items
  - Returns 0 if already out of items
  - Returns the minimum time across all consumed items (bottleneck item)
  - Accounts for speed modifiers from upgrades

- **`format_time_remaining(seconds)`**: Formats time into human-readable strings
  - "30s left" for times under 60 seconds
  - "5m 30s left" for times under 1 hour
  - "2h 15m left" for times over 1 hour

### UI Updates

#### Action List Display
- Shows available item count in parentheses: "Uses: Raw Shrimp x1 (50)"
- Displays color-coded time remaining below the item requirements:
  - **Red** (0s): Out of items
  - **Yellow** (<60s): Running low
  - **Yellowish** (60s+): Plenty of time

#### Training Progress Panel
- Shows time remaining in the training label: "Training: Cook Shrimp (3m 20s left)"
- Updates dynamically as items are consumed

#### Real-time Updates
- Action list refreshes when inventory changes to update time remaining displays
- Only refreshes when viewing a skill (not in store/upgrades/inventory views)

## Example Scenarios

### Cooking Example
- Player has 100 Raw Shrimp
- Cook Shrimp action takes 2 seconds per action
- Consumes 1 Raw Shrimp per action
- **Time remaining**: 100 × 2s = 200s = "3m 20s left"

### With Speed Bonus
- Same scenario but with 50% speed upgrade
- Modified action time: 2s / 1.5 = 1.33s
- **Time remaining**: 100 × 1.33s = 133s = "2m 13s left"

### Herblore (Multiple Items)
- Making Attack Potions requires:
  - 1 Guam Leaf (50 available)
  - 1 Eye of Newt (100 available)
- Action takes 3 seconds
- **Bottleneck**: Guam Leaf (50 actions possible)
- **Time remaining**: 50 × 3s = 150s = "2m 30s left"

## Testing
Run the test scene: `test/test_time_remaining.tscn`

The test validates:
1. Time formatting for various durations
2. Time calculation with no speed modifier
3. Time calculation with speed modifiers
4. Handling of zero items
5. Methods without consumed items
6. Multiple consumed items (bottleneck detection)

## Files Changed
1. `resources/skills/training_method_data.gd` - Core calculation logic
2. `scripts/main.gd` - UI display updates
3. `test/test_time_remaining.gd` - Comprehensive tests
4. `test/test_time_remaining.tscn` - Test scene
