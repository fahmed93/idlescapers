# Toast Notification System

## Overview
The toast notification system displays small, temporary popups when training actions are completed. These notifications appear at the top center of the screen and automatically fade out after a few seconds.

## Implementation Details

### Files Created
1. **scripts/toast_notification.gd** - Toast notification script with auto-dismiss logic
2. **scenes/toast_notification.tscn** - Toast notification UI scene
3. **test/test_toast_notification.gd** - Unit tests for the toast system

### Files Modified
1. **scripts/main.gd** - Added toast container and signal handling

### How It Works

#### Toast Display
When a training action completes, the `action_completed` signal is emitted from `GameManager`. The `main.gd` script handles this signal and:

1. Retrieves the training method to get XP and item information
2. Builds a dictionary of items gained (only if action was successful)
3. Creates a new toast notification instance
4. Displays the toast with:
   - Skill name (colored with the skill's color)
   - XP gained (always shown)
   - Items produced (only shown on successful actions)

#### Auto-Dismiss
Each toast notification:
- Displays for 3 seconds (configurable via `DISPLAY_DURATION`)
- Fades out over 0.5 seconds (configurable via `FADE_DURATION`)
- Automatically cleans itself up from memory using `queue_free()`

#### Toast Stacking
- Multiple toasts can be displayed simultaneously
- Maximum of 3 toasts shown at once
- Oldest toasts are removed when the limit is exceeded
- Toasts stack vertically from top to bottom

### Visual Design
- **Position**: Top center of screen, below the menu button
- **Size**: Minimum 200px wide, auto-height based on content
- **Colors**:
  - Skill name: Uses the skill's defined color
  - XP label: Green (#80ff80)
  - Items label: Light blue (#99ccee)
- **Spacing**: 4px between labels within the toast

### Example Toast Content

**Successful Fishing Action:**
```
Fishing
+10.0 XP
+1 Raw Shrimp
```

**Failed Cooking Action (50% success rate):**
```
Cooking
+30.0 XP
(no items shown)
```

**Multiple Items Gained:**
```
Smithing
+50.0 XP
+1 Iron Platebody, +5 Smithing XP Token
```

## Testing

The test file `test/test_toast_notification.gd` verifies:
1. ✓ Toast starts invisible
2. ✓ Toast becomes visible after showing
3. ✓ All required labels exist
4. ✓ Labels display correct content
5. ✓ Items label is hidden when no items are gained
6. ✓ Multiple items can be displayed

## Future Enhancements

Potential improvements for future iterations:
- Include bonus items in the toast (requires tracking which bonus items were actually awarded)
- Add icons for items
- Sound effects when toast appears
- Different toast colors for different event types (level up, rare drop, etc.)
- Click-to-dismiss functionality
- Toast history log
