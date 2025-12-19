# Sidebar Overlay - Visual Comparison

## Before: HSplitContainer Approach

```
┌─────────────────────────────────────────────────────┐
│ Main (720px width)                                  │
│ ┌─────────────────────────────────────────────────┐ │
│ │ HSplitContainer                                 │ │
│ │ ┌─────────┬───────────────────────────────────┐ │ │
│ │ │ Sidebar │ Main Content                      │ │ │
│ │ │ (120px) │ (~592px, dynamic)                 │ │ │
│ │ │         │                                   │ │ │
│ │ │ ☰ Menu  │  ┌──────────────────────────┐    │ │ │
│ │ │         │  │ Selected Skill Header    │    │ │ │
│ │ │ PLAYER  │  ├──────────────────────────┤    │ │ │
│ │ │ Equip   │  │ Training Panel           │    │ │ │
│ │ │ Inven   │  ├──────────────────────────┤    │ │ │
│ │ │ Upgrad  │  │ Training Methods         │    │ │ │
│ │ │         │  │                          │    │ │ │
│ │ │ SKILLS  │  │                          │    │ │ │
│ │ │ Fishing │  │                          │    │ │ │
│ │ │ Cooking │  │                          │    │ │ │
│ │ │ Mining  │  │                          │    │ │ │
│ │ │ ...     │  │                          │    │ │ │
│ │ │         │  └──────────────────────────┘    │ │ │
│ │ │ INFO    │                                   │ │ │
│ │ │ Progress│                                   │ │ │
│ │ │ Settings│                                   │ │ │
│ │ └─────────┴───────────────────────────────────┘ │ │
│ └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘

❌ PROBLEM: When sidebar is hidden, Main Content resizes
┌─────────────────────────────────────────────────────┐
│ Main (720px width)                                  │
│ ┌─────────────────────────────────────────────────┐ │
│ │ HSplitContainer                                 │ │
│ │ ┌──────────────────────────────────────────────┐│ │
│ │ │ Main Content (EXPANDED to ~704px)           ││ │
│ │ │                                              ││ │
│ │ │  ┌──────────────────────────────────────┐   ││ │
│ │ │  │ Selected Skill Header                │   ││ │
│ │ │  ├──────────────────────────────────────┤   ││ │
│ │ │  │ Training Panel                       │   ││ │
│ │ │  ├──────────────────────────────────────┤   ││ │
│ │ │  │ Training Methods                     │   ││ │
│ │ │  │                                      │   ││ │
│ │ │  │ (Content reflows and resizes!)       │   ││ │
│ │ │  │                                      │   ││ │
│ │ │  └──────────────────────────────────────┘   ││ │
│ │ └──────────────────────────────────────────────┘│ │
│ └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

## After: Overlay Approach

### Sidebar Closed (Default State)
```
┌─────────────────────────────────────────────────────┐
│ Main (720px width)                                  │
│ ┌─────────────────────────────────────────────────┐ │
│ │ Main Content (FULL WIDTH ~704px with padding)  │ │
│ │                                                 │ │
│ │ ☰ Menu                        Change Character │ │
│ │                                                 │ │
│ │  ┌──────────────────────────────────────────┐  │ │
│ │  │ Selected Skill Header                    │  │ │
│ │  ├──────────────────────────────────────────┤  │ │
│ │  │ Training Panel                           │  │ │
│ │  ├──────────────────────────────────────────┤  │ │
│ │  │ Training Methods                         │  │ │
│ │  │                                          │  │ │
│ │  │                                          │  │ │
│ │  │                                          │  │ │
│ │  │                                          │  │ │
│ │  │                                          │  │ │
│ │  └──────────────────────────────────────────┘  │ │
│ │                                                 │ │
│ └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

### Sidebar Open (Overlay State)
```
┌─────────────────────────────────────────────────────┐
│ Main (720px width)                                  │
│ ┌─────────────────────────────────────────────────┐ │
│ │ Main Content (SAME WIDTH - no reflow!)         │ │
│ │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │ │
│ │ ░ ✕ Menu       Dim Overlay  Change Character ░ │ │
│ │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │ │
│ │ ░┌──────────────────────────────────────────┐░ │ │
│ │ ░│ Selected Skill Header                    │░ │ │
│ │ ░├──────────────────────────────────────────┤░ │ │
│ │ ░│ Training Panel                           │░ │ │
│ │ ░├──────────────────────────────────────────┤░ │ │
│ │ ░│ Training Methods                         │░ │ │
│ │ ░│                                          │░ │ │
│ │ ░│                                          │░ │ │
│ │ ░│                                          │░ │ │
│ │ ░│                                          │░ │ │
│ │ ░└──────────────────────────────────────────┘░ │ │
│ │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │ │
│ └─────────────────────────────────────────────────┘ │
│                                                     │
│ ┌───────────┐                                      │
│ │ Sidebar   │ ◄── Overlays on left (z-index: 10)  │
│ │ (200px)   │                                      │
│ │           │                                      │
│ │ PLAYER    │                                      │
│ │ Equipment │                                      │
│ │ Inventory │                                      │
│ │ Upgrades  │                                      │
│ │           │                                      │
│ │ SKILLS    │                                      │
│ │ Fishing   │                                      │
│ │ Lv. 15    │                                      │
│ │ Cooking   │                                      │
│ │ Lv. 20    │                                      │
│ │ Mining    │                                      │
│ │ Lv. 10    │                                      │
│ │ ...       │                                      │
│ │           │                                      │
│ │ INFO      │                                      │
│ │ Progress  │                                      │
│ │ Settings  │                                      │
│ └───────────┘                                      │
└─────────────────────────────────────────────────────┘

Legend:
░ = Semi-transparent dim overlay (rgba(0,0,0,0.5), z-index: 5)
  = Sidebar panel (z-index: 10)

✅ BENEFIT: Main Content maintains constant width
✅ BENEFIT: No content reflow when toggling sidebar
✅ BENEFIT: Professional mobile UX pattern
```

## Layer Stacking (Z-Index Order)

```
┌─────────────────────────────────────┐
│  Layer 3: Sidebar Panel             │  z-index: 10
│  - PanelContainer with ScrollContainer
│  - 200px wide, full height          │
│  - Visible when open                │
└─────────────────────────────────────┘
            ▲
            │
┌─────────────────────────────────────┐
│  Layer 2: Dim Overlay               │  z-index: 5
│  - Semi-transparent black ColorRect │
│  - Clickable to close sidebar       │
│  - Visible when sidebar open        │
└─────────────────────────────────────┘
            ▲
            │
┌─────────────────────────────────────┐
│  Layer 1: Main Content + Background │  z-index: 0 (default)
│  - Main game content (skills, etc)  │
│  - Background ColorRect             │
│  - Always visible                   │
└─────────────────────────────────────┘
```

## Interaction Flow

### Opening the Sidebar
```
User clicks ☰ button
    │
    ▼
_on_sidebar_toggle_pressed() called
    │
    ▼
_set_sidebar_collapsed(false)
    │
    ├─► sidebar_panel.visible = true
    ├─► sidebar_dim_overlay.visible = true
    ├─► is_sidebar_expanded = true
    └─► menu_button.text = "✕"
    │
    ▼
[Sidebar and dim overlay appear]
[Main content remains unchanged]
```

### Closing the Sidebar (via button)
```
User clicks ✕ button
    │
    ▼
_on_sidebar_toggle_pressed() called
    │
    ▼
_set_sidebar_collapsed(true)
    │
    ├─► sidebar_panel.visible = false
    ├─► sidebar_dim_overlay.visible = false
    ├─► is_sidebar_expanded = false
    └─► menu_button.text = "☰"
    │
    ▼
[Sidebar and dim overlay disappear]
[Main content remains unchanged]
```

### Closing the Sidebar (via dim overlay)
```
User clicks dim overlay
    │
    ▼
_on_dim_overlay_clicked(event) called
    │
    ▼
Check if left mouse button pressed
    │
    ▼
Check if sidebar is expanded
    │
    ▼
_set_sidebar_collapsed(true)
    │
    ├─► sidebar_panel.visible = false
    ├─► sidebar_dim_overlay.visible = false
    ├─► is_sidebar_expanded = false
    └─► menu_button.text = "☰"
    │
    ▼
[Sidebar and dim overlay disappear]
[Main content remains unchanged]
```

## Key Differences Summary

| Aspect | Before (HSplitContainer) | After (Overlay) |
|--------|-------------------------|-----------------|
| **Main Content Width** | Dynamic (changes with sidebar) | Fixed (always ~704px) |
| **Sidebar Width** | 120px | 200px (more readable) |
| **Content Reflow** | Yes (jarring) | No (smooth) |
| **Visual Feedback** | None | Dim overlay |
| **Dismissal Methods** | Toggle button only | Toggle button + dim overlay click |
| **Mobile Pattern** | Desktop split-pane | Mobile drawer |
| **Z-Index Management** | Not needed | Explicit layering |
| **Scrolling** | Not implemented | ScrollContainer for sidebar |
| **User Experience** | Desktop-oriented | Mobile-first |

## Code Organization

### Scene Hierarchy
- Main (root Control node)
  - ColorRect (background)
  - MainContent (VBoxContainer) - all main game UI
  - SidebarDimOverlay (ColorRect) - semi-transparent overlay
  - SkillSidebar (PanelContainer) - sidebar panel
    - ScrollContainer - enables scrolling
      - SidebarContent (VBoxContainer) - actual sidebar buttons
  - MenuButton (toggle button)
  - ChangeCharacterButton
  - OfflineProgressPopup

### Related Functions
- `_on_sidebar_toggle_pressed()` - Handles toggle button clicks
- `_on_dim_overlay_clicked(event)` - Handles dim overlay clicks
- `_set_sidebar_collapsed(collapsed)` - Central function for show/hide logic
- `_create_skill_buttons()` - Creates sidebar skill buttons (unchanged logic)
- `_create_player_section_buttons()` - Creates player section buttons (unchanged logic)
- `_create_info_section_buttons()` - Creates info section buttons (unchanged logic)
