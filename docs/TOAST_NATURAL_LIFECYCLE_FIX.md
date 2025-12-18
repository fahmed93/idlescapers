# Toast Natural Lifecycle Fix - Summary

## Problem Statement
"new toasts should appear above existing toast and only move down when the older toast disappears"

## Issue Identified
The previous implementation had a forced limit that immediately removed the oldest toast when a 4th toast was added, even if that toast hadn't completed its natural fade-out animation. This violated the requirement that toasts should "only move down when the older toast disappears" because we were forcing toasts to disappear prematurely.

## Solution Implemented

### Changes Made

#### 1. Removed Forced Toast Limit (`scripts/main.gd`)
**Before:**
```gdscript
# Remove old toasts if there are too many (keep max 3)
while toast_container.get_child_count() > 3:
    var oldest_toast := toast_container.get_child(toast_container.get_child_count() - 1)
    toast_container.remove_child(oldest_toast)
    oldest_toast.queue_free()
```

**After:**
```gdscript
# Toasts automatically manage their own lifecycle (fade out after 3s + 0.5s fade)
# When a toast is removed, toasts above it naturally move down to fill the space
# No forced removal - toasts complete their natural lifecycle
```

#### 2. Updated Test File (`test/test_toast_positioning.gd`)
Removed the same forced limit code from the test file to match the implementation.

#### 3. Created New Test (`test/test_toast_natural_lifecycle.gd`)
Created a comprehensive test that:
- Creates 5 toasts rapidly (0.5s apart)
- Monitors toast count over 10 seconds
- Verifies toasts manage their own lifecycle naturally
- Confirms toasts move down only when older ones complete fade-out

#### 4. Updated Documentation (`docs/TOAST_POSITIONING_FIX.md`)
Documented the natural lifecycle approach and removed references to the forced 3-toast limit.

## How It Works Now

### Toast Lifecycle
1. **Creation**: New toast is instantiated and added to `toast_container`
2. **Positioning**: Immediately moved to index 0 (top of container)
3. **Display**: Visible for 3 seconds
4. **Fade**: Fades out over 0.5 seconds (opacity 1.0 → 0.0)
5. **Removal**: Calls `queue_free()` after fade completes
6. **Natural Flow**: When removed, toasts above it automatically move down (VBoxContainer behavior)

### Visual Behavior
```
Time 0.0s: [Toast 1]
Time 0.5s: [Toast 2] [Toast 1]
Time 1.0s: [Toast 3] [Toast 2] [Toast 1]
Time 1.5s: [Toast 4] [Toast 3] [Toast 2] [Toast 1]
Time 3.5s: [Toast 4] [Toast 3] [Toast 2]  ← Toast 1 faded out naturally
Time 4.0s: [Toast 5] [Toast 4] [Toast 3] [Toast 2]
Time 4.0s: [Toast 5] [Toast 4] [Toast 3]  ← Toast 2 faded out naturally
           ↓ Toasts move down naturally as older ones disappear
```

## Benefits

1. **Matches Requirements**: Toasts only move down when older toasts naturally disappear
2. **Smooth Animation**: No interrupted fade-outs
3. **Better UX**: Visual continuity - users can see full lifecycle of each notification
4. **Self-Managing**: No manual cleanup needed - each toast manages its own lifecycle
5. **Flexible**: Can handle bursts of rapid actions without losing notifications

## Performance Considerations

- Each toast is lightweight (labels in a PanelContainer)
- Auto-cleanup after 3.5 seconds prevents accumulation
- Maximum realistic toasts on screen: 5-7 with very rapid actions
- `move_child()` is O(n) but with typical 2-4 children, negligible impact

## Testing

- Created `test_toast_natural_lifecycle.gd` for automated verification
- Existing tests (`test_toast_notification.gd`, `test_toast_positioning.gd`) remain compatible
- CI will verify no regressions

## Expected User Experience

When completing actions rapidly:
1. Each new notification appears above previous ones
2. Notifications display for full 3 seconds
3. Notifications smoothly fade out
4. As older notifications disappear, newer ones smoothly move down
5. No abrupt removals or interrupted animations
