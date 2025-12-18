# Item Count Display Feature - Visual Example

## What Changed

When viewing training methods that consume items (like Cooking or Herblore), the UI now shows how many of each required item you currently own, with color-coded indicators.

## Before

```
Cook Shrimp
Level 1 | 30.0 XP | 2.0s | 70% success
Uses: Raw Shrimp x1 → Cooked Shrimp
```

## After

If you have 0 items (shown in RED):

```
Cook Shrimp
Level 1 | 30.0 XP | 2.0s | 70% success
Uses: Raw Shrimp x1 (0 owned) → Cooked Shrimp
                    ^^^^^^^^^ (RED)
```

If you have items (shown in GREEN):

```
Cook Shrimp
Level 1 | 30.0 XP | 2.0s | 70% success
Uses: Raw Shrimp x1 (15 owned) → Cooked Shrimp
                    ^^^^^^^^^^ (GREEN)
```

## Multiple Ingredients Example (Herblore)

### Before

```
Attack Potion
Level 1 | 25.0 XP | 2.0s
Uses: Guam Leaf x1 Uses: Eye of Newt x1 → Attack Potion
```

### After

```
Attack Potion
Level 1 | 25.0 XP | 2.0s
Uses: Guam Leaf x1 (3 owned) Uses: Eye of Newt x1 (7 owned) → Attack Potion
                   ^^^^^^^^^ (GREEN)                ^^^^^^^^^ (GREEN)
```

Or with mixed availability:

```
Attack Potion
Level 1 | 25.0 XP | 2.0s
Uses: Guam Leaf x1 (0 owned) Uses: Eye of Newt x1 (7 owned) → Attack Potion
                   ^^^^^^^^^ (RED)                  ^^^^^^^^^ (GREEN)
```

## Technical Details

- The item count is retrieved from `Inventory.get_item_count(item_id)`
- The display updates automatically when inventory changes
- Format: `Uses: <item_name> x<required_amount> [color=green/red](<owned_count> owned)[/color]`
- Color logic: GREEN if count > 0, RED if count = 0
- Uses RichTextLabel with BBCode for color formatting
- Works with all skills that consume items (Cooking, Herblore, Fletching, Smithing, etc.)

## Files Modified

- `scripts/main.gd`:
  - Line 195: Added color logic based on item count
  - Changed Label to RichTextLabel with BBCode enabled
  - Line 289-291: Auto-refresh action list when inventory changes

## Testing

Run `test/test_item_count_display.tscn` to verify:
1. Item counts display correctly
2. Counts update after consumption
3. Zero counts display in red
4. Non-zero counts display in green
5. Multiple ingredients work correctly

