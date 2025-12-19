# Time Remaining Display - Visual Examples

## Feature Overview
This feature displays how long a player can continue training before running out of consumable items.

## Where It Appears

### 1. Action List (Training Method Selection)
When viewing a skill's training methods, each action that consumes items shows:
- **Available count**: Shows how many of each item you have
- **Time remaining**: Color-coded display of time until items run out

Example display for "Cook Shrimp":
```
Cook Shrimp
Level 1 | 30.0 XP | 2.0s
Uses: Raw Shrimp x1 (50)  ← Shows you have 50 raw shrimp
1m 40s left               ← Yellow text, shows time remaining
[Train]
```

### 2. Training Progress Panel (During Active Training)
When actively training, the training label shows time remaining:
```
Training: Cook Shrimp (1m 20s left)
[Progress Bar: ████████░░░░░░░░]
[Stop]
```

## Color Coding
The time remaining text uses different colors to indicate urgency:
- **Red** (0s): Out of items - training will stop
- **Yellow** (<60s): Running low - less than 1 minute left
- **Yellowish** (60s+): Plenty of time - more than 1 minute

## Real-Time Updates
The display updates automatically:
- When items are consumed during training
- When items are added to inventory
- When items are removed (sold/used)
- When switching between training methods

## Format Examples
- `30s left` - Less than 1 minute
- `5m 30s left` - Between 1 minute and 1 hour
- `2h 15m left` - More than 1 hour

## Example Scenarios

### Scenario 1: Cooking Fish
- You have 100 Raw Shrimp
- Cook Shrimp takes 2 seconds per action
- Consumes 1 Raw Shrimp per action
- **Display**: "3m 20s left" (100 × 2s = 200s)

### Scenario 2: With Speed Upgrades
- You have 100 Raw Shrimp
- Cook Shrimp takes 2 seconds per action
- You have +50% speed upgrade
- Modified time: 2s / 1.5 = 1.33s per action
- **Display**: "2m 13s left" (100 × 1.33s ≈ 133s)

### Scenario 3: Multiple Ingredients (Herblore)
- Making Attack Potions requires:
  - 1 Guam Leaf (50 in inventory)
  - 1 Eye of Newt (100 in inventory)
- Action takes 3 seconds
- **Bottleneck**: Guam Leaf (limiting factor)
- **Display**: "2m 30s left" (50 × 3s = 150s)

### Scenario 4: No Consumables (Fishing)
- Fishing doesn't consume items
- **Display**: No time remaining shown (only for methods that consume items)

## Benefits
1. **Resource Planning**: Know when you need to restock
2. **Efficiency**: Plan when to switch activities
3. **Awareness**: Avoid running out unexpectedly during AFK training
4. **Optimization**: Compare different training methods by sustainability

---

# Time to Level Display - Visual Examples

## Feature Overview
This feature displays the estimated time required to reach the next level while actively training a skill.

## Where It Appears

### Training Progress Panel (During Active Training)
When actively training any skill, the training panel shows:
- Current training method
- Progress bar for current action
- Time elapsed/total for current action
- **Time to next level** (new feature)
- Stop button

Example display:
```
Training: Shrimp
[Progress Bar: ████████░░░░░░░░] 75%
1.5s / 2.0s
Time to level 2: 18s          ← Light blue text
[Stop Training]
```

At higher levels:
```
Training: Lobster
[Progress Bar: ████████░░░░░░░░] 60%
1.8s / 3.0s
Time to level 51: 2h 15m      ← Light blue text
[Stop Training]
```

At max level:
```
Training: Anglerfish
[Progress Bar: ████████░░░░░░░░] 80%
2.1s / 2.5s
Max level reached!            ← Light blue text
[Stop Training]
```

## Display Format
The time is formatted based on duration:
- **< 1 minute**: "18s"
- **1 min - 1 hour**: "5m 30s" or "5m"
- **1 hour - 24 hours**: "2h 15m" or "2h"
- **>= 24 hours**: "3d 5h" or "3d"

## Calculation Details
The time to level is calculated using:
- **Current XP**: Player's current experience in the skill
- **Next level XP**: Experience required for the next level
- **XP per action**: Experience gained from current training method
- **Effective action time**: Base action time adjusted for speed bonuses

Formula: `ceil(xp_needed / xp_per_action) * effective_action_time`

## Example Scenarios

### Scenario 1: Early Level (1 → 2)
- Current XP: 0
- XP needed for level 2: 83
- Training: Catch Shrimp (10 XP, 2.0s)
- Actions needed: ceil(83 / 10) = 9 actions
- **Display**: "Time to level 2: 18s" (9 × 2.0s)

### Scenario 2: With Speed Upgrades
- Current XP: 0
- XP needed for level 2: 83
- Training: Catch Shrimp (10 XP, 2.0s)
- Speed bonus: +50% (from upgrades)
- Effective time: 2.0s / 1.5 = 1.33s
- Actions needed: 9 actions
- **Display**: "Time to level 2: 12s" (9 × 1.33s)

### Scenario 3: Mid-Level (50 → 51)
- Current XP: 101,333 (level 50 minimum)
- XP needed for level 51: 102,851 - 101,333 = 1,518 XP
- Training: Catch Lobster (90 XP, 3.0s)
- Actions needed: ceil(1,518 / 90) = 17 actions
- **Display**: "Time to level 51: 51s" (17 × 3.0s)

### Scenario 4: High Level (98 → 99)
- Current XP: ~12.9M
- XP needed for level 99: ~120,000 XP
- Training: Catch Anglerfish (120 XP, 2.5s)
- Actions needed: ceil(120,000 / 120) = 1,000 actions
- Time: 1,000 × 2.5s = 2,500s
- **Display**: "Time to level 99: 41m 40s"

## Real-Time Updates
The display updates automatically:
- Every frame while actively training
- When XP is gained (recalculates remaining XP)
- When speed upgrades are purchased
- When switching training methods

## Benefits
1. **Goal Setting**: Know exactly when you'll reach your next level
2. **Efficiency Planning**: Decide if it's worth finishing the level now or later
3. **Motivation**: See tangible progress toward your goal
4. **Resource Decisions**: Compare time to level vs time until items run out
5. **AFK Planning**: Know if you can reach the next level before stepping away

## Color Coding
The time to level text uses a light blue color (0.6, 0.8, 1.0) to distinguish it from other time displays and match the progression/leveling theme.

