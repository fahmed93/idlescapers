# Level 99 Skill Capes Implementation

## Overview
Level 99 Skill Capes are prestigious upgrades that players can purchase upon reaching level 99 in any skill. Each skill has its own unique cape with a thematic description.

## Feature Details

### Requirements
- **Level**: Must have level 99 in the corresponding skill
- **Cost**: 99,000 gold per cape
- **Location**: Available in the Upgrades tab, grouped with other skill upgrades

### Effects
Each skill cape provides a **100% speed bonus** to its respective skill, effectively doubling the training speed. This stacks with all other purchased upgrades for that skill.

### Available Capes

1. **Fishing Cape of Mastery**
   - "A prestigious cape worn by master anglers. Grants perfect technique, doubling fishing speed."

2. **Woodcutting Cape of Mastery**
   - "A prestigious cape worn by legendary lumberjacks. Each swing becomes effortless, doubling woodcutting speed."

3. **Mining Cape of Mastery**
   - "A prestigious cape worn by master miners. Strikes become precise and powerful, doubling mining speed."

4. **Cooking Cape of Mastery**
   - "A prestigious cape worn by culinary masters. Your dishes cook with perfection, doubling cooking speed."

5. **Fletching Cape of Mastery**
   - "A prestigious cape worn by master fletchers. Your hands move with supernatural dexterity, doubling fletching speed."

6. **Firemaking Cape of Mastery**
   - "A prestigious cape worn by pyromancy masters. Flames obey your will instantly, doubling firemaking speed."

7. **Smithing Cape of Mastery**
   - "A prestigious cape worn by legendary blacksmiths. Each strike resonates perfectly, doubling smithing speed."

8. **Herblore Cape of Mastery**
   - "A prestigious cape worn by grand alchemists. Your potions brew with mystical efficiency, doubling herblore speed."

9. **Thieving Cape of Mastery**
   - "A prestigious cape worn by master thieves. You move like a shadow incarnate, doubling thieving speed."

10. **Agility Cape of Mastery**
    - "A prestigious cape worn by legendary athletes. Your body moves with perfect balance and grace, doubling agility speed."

11. **Astrology Cape of Mastery**
    - "A prestigious cape worn by cosmic sages. The stars align at your command, doubling astrology speed."

12. **Jewelcrafting Cape of Mastery**
    - "A prestigious cape worn by master jewelers. Every cut becomes flawless, doubling jewelcrafting speed."

13. **Skinning Cape of Mastery**
    - "A prestigious cape worn by master hunters. Your blade glides through hide effortlessly, doubling skinning speed."

14. **Foraging Cape of Mastery**
    - "A prestigious cape worn by nature's chosen. Plants reveal themselves to you instantly, doubling foraging speed."

15. **Crafting Cape of Mastery**
    - "A prestigious cape worn by legendary artisans. Your crafts form with supernatural precision, doubling crafting speed."

## Technical Implementation

### Code Changes
- **File Modified**: `autoload/upgrade_shop.gd`
- **Method**: `_load_upgrades()`
- **Pattern**: Each cape is added after the last upgrade for its respective skill

### Example Cape Definition
```gdscript
_add_upgrade("fishing_cape", "Fishing Cape of Mastery", "fishing",
    "A prestigious cape worn by master anglers. Grants perfect technique, doubling fishing speed.", 
    99, 99000, 1.0)
```

Parameters:
- `id`: Unique identifier (e.g., "fishing_cape")
- `name`: Display name shown in UI
- `skill_id`: Which skill the cape belongs to
- `description`: Flavor text describing the cape's effect
- `level_required`: 99 (max level)
- `cost`: 99000 gold
- `speed_modifier`: 1.0 (100% speed increase)

### Speed Calculation
The speed modifier works with the existing upgrade system:
- Base action time: `action_time` seconds
- With upgrades: `action_time / (1.0 + total_speed_modifier)`
- Example: If a player has 70% speed from other upgrades and buys the cape (100%), the total is 170%
  - Effective time = `action_time / (1.0 + 1.7) = action_time / 2.7`
  - This means actions complete 2.7x faster than base speed

## UI Display
Skill capes appear in the Upgrades tab under their respective skill section:
- Grayed out with "Lv 99" button if player hasn't reached level 99
- Disabled "Buy" button if player doesn't have enough gold
- "Owned ✓" button if already purchased
- Green highlight and checkmark when owned

## Testing
A dedicated test suite is available at `test/test_skill_capes.gd` which verifies:
- All 15 skills have a cape
- Each cape has correct properties (level 99, 99000 gold cost, 1.0 speed modifier)
- Cape names follow the "Cape of Mastery" pattern
- Descriptions mention "doubling" speed

## Future Enhancements
Potential improvements for skill capes:
- Visual indicators in the skill sidebar for players who own capes
- Special particle effects or visual flair when training with a cape
- Additional unique effects beyond speed (e.g., bonus XP, increased success rates)
- Cape collection achievements/rewards
