# Sidebar Scrolling - Visual Behavior Guide

## Before Fix ❌

```
┌─────────────────────┐
│   Sidebar           │
│                     │
│  [Equipment]  ← Tap │
│  [Inventory]        │
│  [Upgrades]         │
│  [Fishing]          │
│  [Cooking]     ↓    │ User tries to drag down
│  [Woodcutting]      │ but nothing happens!
│  [Mining]      ✗    │ (Buttons consume events)
│                     │
└─────────────────────┘
```

**Problem**: Dragging on a button doesn't scroll!

---

## After Fix ✅

### Scenario 1: Quick Tap (< 5px movement)
```
┌─────────────────────┐
│   Sidebar           │
│                     │
│  [Equipment]  ← Tap │
│  [Inventory]        │ Quick release
│  [Upgrades]         │
│  [Fishing]     ✓    │ → Equipment view opens!
│  [Cooking]          │
│  [Woodcutting]      │
│  [Mining]           │
│                     │
└─────────────────────┘
```

**Result**: Button click works normally ✓

---

### Scenario 2: Drag Gesture (> 5px movement)
```
Step 1: Touch Down          Step 2: Drag (>5px)         Step 3: Scrolling!
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   Sidebar           │    │   Sidebar           │    │   Sidebar           │
│                     │    │                     │    │                     │
│  [Equipment]        │    │  [Equipment]        │    │  [Equipment]        │
│  [Inventory] ←Touch │    │  [Inventory] ←Start │    │  [Inventory]        │
│  [Upgrades]         │    │  [Upgrades]    ↓    │    │  [Upgrades]         │
│  [Fishing]          │    │  [Fishing]     6px  │    │  [Fishing]     ↓    │
│  [Cooking]          │    │  [Cooking]          │    │  [Cooking]     ↓    │
│  [Woodcutting]      │    │  [Woodcutting]      │    │  [Woodcutting] ↓    │
│  [Mining]           │    │  [Mining]           │    │  [Mining]      Scroll!
│                     │    │                     │    │  [Fletching]   ✓    │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
```

**Result**: Sidebar scrolls smoothly! Button is NOT activated ✓

---

## Technical Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                       User Touch Input                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ mobile_scroll_container.gd                                      │
│   _input(event)                                                 │
│     ├─ Detect touch press in bounds                             │
│     │    └─ Save start position & scroll position               │
│     ├─ Detect drag motion                                       │
│     │    └─ Calculate distance from start                       │
│     │         ├─ Distance < 5px → Do nothing (let button work)  │
│     │         └─ Distance ≥ 5px → Start scrolling!              │
│     │              ├─ Update scroll_vertical                    │
│     │              └─ Mark event as handled                     │
│     └─ Detect touch release → Reset state                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                 ┌────────────┴───────────┐
                 │                        │
                 ▼                        ▼
        ┌──────────────┐        ┌──────────────┐
        │  Scrolling!  │        │ Button Click │
        │   (> 5px)    │        │   (< 5px)    │
        └──────────────┘        └──────────────┘
```

---

## Configuration

The scroll threshold is configurable via export variable:

```gdscript
## In mobile_scroll_container.gd
@export var scroll_threshold: float = 5.0  # Default value
```

**How to adjust** (in Godot editor):
1. Select `SkillSidebar/ScrollContainer` node
2. Inspector → Script Variables → Scroll Threshold
3. Adjust value:
   - **Lower (3px)**: More sensitive, easier to scroll, harder to click buttons
   - **Higher (10px)**: Less sensitive, easier to click buttons, requires more drag

**Recommended range**: 3-10 pixels

---

## Testing Checklist

Use this checklist when testing in Godot editor or on device:

### Quick Tap Test
- [ ] Tap Equipment button quickly → Equipment view opens
- [ ] Tap Fishing button quickly → Fishing view opens
- [ ] Tap any button quickly → Corresponding view opens

### Drag to Scroll Test
- [ ] Press on Equipment, drag down 10px → Sidebar scrolls (Equipment NOT activated)
- [ ] Press on Fishing, drag up 10px → Sidebar scrolls (Fishing NOT activated)
- [ ] Press on label, drag → Sidebar scrolls smoothly

### Threshold Test
- [ ] Press on button, move 2px, release → Button activates (below threshold)
- [ ] Press on button, move 6px, release → Sidebar scrolls (above threshold)

### Edge Cases
- [ ] Scroll to top → Can't scroll beyond top
- [ ] Scroll to bottom → Can't scroll beyond bottom
- [ ] Fast flick → Scrolling works
- [ ] Slow drag → Scrolling works

---

## Performance Notes

**Efficiency**: The script only processes events when:
1. Touch/click is within ScrollContainer bounds
2. Event is a screen touch, mouse button, or drag event
3. Previous touch was within bounds (for drag events)

**No performance impact** when:
- Touching outside the sidebar
- Interacting with other UI elements
- Sidebar is collapsed/hidden

**Memory footprint**: ~200 bytes (4 state variables)

---

## Success Indicators

✅ **Working correctly when**:
- Can scroll by dragging anywhere on sidebar
- Buttons activate with quick taps
- Scroll stops at content boundaries
- Feels responsive and natural

❌ **Issues if**:
- Can't scroll when dragging on buttons → Check script is attached
- Buttons don't work → Threshold might be too low (increase to 7-10px)
- Scrolling feels sluggish → Threshold might be too high (decrease to 3-4px)
- Scrolling goes beyond content → Check clamping implementation

For troubleshooting, see `docs/SIDEBAR_SCROLLING_FIX.md`
