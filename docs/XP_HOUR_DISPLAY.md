# XP/Hour Display Feature

## Overview
Added estimated XP per hour display to training method stats to help players make informed decisions about which training methods are most efficient.

## Implementation

### Changes Made
Modified `resources/skills/training_method_data.gd`:
- Updated `get_stats_text()` function to include XP/hour calculation
- Uses existing `get_xp_per_hour()` function which accounts for speed modifiers from upgrades
- Displays XP/hour rounded to nearest whole number

### Display Format

**Before:**
```
Level 1 | 10.0 XP | 3.0s
```

**After:**
```
Level 1 | 10.0 XP | 3.0s | 12000 XP/hr
```

### Calculation
XP/hour is calculated using the formula:
```
XP/hr = (xp_per_action * success_rate * 3600) / effective_action_time
```

Where:
- `xp_per_action`: Base XP awarded per action
- `success_rate`: Probability of success (usually 1.0)
- `effective_action_time`: Action time divided by (1 + speed_modifier)
- `3600`: Seconds per hour

### Examples

#### Basic Training (No Upgrades)
**Shrimp (Fishing Level 1)**
- XP per action: 10.0
- Action time: 3.0s
- XP/hour: 12,000

**Salmon (Fishing Level 30)**
- XP per action: 70.0
- Action time: 5.0s
- XP/hour: 50,400

#### With Speed Upgrades
**Shrimp with +10% Speed Bonus**
- XP per action: 10.0
- Base action time: 3.0s
- Effective action time: 2.73s (3.0 / 1.1)
- XP/hour: 13,200

**Shrimp with +30% Speed Bonus**
- XP per action: 10.0
- Base action time: 3.0s
- Effective action time: 2.31s (3.0 / 1.3)
- XP/hour: 15,600

### Benefits
1. **Informed Decision Making**: Players can easily compare training methods
2. **Upgrade Value**: Shows the impact of speed upgrades on XP rates
3. **Progression Planning**: Helps players optimize their training strategies
4. **At-a-Glance Efficiency**: No mental math required to determine best methods

### Location in UI
The XP/hour is displayed in the training method panel, which appears when:
1. User selects a skill from the sidebar
2. Training methods are listed in the main content area
3. Each method shows: Level requirement, XP per action, Action time, and XP/hour

### Technical Notes
- The calculation accounts for:
  - Speed modifiers from purchased upgrades
  - Success rate of the training method
  - Effective action time (base time / (1 + speed modifier))
- Format: Whole number (no decimals) for readability
- Updates automatically when upgrades are purchased
