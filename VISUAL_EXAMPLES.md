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
