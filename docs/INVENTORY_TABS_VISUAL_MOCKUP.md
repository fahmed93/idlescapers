# Inventory Tabs Feature - Visual Mockup

## UI Layout

```
┌─────────────────────────────────────────────────────┐
│                   Inventory                          │
├─────────────────────────────────────────────────────┤
│ [Main] [Fish] [Armor] [Tools]  [+]                  │  ← Tab Bar
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐            │
│  │ 🐟   │  │ 🐟   │  │ 🐟   │  │ 🐟   │            │
│  │Shrimp│  │Salmon│  │ Tuna │  │Shark │            │
│  │ x50  │  │ x30  │  │ x15  │  │ x5   │            │
│  └──────┘  └──────┘  └──────┘  └──────┘            │
│                                                      │
│  ┌──────┐  ┌──────┐  ┌──────┐                       │
│  │ 🐟   │  │ 🐟   │  │ 🐟   │                       │
│  │Lobstr│  │Swrdfs│  │Monkfs│                       │
│  │ x20  │  │ x12  │  │ x8   │                       │
│  └──────┘  └──────┘  └──────┘                       │
│                                                      │
│  Tap for details                                     │  ← Help Text
└─────────────────────────────────────────────────────┘
```

## Drag and Drop Visual Flow

### 1. Initial State
```
Tab Bar: [Main*] [Raw Fish] [Cooked Fish]
         ^^^^^^
         Selected (highlighted)

Grid shows items in Main tab
```

### 2. Clicking Item to Drag
```
User clicks on "Raw Shrimp" item
└─> Mouse Down Event Detected
    └─> Drag Preview Created
```

### 3. Dragging
```
┌──────────────┐  ← Drag Preview (follows cursor)
│  🐟         │
│ Raw Shrimp  │
│   x50       │
└──────────────┘
         ↓ (moving toward tab)

Tab Bar: [Main] [Raw Fish] [Cooked Fish]
                 ^^^^^^^^^ ← Hover target
```

### 4. Hovering Over Target Tab
```
Tab Bar: [Main] [Raw Fish*] [Cooked Fish]
                 ^^^^^^^^^ ← Highlighted as drop target

Drag Preview still follows cursor
```

### 5. Drop Complete
```
Mouse Released → Item Moved
- Removed from Main: raw_shrimp x50
- Added to Raw Fish: raw_shrimp x50

Tab Bar: [Main] [Raw Fish*] [Cooked Fish]
Drag Preview: Disappears
Grid: Updates to show Raw Fish tab contents
```

## Right-Click Context Menu

```
User right-clicks on "Raw Fish" tab:

┌─────────────┐
│  Rename     │  ← Option 1
├─────────────┤
│  Delete     │  ← Option 2
└─────────────┘
```

### Rename Flow
```
Select "Rename" → Dialog Appears

┌──────────────────────────┐
│   Rename Tab             │
│                          │
│  Enter new name:         │
│  ┌────────────────────┐  │
│  │ Raw Fish           │  │ ← Text Input (max 20 chars)
│  └────────────────────┘  │
│                          │
│    [Cancel]    [OK]      │
└──────────────────────────┘
```

### Delete Flow
```
Select "Delete" → Tab Removed

Before:
[Main] [Raw Fish] [Cooked Fish]

After:
[Main] [Cooked Fish]

Items from "Raw Fish" moved to Main tab
```

## Tab States

### Normal Tab
```
┌──────────┐
│   Fish   │
└──────────┘
```

### Selected Tab
```
┌──────────┐
│   Fish   │  ← Different background color
└──────────┘    (e.g., lighter or bordered)
```

### Hover State (during drag)
```
┌──────────┐
│   Fish   │  ← Visual feedback (glow/highlight)
└──────────┘    indicating valid drop target
```

## Edge Cases Visualization

### Maximum Tabs (10)
```
Tab Bar with scroll:
< [Main][Tab1][Tab2][Tab3][Tab4][Tab5][Tab6][Tab7][Tab8][Tab9] >
                                                                 [+] grayed out
```

### Empty Tab
```
Tab selected but no items:

┌─────────────────────────────────────────────────────┐
│                   Inventory                          │
├─────────────────────────────────────────────────────┤
│ [Main] [Empty Tab*] [Fish]  [+]                     │
├─────────────────────────────────────────────────────┤
│                                                      │
│              No items in this tab                    │  ← Empty state
│                                                      │
│         Drag items here to organize!                 │  ← Help text
│                                                      │
└─────────────────────────────────────────────────────┘
```

### Main Tab (Protected)
```
Right-click on Main tab → No context menu appears
(Main tab cannot be renamed or deleted)
```

## Color Scheme Suggestions

Based on existing SkillForge Idle UI:

- **Main Tab**: Green tint (#6b8b6b) - matches inventory button color
- **Custom Tabs**: Neutral gray (#808080)
- **Selected Tab**: Lighter shade with border
- **Hover (drag target)**: Slight glow or border pulse
- **Drag Preview**: Semi-transparent panel with item icon

## Responsive Behavior

### Mobile (720x1280)
```
- Tab bar scrolls horizontally
- Items in 4-column grid (existing)
- Drag preview sized appropriately
- Context menu positioned to avoid edges
```

### Touch Support
```
- Long press to start drag (150ms)
- Touch and hold shows drag preview
- Release over tab to drop
- Tap to select tab
- Long press tab for context menu
```

## Animation Suggestions

1. **Tab Selection**: Smooth color transition (0.2s)
2. **Drag Preview**: Fade in on start (0.1s), fade out on drop (0.1s)
3. **Tab Creation**: Slide in from right (0.3s)
4. **Tab Deletion**: Slide out to right (0.3s)
5. **Item Movement**: Brief highlight flash on destination (0.3s)

## Accessibility

- **Visual**: Selected tab has distinct color/border
- **Feedback**: Console messages for all operations
- **Undo**: Items moved to Main on tab delete (data preservation)
- **Help Text**: "Tap for details" on items, "Drag to organize" on empty tabs

## Integration with Existing UI

The inventory tabs feature integrates seamlessly:

```
Main Game View:
├── Sidebar (left)
│   ├── Player Section
│   │   ├── Equipment
│   │   ├── Inventory ← Leads to tab view
│   │   └── Upgrades
│   ├── Skills Section
│   └── Info Section
└── Main Content (right)
    ├── Skill View (when skill selected)
    └── Inventory View (when Inventory selected)
        ├── Header: "Inventory"
        ├── Tab Bar ← NEW
        └── Item Grid ← Enhanced with drag support
```

## User Flow Example

```
1. User catches 100 raw fish while fishing
   └─> All go to Main tab (default)

2. User wants to organize inventory
   └─> Clicks "Inventory" in sidebar
   └─> Clicks "+" to create tab
   └─> New tab "Tab 1" appears

3. User renames tab to "Raw Fish"
   └─> Right-click tab → Rename
   └─> Enter "Raw Fish" → OK
   └─> Tab name updates

4. User moves fish to new tab
   └─> Stay on Main tab
   └─> Click and hold raw_shrimp
   └─> Drag to "Raw Fish" tab
   └─> Release → Items moved

5. Result: Organized inventory!
   Main tab: Mixed items
   Raw Fish tab: All raw fish
```

## Error States

### Invalid Name
```
Rename dialog with empty string:
┌──────────────────────────┐
│   Rename Tab             │
│                          │
│  Enter new name:         │
│  ┌────────────────────┐  │
│  │                    │  │ ← Empty!
│  └────────────────────┘  │
│                          │
│    [Cancel]    [OK]      │  ← OK disabled or shows error
└──────────────────────────┘
```

### Max Tabs Reached
```
User clicks "+" when 10 tabs exist:
- Console error: "Cannot create more than 10 tabs"
- Button briefly flashes red or shows tooltip
- No new tab created
```

This mockup shows the complete user experience for the inventory tabs feature!
