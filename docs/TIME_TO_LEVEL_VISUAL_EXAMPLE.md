# Visual Example: Time to Level Indicator

## Training Panel Layout

When a player is actively training, the training panel displays:

```
┌─────────────────────────────────────┐
│     Training: Cook Shrimp           │  ← Training Label (shows method name)
├─────────────────────────────────────┤
│ ████████████████░░░░░░░░░░░░░░░░░░  │  ← Progress Bar (fills as action progresses)
├─────────────────────────────────────┤
│           1.2s / 2.0s               │  ← Training Time Label (elapsed/total)
├─────────────────────────────────────┤
│      Time to level: 5m 30s          │  ← **NEW** Time to Level Label
├─────────────────────────────────────┤
│        [ Stop Training ]            │  ← Stop Button
└─────────────────────────────────────┘
```

## Example Scenarios

### Scenario 1: Low Level Training
**Context**: Player is fishing shrimp at level 1
- Training: Catch Shrimp
- Progress: 45% complete
- Current action: 1.4s / 3.0s
- **Time to level: 24s** ← Shows player will level up very soon!

### Scenario 2: Mid-Level Training  
**Context**: Player is cooking salmon at level 35
- Training: Cook Salmon
- Progress: 80% complete
- Current action: 1.6s / 2.0s
- **Time to level: 15m 42s** ← Shows approximate time to next level

### Scenario 3: High Level Training
**Context**: Player is cutting magic trees at level 85
- Training: Magic Tree
- Progress: 12% complete
- Current action: 1.0s / 8.0s
- **Time to level: 3h 25m** ← Shows it will take hours to level up

### Scenario 4: Training with Items Running Out
**Context**: Player is cooking with limited raw fish
- Training: Cook Lobster (2m 15s left)
- Progress: 60% complete
- Current action: 3.0s / 5.0s
- **Time to level: 45m 30s** ← Shows time to level exceeds item supply

### Scenario 5: Max Level
**Context**: Player has reached level 99
- Training: Catch Anglerfish
- Progress: 33% complete
- Current action: 2.3s / 7.0s
- **Time to level: MAX** ← Indicates player is at maximum level

### Scenario 6: Not Training
**Context**: Player stopped training or hasn't started
- Panel is hidden or minimized
- When visible: **Time to level: --**

## Color Coding (Future Enhancement)
The time to level label could potentially use color coding:
- **Green** (< 1 minute): Very close to leveling up
- **Yellow** (1-10 minutes): Should level up soon
- **Orange** (10-60 minutes): Medium wait time
- **White** (> 1 hour): Long training session ahead

## Integration with Other Indicators

The time to level indicator complements existing features:

1. **XP Progress Bar** (in skill header): Shows visual progress to next level
2. **XP Label** (in skill header): Shows exact XP values (e.g., "523 / 611 XP")
3. **Time Remaining** (in training label): Shows time until items run out
4. **XP/Hour** (in action list): Shows rate of XP gain per training method

Together, these features give players a complete picture of their training progress:
- How much XP they need
- How fast they're gaining it
- How long until they level up
- When they'll run out of resources

## Mobile-Friendly Design

The label uses:
- Font size: 12 (readable on mobile)
- Centered horizontal alignment
- Consistent styling with other labels
- Clear, concise text format

## Benefits to Players

1. **Time Planning**: Know how long to leave the game idle
2. **Resource Management**: Compare time to level vs. time until items run out
3. **Method Comparison**: See which training methods level faster
4. **Upgrade Value**: Immediately see how speed upgrades affect leveling time
5. **Goal Setting**: Plan gaming sessions around level milestones
