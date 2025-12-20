# Smithing Collapsible Sections - UI Mockup

## Visual Design

### Before (Without Collapsible Sections)
```
┌─────────────────────────────────────┐
│ Smithing - Level 1                  │
│ [XP Progress Bar]                   │
├─────────────────────────────────────┤
│ Available Training Methods          │
├─────────────────────────────────────┤
│ ┌───────────────────────────────┐   │
│ │ Bronze Bar         [Train] │   │
│ │ Level 1 | 6.25 XP | 2.0s   │   │
│ │ Uses: Copper Ore x1, Tin... │   │
│ └───────────────────────────────┘   │
│ ┌───────────────────────────────┐   │
│ │ Iron Bar           [Lv 15] │   │
│ │ Level 15 | 12.5 XP | 3.0s  │   │
│ └───────────────────────────────┘   │
│ ┌───────────────────────────────┐   │
│ │ Silver Bar         [Lv 20] │   │
│ └───────────────────────────────┘   │
│ ... (47 more items)                 │
│                                     │
│ (requires lots of scrolling)        │
└─────────────────────────────────────┘
```

### After (With Collapsible Sections)
```
┌─────────────────────────────────────┐
│ Smithing - Level 1                  │
│ [XP Progress Bar]                   │
├─────────────────────────────────────┤
│ Available Training Methods          │
├─────────────────────────────────────┤
│ ▼ Bars (8)                          │ ← Category Header (expanded)
│ ┌───────────────────────────────┐   │
│ │ Bronze Bar         [Train] │   │
│ │ Level 1 | 6.25 XP | 2.0s   │   │
│ │ Uses: Copper Ore x1, Tin... │   │
│ └───────────────────────────────┘   │
│ ┌───────────────────────────────┐   │
│ │ Iron Bar           [Lv 15] │   │
│ │ Level 15 | 12.5 XP | 3.0s  │   │
│ └───────────────────────────────┘   │
│ ... (6 more bars)                   │
│                                     │
│ ▼ Bronze (7)                        │ ← Category Header (expanded)
│ ┌───────────────────────────────┐   │
│ │ Bronze Arrowheads  [Train] │   │
│ │ Level 1 | 12.5 XP | 2.0s   │   │
│ └───────────────────────────────┘   │
│ ┌───────────────────────────────┐   │
│ │ Bronze Dagger      [Train] │   │
│ └───────────────────────────────┘   │
│ ... (5 more bronze items)           │
│                                     │
│ ▶ Iron (7)                          │ ← Category Header (collapsed)
│                                     │
│ ▶ Steel (7)                         │ ← Category Header (collapsed)
│                                     │
│ ▶ Mithril (7)                       │ ← Category Header (collapsed)
│                                     │
│ ▶ Adamantite (7)                    │ ← Category Header (collapsed)
│                                     │
│ ▶ Runite (7)                        │ ← Category Header (collapsed)
│                                     │
│ (much less scrolling needed)        │
└─────────────────────────────────────┘
```

## Interaction Flow

### Step 1: Initial View (All Expanded)
When the player first opens the Smithing screen, all categories are expanded by default, showing all 50 methods.

### Step 2: Collapsing a Category
Player clicks on "▼ Bronze (7)" header:
- The indicator changes from ▼ to ▶
- The 7 bronze items disappear
- Other categories remain unchanged
- State is saved: `collapsed_categories["smithing"]["Bronze"] = true`

### Step 3: Expanding a Category
Player clicks on "▶ Bronze (7)" header:
- The indicator changes from ▶ to ▼
- The 7 bronze items reappear
- State is updated: `collapsed_categories["smithing"]["Bronze"] = false`

### Step 4: Persistence
When the player:
- Switches to another skill and back
- Closes the sidebar and reopens it
- The collapsed/expanded state is remembered for each category

## Category Order

Categories appear in this order (matching progression):
1. **Bars** - All ore smelting (levels 1-85)
2. **Bronze** - Entry level items (levels 1-18)
3. **Iron** - Early tier items (levels 15-23)
4. **Steel** - Mid-early tier items (levels 30-38)
5. **Mithril** - Mid tier items (levels 50-58)
6. **Adamantite** - High tier items (levels 70-78)
7. **Runite** - Top tier items (levels 85-93)

## Visual Styling

### Category Headers
- **Height**: 40px
- **Alignment**: Left-aligned text
- **Font Size**: 16px (larger than method names at 14px)
- **Color**: Light blue (0.8, 0.9, 1.0) - distinct from method text
- **Indicator**: 
  - Expanded: `▼` (Unicode U+25BC, Black Down-Pointing Triangle)
  - Collapsed: `▶` (Unicode U+25B6, Black Right-Pointing Triangle)
- **Format**: `{indicator} {category_name} ({count})`
  - Example: `▼ Bronze (7)` or `▶ Runite (7)`

### Method Items
- **Height**: 80px (unchanged from original)
- **Styling**: Identical to original design
- **Spacing**: No extra spacing between categories (seamless)

## Benefits at Different Skill Levels

### Level 1 Player
- Can collapse all categories except "Bars" and "Bronze"
- Reduces visual clutter of 50 items to ~15 visible items
- Focus on relevant content

### Level 50 Player
- Can keep "Bars" and "Mithril" expanded
- Collapse bronze/iron/steel items they've outgrown
- Still see progression to adamantite/runite

### Level 99 Player
- Can focus on just "Runite" category
- Quick access to endgame content
- All other categories collapsed

## Mobile Optimization

On the 720x1280 mobile viewport:
- Category headers use full width (minus scroll bar)
- Touch-friendly 40px height for easy tapping
- Clear visual feedback (indicator change) on tap
- Smooth list updates when expanding/collapsing
- No animation delays (instant show/hide for responsiveness)

## Accessibility

- **Clear visual indicators**: ▼/▶ symbols are universally understood
- **Category counts**: Shows how many items without needing to expand
- **Consistent interaction**: Same tap/click behavior for all categories
- **State persistence**: Players don't lose their organization
- **No data loss**: Collapsing doesn't affect game state or training

## Edge Cases Handled

1. **Single category**: If a skill has only one category or no categories, headers are not shown
2. **Empty categories**: If a category has no methods (shouldn't happen), it shows "(0)"
3. **Switching skills**: Each skill maintains its own collapsed state dictionary
4. **Training active**: Collapsing a category doesn't stop training that method
5. **Level up**: Expanding a category after level up shows newly unlocked methods
