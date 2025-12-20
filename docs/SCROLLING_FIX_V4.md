# Mobile Scrolling Fix V4

## Problem Statement
After implementing V3 of the mobile scrolling fix (commit c38a12e), a critical bug was introduced where buttons could no longer be clicked at all. The issue occurred because input events were being marked as "handled" immediately when the user pressed down, preventing buttons from ever receiving the press event.

## Root Cause Analysis

### The Bug in V3
In V3, the code was calling `get_viewport().set_input_as_handled()` immediately on press:

```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            if _is_position_in_bounds(event.position):
                _is_touch_in_bounds = true
                var local_pos := event.position - global_position
                _start_drag(local_pos)
                # ❌ BUG: This prevented buttons from receiving ANY events!
                get_viewport().set_input_as_handled()
```

**Why This Broke Buttons:**
1. User touches a button
2. `_input()` runs BEFORE the button sees the event (by design)
3. Event is marked as "handled" immediately
4. Button never receives the press event
5. Button remains inactive, can't be clicked

### The Workaround in V3 (Also Flawed)
V3 tried to work around this by manually emitting button signals:

```gdscript
func _handle_release(global_pos: Vector2) -> void:
    var was_scrolling := _is_scrolling
    _end_drag()
    
    # If we didn't actually scroll, trigger a button click
    if not was_scrolling:
        var button := _find_button_at_position(global_pos)
        if button:
            button.pressed.emit()  # ❌ Bypasses button's internal logic
```

**Problems with This Approach:**
- Doesn't respect button's disabled state
- Doesn't show proper visual feedback (press animation)
- Doesn't handle button's internal "press and drag away to cancel" logic
- Circumvents Godot's built-in button behavior

## Solution Implemented in V4

### Core Principle
**Let buttons handle their own events naturally, only intercept when we determine scrolling is happening.**

### Key Changes

#### 1. Remove Premature `set_input_as_handled()`
Don't mark events as handled on the initial press. Let the button receive it:

```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            if _is_position_in_bounds(event.position):
                _is_touch_in_bounds = true
                var local_pos := event.position - global_position
                _start_drag(local_pos)
                # ✓ Don't mark as handled yet - allow buttons to receive the press
                # We'll mark it as handled only if dragging exceeds threshold
```

#### 2. Mark Events as Handled Only When Scrolling
Only when drag distance exceeds the threshold do we mark events as handled:

```gdscript
# Process the drag
var drag_distance := _drag_start_pos.distance_to(current_pos)

# If we've moved past the threshold, start scrolling
if drag_distance > scroll_threshold or _is_scrolling:
    if not _is_scrolling:
        _is_scrolling = true
        # Cancel any buttons that might be in pressed state
        _cancel_button_press(global_pos)
    
    # ... perform scrolling ...
    
    # ✓ NOW mark as handled to prevent button from processing drag
    get_viewport().set_input_as_handled()
```

#### 3. Cancel Button Press When Scrolling Starts
When we detect scrolling, cancel any button that might be in pressed state:

```gdscript
func _cancel_button_press(global_pos: Vector2) -> void:
    var button := _find_button_at_position(global_pos)
    if button and button.button_pressed:
        button.set_pressed_no_signal(false)
```

This ensures:
- Button exits its pressed visual state
- Button won't trigger on release
- User sees clear feedback that scrolling has started

#### 4. Remove Manual Button Triggering
Since buttons now receive events naturally, we don't need to manually emit signals:

```gdscript
func _handle_release(global_pos: Vector2) -> void:
    _end_drag()
    # That's it! No manual button triggering needed
```

## How It Works Now

### Scenario 1: Quick Tap (Button Click)
```
1. User touches button
   ↓
2. Button receives press event → enters pressed state (visual feedback)
   ScrollContainer also tracks position but doesn't interfere
   ↓
3. User releases quickly (< 10px movement)
   ↓
4. Drag distance < threshold, so _is_scrolling = false
   ScrollContainer never marks events as handled
   ↓
5. Button receives release event → triggers normally
```

### Scenario 2: Drag to Scroll
```
1. User touches button
   ↓
2. Button receives press event → enters pressed state
   ScrollContainer tracks position
   ↓
3. User drags > 10px
   ↓
4. ScrollContainer detects: drag_distance > threshold
   ↓
5. ScrollContainer:
   - Sets _is_scrolling = true
   - Calls _cancel_button_press() to reset button state
   - Marks drag events as handled
   - Scrolls the content
   ↓
6. Button is no longer pressed, won't trigger on release
   User sees content scrolling (clear feedback)
```

## Comparison: V3 vs V4

| Aspect | V3 (Broken) | V4 (Fixed) |
|--------|-------------|------------|
| **Initial press handling** | Marked as handled immediately | NOT marked as handled |
| **Button receives press?** | ❌ No (button broken) | ✓ Yes (button works) |
| **Button visual feedback** | ❌ None | ✓ Natural Godot behavior |
| **Tap detection** | Manual signal emission | ✓ Natural button behavior |
| **Scroll detection** | When drag > threshold | ✓ When drag > threshold |
| **Button state on scroll** | Manually emit signal if not scrolling | ✓ Cancel pressed state |
| **Respects disabled buttons** | ❌ No | ✓ Yes |
| **Uses Godot's built-in logic** | ❌ Bypasses it | ✓ Leverages it |

## Testing

### Manual Testing Checklist
Test these scenarios to verify the fix:

1. ✓ **Quick Tap on Button**
   - Touch a button and release quickly
   - Expected: Button should trigger normally
   - Visual: Button should show press animation

2. ✓ **Drag on Button to Scroll**
   - Press on a button
   - Drag > 10 pixels
   - Expected: Content should scroll smoothly
   - Visual: Button press animation should cancel when scrolling starts
   - Button should NOT trigger on release

3. ✓ **Drag on Empty Space**
   - Press on empty space in scroll area
   - Drag in any direction
   - Expected: Should scroll smoothly

4. ✓ **Disabled Button**
   - Add a disabled button to test
   - Try to click it
   - Expected: Should remain disabled (not trigger)

5. ✓ **Press and Drag Away from Button**
   - Press on a button
   - Drag away from button (but < 10px from start)
   - Release
   - Expected: Button should NOT trigger (standard button behavior)

### Automated Tests
Existing tests should continue to pass:
```bash
./run_tests.sh
```

Tests that verify mobile scroll functionality:
- `test/test_sidebar_scrolling.gd`
- `test/test_main_screen_scroll.gd`
- `test/test_mobile_scroll_button_fix.gd`

## Files Modified

### scripts/mobile_scroll_container.gd
Changes made:
1. Removed `get_viewport().set_input_as_handled()` from press handlers (lines 97, 111)
2. Added `_cancel_button_press()` helper function
3. Call `_cancel_button_press()` when scrolling starts (line 143)
4. Simplified `_handle_release()` (removed manual button triggering)
5. Updated comments to reflect new behavior

### No Other Files Changed
The fix is entirely contained in the mobile scroll container script. No changes needed to:
- Scene files
- Test files
- Other scripts

## Technical Notes

### Why This Approach is Correct
This follows Godot's recommended pattern for custom input handling:

1. **Use `_input()` for early interception**: Allows us to see events before child controls
2. **Don't interfere unless necessary**: Let normal event flow happen for simple interactions
3. **Mark as handled only when taking action**: Only prevent child controls from processing when we're actually scrolling
4. **Respect built-in behaviors**: Let buttons use their own press/release logic

### Performance
No performance impact:
- Same number of `_input()` calls as V3
- One additional button lookup when scrolling starts (negligible)
- Button click path is actually faster (no manual button finding on release)

### Edge Cases Handled
- ✓ Buttons in different visual states (normal, hover, pressed, disabled)
- ✓ Multiple scroll containers on screen
- ✓ Fast flick gestures
- ✓ Touch starts on button, drags to different button
- ✓ Touch starts outside bounds, drags inside
- ✓ Horizontal and vertical scrolling

## See Also
- [SCROLLING_FIX_V3.md](./SCROLLING_FIX_V3.md) - Previous (broken) implementation
- [SCROLLING_FIX_V2.md](./SCROLLING_FIX_V2.md) - Earlier implementation using `_gui_input()`
- [MOBILE_SCROLL_IMPLEMENTATION.md](./MOBILE_SCROLL_IMPLEMENTATION.md) - Original V1 implementation
- Godot Input Handling: https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
