# Sidebar Overlay Implementation

## Overview
This document describes the implementation of the sidebar overlay feature, which changes the sidebar from being part of a split container to an overlay that appears on top of the main content.

## Problem Statement
Previously, the sidebar was part of an `HSplitContainer`, which meant:
- When the sidebar was shown/hidden, it affected the width of the main content area
- The main content would reflow and resize when toggling the sidebar
- This created a jarring user experience, especially on mobile devices

## Solution
The sidebar has been restructured as an overlay panel that:
- Appears on top of the main content without affecting its width
- Uses a semi-transparent dim overlay to indicate the sidebar is open
- Can be dismissed by clicking the dim overlay or the toggle button

## Implementation Details

### Scene Structure Changes (`scenes/main.tscn`)

**Before:**
```
Main (Control)
└── HSplitContainer
    ├── SkillSidebar (VBoxContainer)
    │   ├── PlayerHeader
    │   ├── SkillsHeader
    │   └── InfoHeader
    └── MainContent (VBoxContainer)
        └── [all main content nodes]
```

**After:**
```
Main (Control)
├── MainContent (VBoxContainer) - directly under root
│   └── [all main content nodes]
├── SidebarDimOverlay (ColorRect, z-index: 5)
└── SkillSidebar (PanelContainer, z-index: 10)
    └── ScrollContainer
        └── SidebarContent (VBoxContainer)
            ├── PlayerHeader
            ├── SkillsHeader
            └── InfoHeader
```

### Key Components

#### 1. SidebarDimOverlay
- **Type:** ColorRect
- **Color:** `Color(0, 0, 0, 0.5)` (semi-transparent black)
- **Z-Index:** 5 (above main content, below sidebar)
- **Visibility:** Hidden by default, shown when sidebar is open
- **Interaction:** Clicking it closes the sidebar

#### 2. SkillSidebar
- **Type:** PanelContainer
- **Size:** 200px wide, full height
- **Position:** Anchored to left side of screen
- **Z-Index:** 10 (above dim overlay)
- **Visibility:** Hidden by default, shown when toggle button is pressed
- **Scrolling:** Contains a ScrollContainer to handle many skills

#### 3. MainContent
- **Type:** VBoxContainer
- **Position:** Full screen with 8px padding
- **Behavior:** No longer affected by sidebar visibility

### Script Changes (`scripts/main.gd`)

#### New Variables
```gdscript
@onready var sidebar_panel: PanelContainer = $SkillSidebar
@onready var sidebar_dim_overlay: ColorRect = $SidebarDimOverlay
@onready var skill_sidebar: VBoxContainer = $SkillSidebar/ScrollContainer/SidebarContent
```

#### Updated Toggle Logic
```gdscript
func _set_sidebar_collapsed(collapsed: bool) -> void:
    sidebar_panel.visible = not collapsed
    sidebar_dim_overlay.visible = not collapsed
    is_sidebar_expanded = not collapsed
    
    # Update toggle button text
    if collapsed:
        menu_button.text = "☰"
    else:
        menu_button.text = "✕"
```

#### Dim Overlay Click Handler
```gdscript
func _on_dim_overlay_clicked(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if is_sidebar_expanded:
            _set_sidebar_collapsed(true)
```

### Path Reference Updates

All node path references were updated from `HSplitContainer/...` to direct paths:
- `$HSplitContainer/SkillSidebar` → `$SkillSidebar/ScrollContainer/SidebarContent`
- `$HSplitContainer/MainContent` → `$MainContent`
- All descendant paths updated accordingly

### Test File Updates

Three test files were updated to reflect the new structure:
- `test/test_sidebar_buttons.gd`
- `test/test_settings_button.gd`
- `test/test_progress_settings_persist.gd`

All references changed from:
```gdscript
var sidebar = main_instance.get_node_or_null("HSplitContainer/SkillSidebar")
```

To:
```gdscript
var sidebar = main_instance.get_node_or_null("SkillSidebar/ScrollContainer/SidebarContent")
```

## Benefits

### 1. Stable Main Content
- Main content area maintains constant width regardless of sidebar state
- No content reflow or resizing when toggling sidebar
- More predictable layout behavior

### 2. Better Mobile UX
- Overlay pattern is familiar on mobile devices
- Dim overlay provides clear visual feedback
- Easy to dismiss by tapping outside the sidebar

### 3. Improved Visual Hierarchy
- Z-index layering clearly separates UI elements
- Dim overlay draws attention to the sidebar
- Professional mobile-first design pattern

### 4. Scrollable Sidebar
- Added ScrollContainer to handle many skills
- Prevents sidebar from extending beyond screen height
- Maintains accessibility for all skills

## Technical Considerations

### Z-Index Layering
```
Main Content (default z-index: 0)
SidebarDimOverlay (z-index: 5)
SkillSidebar (z-index: 10)
MenuButton (default z-index: 0, but rendered on top due to scene order)
```

### Sizing
- Sidebar width increased from 120px to 200px for better readability
- Full height to match screen height (720x1280 mobile viewport)
- ScrollContainer prevents overflow issues

### Interaction
- Three ways to close the sidebar:
  1. Click the menu button (☰/✕)
  2. Click the dim overlay
  3. Programmatically via `_set_sidebar_collapsed(true)`

## Future Enhancements

Potential improvements for future iterations:
1. **Slide Animation:** Add smooth slide-in/slide-out animation
2. **Swipe Gesture:** Support swipe-to-close on mobile
3. **Configurable Width:** Allow sidebar width to be adjusted
4. **Remember State:** Persist sidebar open/closed preference
5. **Blur Effect:** Apply backdrop blur to main content (if performance allows)

## Testing

The implementation was verified through:
- Code review (passed with no issues)
- CodeQL security scan (no issues detected)
- Manual code inspection
- Test file updates to match new structure

To test the changes:
1. Open the game in a browser
2. Click the menu button (☰) to open the sidebar
3. Verify the sidebar slides in from the left
4. Verify a dim overlay appears over the main content
5. Click the dim overlay to close the sidebar
6. Verify the main content width doesn't change
7. Open/close the sidebar multiple times to ensure stability

## Files Modified

1. `scenes/main.tscn` - Scene structure reorganization
2. `scripts/main.gd` - Script logic updates
3. `test/test_sidebar_buttons.gd` - Path reference updates
4. `test/test_settings_button.gd` - Path reference updates
5. `test/test_progress_settings_persist.gd` - Path reference updates

## Compatibility

This change is **backwards compatible** from a save data perspective - no changes to:
- Character data structure
- Save/load logic
- Game state management
- Skill/item/inventory systems

The changes are purely UI/UX improvements and don't affect game logic or data persistence.
