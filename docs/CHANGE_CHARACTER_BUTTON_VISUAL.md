# Change Character Button - Visual Reference

## Button Appearance

The "Change Character" button appears in the top-right corner of the main game screen:

```
┌────────────────────────────────────────────────────────────────────┐
│  ☰                                        ┌────────────────────┐   │
│  [Menu]                                   │ Change Character   │   │
│                                           └────────────────────┘   │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  [Game Content Below]                                              │
│                                                                     │
```

## Dimensions and Positioning

- **Viewport Size**: 720x1280 pixels (mobile portrait)
- **Menu Button**: 
  - Position: (8, 8) from top-left
  - Size: 50x50 px
  - Text: "☰"
  
- **Change Character Button**:
  - Position: 8px from top, 8px from right edge
  - Size: 120x40 px
  - Text: "Change Character"
  - Font size: 14
  - Anchor: Top-right (anchor_left=1.0, anchor_right=1.0)

## In Context

```
Screen: 720px wide × 1280px tall

┌─────────────────────────────────────────────────┐  ← 0px (top)
│ ☰                      Change Character         │  ← 8px from top
│ [50×50]                [120×40]                  │
├────────┬────────────────────────────────────────┤  ← 58px (below menu)
│        │                                         │
│ Skills │    Selected Skill: Fishing              │
│        │    Level: 15                            │
│ Fish   │    XP: 450 / 2411                       │
│ Cook   │                                         │
│ Cut    │    Training Methods                     │
│ ...    │    ┌─────────────────────────────┐     │
│        │    │ Raw Shrimp           [Train]│     │
│        │    │ Lv 1 | 10 XP | 3.0s          │     │
│ Upgrd  │    └─────────────────────────────┘     │
│ Invnt  │    ┌─────────────────────────────┐     │
│        │    │ Raw Sardine          [Train]│     │
│ Total  │    │ Lv 5 | 20 XP | 4.0s          │     │
│  42    │    └─────────────────────────────┘     │
│        │                                         │
└────────┴─────────────────────────────────────────┘
          ↑                                        ↑
       120px                                    720px
    (sidebar)                               (right edge)
```

## Button States

### Normal State
- Background: Default button background
- Text: "Change Character" (white/default)
- Border: Standard button border

### Hover State (Desktop)
- Background: Slightly lighter
- Cursor: Pointer

### Pressed State
- Background: Pressed appearance
- Immediate action: Save game and return to character select

## Interaction Flow

1. **User sees button** in top-right corner at all times
2. **User taps/clicks** the "Change Character" button
3. **Game saves** automatically (if training, stops first)
4. **Scene transitions** to startup/character selection screen
5. **User can select** same or different character
6. **Game loads** selected character's save data
7. **Scene transitions** back to main game screen

## Spacing

```
Left edge                                        Right edge
│◄──8px──►│☰│                        │◄──8px──►│Change Character│◄──8px──►│
│         └───50px───┘                          └──────120px─────┘         │
│                                                                           │
│◄─────────────────────────────720px──────────────────────────────────────►│
```

The buttons are well-separated:
- Menu button: 8px from left
- Change Character button: 8px from right
- Clear space between them: ~542px (plenty of room)

## Responsive Behavior

The button uses Godot's anchor system:
- `anchor_left = 1.0` - Anchored to right edge
- `anchor_right = 1.0` - Anchored to right edge
- `offset_left = -128` - 120px button + 8px padding
- `offset_right = -8` - 8px from edge

This ensures the button stays in the top-right corner regardless of screen size or orientation changes.
