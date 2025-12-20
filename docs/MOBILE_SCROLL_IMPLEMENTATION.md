# Mobile Scroll Implementation

## Overview
This document describes the implementation of drag-to-scroll functionality that works even when touch starts on buttons. The implementation handles event interception, scroll detection, and manual button triggering.

## Problem Statement
Mobile scrolling did not work when the user started their touch/drag on a button or interactive element. This occurred because:
1. Buttons consume input events through their internal `_gui_input()` handlers
2. Once a button receives a press event, it captures input focus
3. Subsequent drag events are consumed by the button, preventing scrolling

This created a poor mobile experience where users had to carefully avoid buttons when scrolling.

## Solution Architecture

### Input Event Processing Order
Godot processes input events in this order:
1. **`_input()`** - Called on all nodes from root down (can mark events as handled)
2. **`_gui_input()`** - Called on Control nodes under the touch/mouse point
3. **`_unhandled_input()`** - Called if event wasn't handled

Our solution leverages `_input()` to intercept and mark events as handled **before** buttons can process them.

### Key Implementation Details

#### 1. Immediate Event Consumption
When a touch/click is detected within the ScrollContainer:
- Immediately call `get_viewport().set_input_as_handled()` (lines 97, 111 in `mobile_scroll_container.gd`)
- This prevents buttons from receiving the press event
- Buttons never enter their "pressed" state, allowing scrolling to work

#### 2. Tap vs Scroll Detection
Uses a configurable threshold (default: **10 pixels**) to distinguish:
- **Tap**: Movement < 10px → Find and trigger button click manually
- **Scroll**: Movement ≥ 10px → Perform scrolling, ignore button

#### 3. Manual Button Triggering
When a tap is detected (release without scrolling):
1. Find the button at the release position using global coordinates
2. Manually emit its `pressed` signal
3. Button's connected functions execute normally
4. User experience is identical to a normal tap

#### 4. Global Position-Based Button Finding
Uses global coordinates to handle buttons in any layout:
- Works with `VBoxContainer`, `GridContainer`, `HBoxContainer`
- Handles nested containers of any depth
- Reliable regardless of how Godot's layout engine positions buttons

## Changes Made

### 1. Core Implementation (scripts/mobile_scroll_container.gd)
Updated to:
- Mark events as handled immediately on press (prevents button capture)
- Add `_handle_release()` method to distinguish taps from scrolls
- Add `_find_button_at_position()` to locate buttons using global positions
- Add `_find_button_recursive()` to search node tree for buttons
- Changed threshold from 5px to 10px for better tap/scroll balance

### 2. Scene File Updates (scenes/main.tscn)
Mobile scroll script applied to static ScrollContainer nodes:
- **Action List ScrollContainer**: `MainContent/ActionList/ScrollContainer`
- **Inventory Panel ScrollContainer**: `MainContent/InventoryPanel/VBoxContainer/ScrollContainer`
- **Sidebar ScrollContainer**: `SkillSidebar/ScrollContainer`

### 3. Script Updates (scripts/main.gd)
Applied the script to dynamically created ScrollContainers:
1. Inventory tab bar scroll (horizontal)
2. Inventory items list scroll
3. Equipment slots scroll
4. Upgrades list scroll
5. Skill summary scroll
6. Settings scroll

### 4. Test Coverage
- `test/test_main_screen_scroll.gd` - Verifies all ScrollContainers have mobile scroll script
- `test/test_sidebar_scrolling.gd` - Verifies sidebar scrolling
- `test/test_mobile_scroll_v3.gd` - Verifies V3 implementation with _input() method
- `test/test_mobile_scroll_button_fix.gd` - **NEW**: Verifies button fix implementation

## How It Works

The `mobile_scroll_container.gd` script:
1. Intercepts all touch/mouse input events using `_input()` method
2. **Immediately marks press events as handled** to prevent button capture
3. Tracks when a touch/drag starts within the ScrollContainer bounds
4. Uses a 10-pixel threshold to differentiate between taps and drags
5. If threshold exceeded: Updates scroll position based on drag delta
6. If threshold not exceeded: Finds button at release point and emits its `pressed` signal

### Key Features
- **Immediate event consumption**: Prevents buttons from capturing input
- **Manual button triggering**: Taps still work through manual signal emission
- **Threshold-based**: 10-pixel movement threshold prevents accidental scrolling
- **Global position logic**: Works with any container layout
- **Mouse support**: Also works with mouse for editor testing
- **Predictable behavior**: Disables `follow_focus` for consistent mobile UX

### Configuration
```gdscript
@export var scroll_threshold: float = 10.0  # Adjustable per instance
```

Adjust per ScrollContainer instance if needed:
- **Lower values** (e.g., 5px): More sensitive scrolling
- **Higher values** (e.g., 20px): Easier button taps
- **Default (10px)**: Good balance for most use cases

## Testing

### Automated Tests
Run the test suite to verify all ScrollContainers have the mobile scroll script:
```bash
./run_tests.sh
```

Specific tests:
```bash
# Main screen ScrollContainers
godot --headless --path . res://test/test_main_screen_scroll.tscn

# Sidebar ScrollContainer
godot --headless --path . res://test/test_sidebar_scrolling.tscn

# V3 implementation verification
godot --headless --path . res://test/test_mobile_scroll_v3.tscn

# Button fix verification
godot --headless --path . res://test/test_mobile_scroll_button_fix.tscn
```

### Manual Testing Checklist
1. **Tap on button**: Button should activate (no scroll)
2. **Small drag on button (<10px)**: Button should activate
3. **Large drag on button (>10px)**: Should scroll, button should NOT activate
4. **Drag on empty space**: Should scroll normally
5. **Fast flick gesture**: Should scroll smoothly
6. **Rapid tap-scroll-tap**: Should handle state transitions correctly

Test on different screens:
- Skills view (action list with Train buttons)
- Inventory view (item grid)
- Equipment view (equipment slots)
- Upgrades view (upgrade list)
- Progress view (skill summary panels)
- Sidebar (skill buttons)

## Edge Cases Handled

### 1. Container-Managed Layouts
✅ Buttons positioned by VBoxContainer, GridContainer, etc.  
Solution: Use `global_position` instead of relative `position`

### 2. Multiple ScrollContainers
✅ Each instance tracks its own drag state independently  
Solution: Instance variables for `_is_dragging`, `_is_scrolling`, etc.

### 3. Mouse and Touch Events
✅ Works with both touch screens and mouse  
Solution: Handle both `InputEventScreenTouch` and `InputEventMouseButton`

### 4. Nested Controls
✅ Buttons within panels, containers, etc.  
Solution: Recursive search through entire child tree

### 5. Horizontal and Vertical Scrolling
✅ Supports both scroll directions  
Solution: Check `vertical_scroll_mode` and `horizontal_scroll_mode`

## Performance Considerations

### Button Search
- **Complexity**: O(n) where n = number of nodes in tree
- **Frequency**: Only on tap (not during scrolling)
- **Typical**: <100 nodes, negligible overhead (<1ms)

### Event Handling
- **Frequency**: Every input event in viewport
- **Cost**: Minimal (bounds check + state updates)
- **Optimization**: Early returns when event not relevant

## Known Limitations
- Does not support multi-touch scrolling (single touch only by design)
- Assumes buttons emit `pressed` signal (standard Button behavior)
- Button search is O(n); could be optimized with spatial indexing if needed
- May need adjustment if buttons have custom input handling that doesn't use `pressed` signal

## Related Files
- `scripts/mobile_scroll_container.gd` - Core mobile scroll implementation
- `scenes/main.tscn` - Main game scene with static ScrollContainers
- `scripts/main.gd` - Main game script with dynamic ScrollContainers
- `test/test_main_screen_scroll.gd` - Test for main screen ScrollContainers
- `test/test_sidebar_scrolling.gd` - Test for sidebar ScrollContainer
- `test/test_mobile_scroll_v3.gd` - Test for V3 implementation (_input method)
- `test/test_mobile_scroll_button_fix.gd` - Test for button fix implementation
- `test/visualize_mobile_scroll_v2.gd` - Visual testing tool

## Implementation History
- **Initial**: Basic mobile scroll with `_gui_input()` - didn't work when starting on buttons
- **V2**: Switched to `_input()` for higher priority event handling
- **V3** (Commit e879501): Used `_input()` but only marked events as handled after threshold
  - Problem: Buttons still captured initial press, preventing scroll
- **V4** (This fix): Mark events as handled immediately + manual button triggering
  - Solution: Prevents button capture while maintaining tap functionality

## See Also
- [Godot Input Event Documentation](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html)
- PR #100: "Enable drag-to-scroll on sidebar when touching buttons"
- PR #103: "Fix mobile scrolling after button tap by using _input() instead of _gui_input()"
- Current fix: "Fix mobile scrolling when starting on buttons" (immediate event handling)
