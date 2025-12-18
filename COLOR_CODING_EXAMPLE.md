# Visual Example: Color-Coded Item Counts

This document shows what the color-coded item counts look like in the game.

## Example 1: Cooking - No Items (RED)

```
┌─────────────────────────────────────────────────────────┐
│ Cook Shrimp                                             │
│ Level 1 | 30.0 XP | 2.0s | 70% success                 │
│ Uses: Raw Shrimp x1 (0 owned) → Cooked Shrimp         │
│                     ^^^^^^^^^^                          │
│                     RED COLOR                           │
│                                             [Train]     │
└─────────────────────────────────────────────────────────┘
```

## Example 2: Cooking - Has Items (GREEN)

```
┌─────────────────────────────────────────────────────────┐
│ Cook Shrimp                                             │
│ Level 1 | 30.0 XP | 2.0s | 70% success                 │
│ Uses: Raw Shrimp x1 (15 owned) → Cooked Shrimp        │
│                     ^^^^^^^^^^^                         │
│                     GREEN COLOR                         │
│                                             [Train]     │
└─────────────────────────────────────────────────────────┘
```

## Example 3: Herblore - Multiple Ingredients (MIXED)

When you have some ingredients but not others:

```
┌─────────────────────────────────────────────────────────┐
│ Attack Potion                                           │
│ Level 1 | 25.0 XP | 2.0s                               │
│ Uses: Guam Leaf x1 (0 owned) Eye of Newt x1 (7 owned) │
│                    ^^^^^^^^^^                ^^^^^^^^^^│
│                    RED COLOR                GREEN COLOR│
│ → Attack Potion                                         │
│                                             [Train]     │
└─────────────────────────────────────────────────────────┘
```

## Example 4: Herblore - All Ingredients Available (ALL GREEN)

```
┌─────────────────────────────────────────────────────────┐
│ Attack Potion                                           │
│ Level 1 | 25.0 XP | 2.0s                               │
│ Uses: Guam Leaf x1 (3 owned) Eye of Newt x1 (7 owned) │
│                    ^^^^^^^^^^                ^^^^^^^^^^│
│                    GREEN COLOR              GREEN COLOR│
│ → Attack Potion                                         │
│                                             [Train]     │
└─────────────────────────────────────────────────────────┘
```

## Color Logic

- **GREEN** = Player has at least 1 of the item (count > 0)
- **RED** = Player has 0 of the item (count = 0)

This provides immediate visual feedback so players can quickly scan and see:
- Which materials they have available
- Which materials they need to gather
- Whether they can train the skill or need to gather materials first

## Technical Implementation

The colors are implemented using Godot's RichTextLabel with BBCode:
```gdscript
var count_color := "green" if player_count > 0 else "red"
items_text += "Uses: %s x%d [color=%s](%d owned)[/color] " % [item_name, required, count_color, player_count]
```

The RichTextLabel has `bbcode_enabled = true` to parse the color tags.
