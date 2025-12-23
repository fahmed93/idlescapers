# Skill Capes Feature - Visual Summary

## Feature Overview
Level 99 skill capes are now available for all 15 skills in IdleScapers! These prestigious capes reward players who reach maximum level in a skill by providing a powerful 100% speed bonus.

## How It Looks In-Game

### Upgrades Tab Display

When players open the **Upgrades** tab and scroll to any skill section, they will see the skill cape listed as the final upgrade in the progression:

```
┌─────────────────────────────────────────────────────────┐
│ Fishing                                                  │
├─────────────────────────────────────────────────────────┤
│ Basic Fishing Rod                                       │
│ A simple rod that makes fishing 10% faster.            │
│ Level 1 | 100 Gold | +10% Speed                        │
│ [Buy]                                                   │
├─────────────────────────────────────────────────────────┤
│ Steel Fishing Rod                                       │
│ An improved rod that makes fishing 20% faster.         │
│ Level 20 | 500 Gold | +20% Speed                       │
│ [Buy]                                                   │
├─────────────────────────────────────────────────────────┤
│ ... (more upgrades) ...                                 │
├─────────────────────────────────────────────────────────┤
│ Fishing Cape of Mastery ⭐                              │
│ A prestigious cape worn by master anglers. Grants      │
│ perfect technique, doubling fishing speed.             │
│ Level 99 | 99,000 Gold | +100% Speed                   │
│ [Lv 99] (shows level requirement when locked)          │
└─────────────────────────────────────────────────────────┘
```

## Cape Purchase States

### 1. Before Level 99 (Locked)
```
Fishing Cape of Mastery
[Lv 99] (button shows level requirement, grayed out)
```

### 2. At Level 99, Insufficient Gold
```
Fishing Cape of Mastery
[Buy] (button disabled, not enough gold)
```

### 3. At Level 99, Can Afford
```
Fishing Cape of Mastery
[Buy] (button enabled and clickable)
```

### 4. After Purchase
```
Fishing Cape of Mastery ✓
(displayed in green text with checkmark)
[Owned] (button disabled)
```

## Speed Bonus Calculation

### Example: Fishing with All Upgrades
If a player has purchased all fishing upgrades:

| Upgrade | Speed Bonus |
|---------|-------------|
| Basic Fishing Rod | +10% |
| Steel Fishing Rod | +20% |
| Mithril Fishing Rod | +30% |
| Dragon Fishing Rod | +50% |
| Crystal Fishing Rod | +70% |
| **Fishing Cape of Mastery** | **+100%** |
| **TOTAL** | **+280%** |

### Effective Speed Calculation
```
Base Action Time: 3.0 seconds
Total Speed Modifier: 280% (2.8)
Effective Time: 3.0 / (1.0 + 2.8) = 0.79 seconds

Result: Actions complete 3.8x faster than base speed!
```

## All Available Capes

### ✓ Fishing Cape of Mastery
*"A prestigious cape worn by master anglers. Grants perfect technique, doubling fishing speed."*

### ✓ Woodcutting Cape of Mastery
*"A prestigious cape worn by legendary lumberjacks. Each swing becomes effortless, doubling woodcutting speed."*

### ✓ Mining Cape of Mastery
*"A prestigious cape worn by master miners. Strikes become precise and powerful, doubling mining speed."*

### ✓ Cooking Cape of Mastery
*"A prestigious cape worn by culinary masters. Your dishes cook with perfection, doubling cooking speed."*

### ✓ Fletching Cape of Mastery
*"A prestigious cape worn by master fletchers. Your hands move with supernatural dexterity, doubling fletching speed."*

### ✓ Firemaking Cape of Mastery
*"A prestigious cape worn by pyromancy masters. Flames obey your will instantly, doubling firemaking speed."*

### ✓ Smithing Cape of Mastery
*"A prestigious cape worn by legendary blacksmiths. Each strike resonates perfectly, doubling smithing speed."*

### ✓ Herblore Cape of Mastery
*"A prestigious cape worn by grand alchemists. Your potions brew with mystical efficiency, doubling herblore speed."*

### ✓ Thieving Cape of Mastery
*"A prestigious cape worn by master thieves. You move like a shadow incarnate, doubling thieving speed."*

### ✓ Agility Cape of Mastery
*"A prestigious cape worn by legendary athletes. Your body moves with perfect balance and grace, doubling agility speed."*

### ✓ Astrology Cape of Mastery
*"A prestigious cape worn by cosmic sages. The stars align at your command, doubling astrology speed."*

### ✓ Jewelcrafting Cape of Mastery
*"A prestigious cape worn by master jewelers. Every cut becomes flawless, doubling jewelcrafting speed."*

### ✓ Skinning Cape of Mastery
*"A prestigious cape worn by master hunters. Your blade glides through hide effortlessly, doubling skinning speed."*

### ✓ Foraging Cape of Mastery
*"A prestigious cape worn by nature's chosen. Plants reveal themselves to you instantly, doubling foraging speed."*

### ✓ Crafting Cape of Mastery
*"A prestigious cape worn by legendary artisans. Your crafts form with supernatural precision, doubling crafting speed."*

## Player Benefits

1. **Prestige** - Visual recognition of achieving level 99
2. **Power** - Massive 100% speed boost for end-game training
3. **Progression** - Meaningful goal after reaching max level
4. **Collection** - Incentive to max multiple skills

## Implementation Details

- **Location**: Upgrades tab, grouped with each skill's other upgrades
- **Cost**: 99,000 gold per cape
- **Effect**: Stacks with all other speed modifiers
- **Persistence**: Saved in player's upgrade collection
- **Display**: Special formatting to highlight prestige

---

*This feature is live and ready to use. Players who reach level 99 in any skill can now purchase their skill cape from the Upgrades tab!*
