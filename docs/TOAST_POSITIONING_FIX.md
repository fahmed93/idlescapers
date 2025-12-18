# Toast Notification Positioning Fix

## Problem
The toast popup notifications had two issues:
1. They were positioned too far from the bottom of the screen
2. New toasts appeared below existing ones instead of above

## Solution

### 1. Moved Toast Container Closer to Bottom
**Before:**
- `offset_top = -300` (300px from bottom)
- `offset_bottom = -60` (60px padding)

**After:**
- `offset_top = -400` (400px from bottom - more space)
- `offset_bottom = -20` (20px padding - closer to bottom)

**Visual Impact:**
- On a 1280px tall screen (mobile portrait), toasts now appear at:
  - Bottom edge: 20px from bottom (was 60px)
  - Top of container: 420px from bottom (was 360px)
  - This provides more vertical space for multiple toasts while being closer to the bottom

### 2. New Toasts Appear Above Older Ones
**Before:**
- Toasts were added to the end of VBoxContainer using `add_child()`
- New toasts appeared **below** older ones
- Cleanup removed from index 0 (top)

**After:**
- Toasts are added to the end but immediately moved to index 0 using `move_child(toast, 0)`
- New toasts appear **above** older ones
- Cleanup removes from index `count - 1` (bottom)

**Visual Impact:**
```
Before (new below):        After (new above):
┌─────────────┐           ┌─────────────┐
│ Old Toast 1 │           │ New Toast 3 │ ← newest
├─────────────┤           ├─────────────┤
│ Old Toast 2 │           │ Old Toast 2 │
├─────────────┤           ├─────────────┤
│ New Toast 3 │ ← newest  │ Old Toast 1 │
└─────────────┘           └─────────────┘
     ↑ bottom                  ↑ bottom
```

### 3. Performance Considerations
- Maximum 3 toasts are kept at any time
- `move_child(toast, 0)` is O(n) but with max 3 children, impact is negligible
- Cleanup uses direct `get_child_count()` calls for simplicity and correctness

## Code Changes
**File:** `scripts/main.gd`

### _create_toast_container()
```gdscript
# Position at bottom center of screen, closer to the bottom
toast_container.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
toast_container.offset_top = -400  # Above the bottom
toast_container.offset_bottom = -20  # Closer padding from the bottom
```

### _show_toast_notification()
```gdscript
# Move the new toast to the top (index 0) so it appears above older toasts
# Note: With max 3 toasts, performance impact is negligible
toast_container.move_child(toast, 0)

# Remove old toasts if there are too many (keep max 3)
# Remove from the end since new toasts are now at the beginning
while toast_container.get_child_count() > 3:
    var oldest_toast := toast_container.get_child(toast_container.get_child_count() - 1)
    toast_container.remove_child(oldest_toast)
    oldest_toast.queue_free()
```

## Testing
- Existing toast notification unit tests continue to pass
- Visual verification through deployed build
- No breaking changes to toast behavior or API

## Expected User Experience
When completing actions in the game:
1. Toast notifications appear near the bottom of the screen (20px from edge)
2. Each new notification appears **above** the previous one
3. Up to 3 notifications are shown at once
4. Older notifications fade out after 3 seconds and are removed
