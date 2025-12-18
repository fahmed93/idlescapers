# Toast Notification Positioning Fix

## Problem
The toast popup notifications had issues:
1. They were positioned too far from the bottom of the screen
2. New toasts appeared below existing ones instead of above
3. Toasts were forcibly removed when limit was hit, preventing natural fade-out

## Solution

### 1. Moved Toast Container Closer to Bottom
**Before:**
- `offset_top = -300` (300px from bottom)
- `offset_bottom = -60` (60px padding)

**After:**
- `offset_top = -150` (150px from bottom - optimized space)
- `offset_bottom = -20` (20px padding - closer to bottom)

**Visual Impact:**
- On a 1280px tall screen (mobile portrait), toasts now appear at:
  - Bottom edge: 20px from bottom (was 60px)
  - Top of container: 170px from bottom (was 360px)
  - This provides adequate vertical space while being closer to the bottom

### 2. New Toasts Appear Above Older Ones
**Before:**
- Toasts were added to the end of VBoxContainer using `add_child()`
- New toasts appeared **below** older ones
- Cleanup removed from index 0 (top)

**After:**
- Toasts are added to the end but immediately moved to index 0 using `move_child(toast, 0)`
- New toasts appear **above** older ones
- Toasts naturally fade out and are removed via their own lifecycle

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

### 3. Natural Toast Lifecycle
**Before:**
- Forced limit of max 3 toasts
- When 4th toast added, oldest was immediately removed via `queue_free()`
- This interrupted the natural fade-out animation

**After:**
- No forced limit - toasts manage their own lifecycle
- Each toast displays for 3 seconds, then fades out over 0.5 seconds
- When a toast completes its fade and calls `queue_free()`, toasts above it naturally move down
- Matches the requirement: "toasts only move down when the older toast disappears"

**Visual Flow:**
```
Time 0s: Toast 1 appears at top
Time 1s: Toast 2 appears at top, Toast 1 moves down
Time 2s: Toast 3 appears at top, Toast 2 moves down, Toast 1 moves down more
Time 3s: Toast 1 starts fading (still visible)
Time 3.5s: Toast 1 disappears, Toast 2 and 3 move down naturally
```

### 4. Performance Considerations
- Toasts are lightweight (just labels in a PanelContainer)
- Each toast automatically removes itself after 3.5s total (3s display + 0.5s fade)
- Maximum theoretical toasts on screen: ~5-6 with rapid action completion
- `move_child(toast, 0)` is O(n) but with typical 2-3 children, impact is negligible
- No manual cleanup needed - self-managing lifecycle

## Code Changes
**File:** `scripts/main.gd`

### _create_toast_container()
```gdscript
# Position at bottom center of screen, closer to the bottom
toast_container.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
toast_container.offset_top = -150  # Right above the bottom
toast_container.offset_bottom = -20  # Small padding from the bottom
```

### _show_toast_notification()
```gdscript
# Move the new toast to the top (index 0) so it appears above older toasts
# Toasts automatically manage their own lifecycle (fade out after 3s + 0.5s fade)
# When a toast is removed, toasts above it naturally move down to fill the space
toast_container.move_child(toast, 0)
```

**Note:** Removed the `while` loop that enforced max 3 toasts to allow natural lifecycle management.

## Testing
- Existing toast notification unit tests continue to pass
- Visual verification through deployed build
- Test rapid action completion to verify multiple toasts display correctly
- Verify toasts only move down when older toasts complete their fade-out

## Expected User Experience
When completing actions in the game:
1. Toast notifications appear near the bottom of the screen (20px from edge)
2. Each new notification appears **above** the previous one
3. Multiple notifications can stack naturally (typically 2-4 visible)
4. Older notifications fade out after 3 seconds and smoothly disappear
5. When a toast disappears, toasts above it smoothly move down to fill the space
