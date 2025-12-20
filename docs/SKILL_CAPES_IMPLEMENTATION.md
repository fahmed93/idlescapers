# Level 99 Skill Cape Upgrades Implementation

## Overview
This implementation adds level 99 skill capes as one-time purchasable upgrades that provide unique effects for each of the 15 skills. These prestigious capes are only available to players who have reached the maximum level (99) in a skill and cost 99,000 gold each.

## Design Philosophy
Unlike regular upgrades that provide speed bonuses, skill capes offer unique gameplay-enhancing effects that are specific to each skill. These effects are designed to:
- Reward players for reaching level 99
- Provide meaningful quality-of-life improvements
- Feel unique and powerful without being game-breaking
- Encourage players to max out all skills

## Implementation Details

### Resource Updates (`resources/upgrades/upgrade_data.gd`)
Extended the `UpgradeData` resource class with:
- `is_skill_cape: bool` - Identifies this upgrade as a skill cape
- `cape_effect_id: String` - Unique identifier for the cape's effect

### UpgradeShop Autoload (`autoload/upgrade_shop.gd`)
Added 15 skill capes with the following additions:

#### New Helper Method
```gdscript
func _add_skill_cape(id: String, display_name: String, skill_id: String,
	desc: String, level_req: int, cost: int, effect_id: String) -> void
```
Creates skill cape upgrades with `is_skill_cape = true` and `speed_modifier = 0.0`.

#### New Query Methods
```gdscript
func has_skill_cape(skill_id: String) -> bool
```
Checks if the player owns the skill cape for a specific skill.

```gdscript
func get_cape_effect(skill_id: String) -> String
```
Returns the effect ID of the owned cape for a skill (or empty string).

```gdscript
func has_cape_effect(effect_id: String) -> bool
```
Checks if a specific cape effect is currently active.

### GameManager Updates (`autoload/game_manager.gd`)
Modified `_complete_action()` to implement all 15 cape effects:

#### Success Rate Modifications
- **Cooking Cape** (`perfect_cooking`): Sets success rate to 100% for all cooking
- **Smithing Cape** (`perfect_iron_smelting`): Sets success rate to 100% for iron smelting

#### Material Saving
Applied before item consumption:
- **Fletching Cape** (`save_fletching_materials`): 10% chance to not consume materials
- **Herblore Cape** (`save_herblore_ingredients`): 10% chance to not consume ingredients
- **Jewelcrafting Cape** (`save_gems`): 5% chance to not consume gems
- **Crafting Cape** (`save_crafting_hides`): 10% chance to not consume hides

#### XP Bonuses
Applied to base XP before granting:
- **Firemaking Cape** (`double_firemaking_xp`): 2x XP multiplier
- **Agility Cape** (`extra_agility_xp`): 1.05x XP multiplier (5% bonus)
- **Astrology Cape** (`extra_astrology_xp`): 1.05x XP multiplier (5% bonus)

#### Double Item Drops
Applied after successful item production:
- **Fishing Cape** (`double_fish`): 5% chance to receive double fish
- **Woodcutting Cape** (`double_logs`): 5% chance to receive double logs
- **Skinning Cape** (`double_hides`): 5% chance to receive double hides
- **Foraging Cape** (`double_foraging`): 5% chance to receive double materials

#### Bonus Item Enhancement
- **Mining Cape** (`double_gem_chance`): Doubles the drop rate for bonus gems (e.g., 1% becomes 2%)

#### Gold Bonuses
- **Thieving Cape** (`extra_thieving_gold`): Adds 10% bonus coins when thieving produces coins

## All Skill Capes

| Skill | Cape Name | Effect ID | Effect Description |
|-------|-----------|-----------|-------------------|
| Fishing | Fishing Skillcape | `double_fish` | 5% chance to catch double fish |
| Cooking | Cooking Skillcape | `perfect_cooking` | 100% success rate - never burn food |
| Woodcutting | Woodcutting Skillcape | `double_logs` | 5% chance to get double logs |
| Fletching | Fletching Skillcape | `save_fletching_materials` | 10% chance to save materials |
| Mining | Mining Skillcape | `double_gem_chance` | Double chance for bonus gem drops |
| Firemaking | Firemaking Skillcape | `double_firemaking_xp` | 2x XP from all fires |
| Smithing | Smithing Skillcape | `perfect_iron_smelting` | 100% success rate for iron |
| Herblore | Herblore Skillcape | `save_herblore_ingredients` | 10% chance to save ingredients |
| Thieving | Thieving Skillcape | `extra_thieving_gold` | 10% extra coins from pickpocketing |
| Agility | Agility Skillcape | `extra_agility_xp` | 5% extra XP from courses |
| Astrology | Astrology Skillcape | `extra_astrology_xp` | 5% extra XP from studies |
| Jewelcrafting | Jewelcrafting Skillcape | `save_gems` | 5% chance to save gems |
| Skinning | Skinning Skillcape | `double_hides` | 5% chance to get double hides |
| Foraging | Foraging Skillcape | `double_foraging` | 5% chance to get double materials |
| Crafting | Crafting Skillcape | `save_crafting_hides` | 10% chance to save hides |

## Cape Requirements & Cost

All skill capes share the same requirements:
- **Level Required**: 99 (maximum level)
- **Cost**: 99,000 gold
- **Quantity**: One per skill (one-time purchase)

## Testing

A comprehensive test suite was created in `test/test_skill_capes.gd` that verifies:

1. **Cape Loading**: All 15 capes are properly registered
2. **Cape Properties**: Each cape has correct level requirement (99), cost (99,000), and effect ID
3. **Purchase Validation**: Cannot purchase without sufficient gold
4. **Level Validation**: Cannot purchase without level 99
5. **Successful Purchase**: Can purchase with level 99 and gold
6. **Cape Effect Queries**: `has_skill_cape()` and `has_cape_effect()` work correctly
7. **Multiple Capes**: Can own multiple capes simultaneously
8. **Save/Load**: Purchased capes persist across save/load cycles

Run the test with:
```bash
godot --headless --path . test/test_skill_capes.tscn
```

## Usage Examples

### For Players
1. Train a skill to level 99
2. Earn 99,000 gold (by selling items at the Store)
3. Navigate to the Upgrades shop from the sidebar
4. Purchase the skill cape for your maxed skill
5. The cape's effect activates automatically while training

### For Developers

#### Check if player has a specific cape
```gdscript
if UpgradeShop.has_skill_cape("fishing"):
    print("Player has the Fishing Skillcape!")
```

#### Check if a specific effect is active
```gdscript
if UpgradeShop.has_cape_effect("double_fish"):
    # Apply double fish logic
    pass
```

#### Get the cape effect for a skill
```gdscript
var effect_id = UpgradeShop.get_cape_effect("fishing")
if effect_id == "double_fish":
    print("Fishing cape provides double fish effect")
```

## Design Decisions

### Why Not Speed Bonuses?
Regular upgrades already provide speed bonuses. Skill capes needed to feel unique and prestigious, so they provide qualitative improvements rather than quantitative speed increases.

### Effect Balance
- **Success Rate Effects** (Cooking, Smithing): Remove frustration from RNG
- **Material Saving** (Fletching, Herblore, Jewelcrafting, Crafting): Reduce resource consumption for expensive skills
- **XP Bonuses** (Firemaking, Agility, Astrology): Help with post-99 training or alt accounts
- **Double Drops** (Fishing, Woodcutting, Skinning, Foraging): Increase gathering efficiency
- **Gem Enhancement** (Mining): Enhances the existing bonus drop system
- **Gold Bonus** (Thieving): Makes a profitable skill even more profitable

### Cost Justification
99,000 gold is a significant investment that:
- Feels appropriate for a level 99 achievement
- Requires players to engage with the economy (selling items)
- Isn't so expensive that it feels unobtainable
- Matches the prestige of the "99" number

## Future Enhancements

Potential additions that could build on this system:
1. **Cape Icons**: Visual indicators when capes are equipped
2. **Cape Rack**: Special UI section to display all owned capes
3. **Max Cape**: Special cape unlocked when all 15 skills reach 99
4. **Trimmed Capes**: Upgraded versions requiring 200M XP
5. **Cape Perks**: Additional toggleable effects
6. **Achievement Integration**: Track which capes have been obtained

## Compatibility

The skill cape system is fully compatible with:
- **Save/Load System**: Capes persist via `purchased_upgrades` array
- **Offline Progress**: Cape effects apply to offline calculations
- **Multiple Characters**: Each character slot has independent cape ownership
- **Existing Upgrades**: Capes work alongside regular speed-boost upgrades

## Notes

- Skill capes do NOT provide speed bonuses (`speed_modifier = 0.0`)
- Skill capes are one-time purchases (cannot be purchased twice)
- Cape effects are always active when training the associated skill
- No equipment system required - capes work passively
- Effects are applied in `GameManager._complete_action()` for consistency
