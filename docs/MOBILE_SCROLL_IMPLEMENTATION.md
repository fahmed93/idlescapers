# Mobile Scroll Implementation

## Overview
This document describes the implementation of drag-to-scroll functionality on the main screen, allowing users to scroll even when touching buttons or skill leveling options.

## Problem Statement
Previously, the main action list and other scroll containers in the main screen did not support drag-to-scroll when the user started their touch/drag on a button or interactive element. This made scrolling difficult on mobile devices and touch screens.

## Solution
Applied the existing `mobile_scroll_container.gd` script to all ScrollContainer nodes in the main screen area. This script intercepts touch/drag events at a higher priority than child buttons, enabling smooth scrolling.

## Changes Made

### 1. Scene File Updates (scenes/main.tscn)
Added the mobile scroll script to two static ScrollContainer nodes:
- **Action List ScrollContainer**: `MainContent/ActionList/ScrollContainer`
- **Inventory Panel ScrollContainer**: `MainContent/InventoryPanel/VBoxContainer/ScrollContainer`

### 2. Script Updates (scripts/main.gd)
- Added `MobileScrollScript` constant to preload the mobile scroll script
- Applied the script to 6 dynamically created ScrollContainers:
  1. Inventory tab bar scroll (horizontal)
  2. Inventory items list scroll
  3. Equipment slots scroll
  4. Upgrades list scroll
  5. Skill summary scroll
  6. Settings scroll

### 3. Test Coverage (test/test_main_screen_scroll.gd)
Created comprehensive test to verify:
- Action list ScrollContainer has mobile scroll script
- Inventory panel ScrollContainer has mobile scroll script
- All dynamically created ScrollContainers have mobile scroll script
- Tests inventory view, equipment view, and upgrades view

## How It Works

The `mobile_scroll_container.gd` script:
1. Intercepts all touch/mouse input events using `_input()`
2. Tracks when a touch/drag starts within the ScrollContainer bounds
3. Uses a 5-pixel threshold to differentiate between taps (button clicks) and drags (scrolling)
4. Once scrolling starts, consumes the input event to prevent buttons from processing it
5. Updates the scroll position based on drag delta

### Key Features
- **Threshold-based**: 5-pixel movement threshold prevents accidental scrolling
- **Works with buttons**: Child buttons remain clickable for short taps
- **Mouse support**: Also works with mouse for editor testing
- **Predictable behavior**: Disables `follow_focus` for consistent mobile UX

## Testing

### Automated Tests
Run the test suite to verify all ScrollContainers have the mobile scroll script:
```bash
./run_tests.sh
```

Or run the specific test:
```bash
godot --headless --path . res://test/test_main_screen_scroll.tscn
```

### Manual Testing
1. Open the game in Godot editor or export to a mobile device
2. Navigate to different screens (Skills, Inventory, Equipment, Upgrades, Progress)
3. Try to scroll by dragging on:
   - Empty space in the scroll area
   - Buttons (e.g., Train buttons in skill view)
   - Text labels
   - Item panels in inventory view
4. Verify that:
   - Scrolling works smoothly in all cases
   - Short taps on buttons still trigger the button action
   - Long drags on buttons trigger scrolling instead

## Related Files
- `scripts/mobile_scroll_container.gd` - Core mobile scroll implementation
- `scenes/main.tscn` - Main game scene with static ScrollContainers
- `scripts/main.gd` - Main game script with dynamic ScrollContainers
- `test/test_main_screen_scroll.gd` - Automated test for mobile scroll
- `test/test_sidebar_scrolling.gd` - Similar test for sidebar (reference)

## See Also
- PR #100: "Enable drag-to-scroll on sidebar when touching buttons" - Previous implementation for sidebar
