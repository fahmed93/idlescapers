# Skinning Skill Implementation

## Overview
The Skinning skill allows players to collect hides and skins from various animals. These materials are raw resources that can be used in future Crafting implementations.

## Implementation Details

### Skill Registration
- **Skill ID**: `skinning`
- **Skill Name**: Skinning
- **Description**: "Skin animals to collect hides to use in crafting."
- **Color**: Color(0.7, 0.5, 0.3) - brownish/leather color
- **Location**: `autoload/skills/skinning_skill.gd`

### Training Methods
The skill includes 20 different animals to skin, progressing from level 1 to 90:

| Level | Animal | XP/Action | Action Time | Item Produced |
|-------|--------|-----------|-------------|---------------|
| 1 | Rabbit | 10.0 | 3.0s | rabbit_hide |
| 3 | Chicken | 15.0 | 2.5s | chicken_hide |
| 5 | Cow | 20.0 | 3.5s | cowhide |
| 10 | Bear | 30.0 | 4.0s | bear_hide |
| 15 | Wolf | 40.0 | 4.2s | wolf_hide |
| 20 | Snake | 50.0 | 4.5s | snake_skin |
| 25 | Crocodile | 60.0 | 5.0s | crocodile_hide |
| 30 | Yak | 70.0 | 5.2s | yak_hide |
| 35 | Polar Bear | 80.0 | 5.5s | polar_bear_hide |
| 40 | Lion | 90.0 | 5.8s | lion_hide |
| 45 | Tiger | 100.0 | 6.0s | tiger_hide |
| 50 | Black Bear | 110.0 | 6.2s | black_bear_hide |
| 55 | Blue Dragon | 120.0 | 6.5s | blue_dragonhide |
| 60 | Red Dragon | 130.0 | 7.0s | red_dragonhide |
| 65 | Black Dragon | 140.0 | 7.2s | black_dragonhide |
| 70 | Green Dragon | 150.0 | 7.5s | green_dragonhide |
| 75 | Frost Dragon | 165.0 | 8.0s | frost_dragonhide |
| 80 | Royal Dragon | 180.0 | 8.5s | royal_dragonhide |
| 85 | Chimera | 200.0 | 9.0s | chimera_hide |
| 90 | Phoenix | 225.0 | 9.5s | phoenix_feather |

### Skill Characteristics
- **No Consumed Items**: Unlike Cooking or Smithing, Skinning doesn't require any items to perform. Players can skin indefinitely.
- **100% Success Rate**: All skinning actions succeed (no failure mechanic).
- **Single Item Production**: Each action produces exactly 1 hide/skin/feather.
- **Progressive Difficulty**: XP and action times increase with level requirements.

### Items Added to Inventory
All hide items are categorized as `ItemData.ItemType.RAW_MATERIAL` and have escalating values:

**Common Hides** (5-55 gold):
- Rabbit Hide (5g)
- Chicken Hide (8g)
- Cowhide (10g)
- Bear Hide (15g)
- Wolf Hide (20g)
- Snake Skin (25g)
- Crocodile Hide (30g)
- Yak Hide (35g)
- Polar Bear Hide (40g)
- Lion Hide (45g)
- Tiger Hide (50g)
- Black Bear Hide (55g)

**Dragonhides** (100-500g):
- Blue Dragonhide (100g)
- Red Dragonhide (150g)
- Black Dragonhide (200g)
- Green Dragonhide (250g)
- Frost Dragonhide (350g)
- Royal Dragonhide (500g)

**Rare Materials** (750-1000g):
- Chimera Hide (750g)
- Phoenix Feather (1000g)

## File Changes

### New Files
1. **autoload/skills/skinning_skill.gd**: Skill definition with 20 training methods
2. **test/test_skinning.gd**: Comprehensive test suite
3. **test/test_skinning.tscn**: Test scene for running the test

### Modified Files
1. **autoload/game_manager.gd**: Added Skinning skill registration in `_load_skills()`
2. **autoload/inventory.gd**: Added 20 hide/skin items in `_load_items()`

## Testing
The test suite (`test/test_skinning.gd`) validates:
1. ✓ Skill is properly loaded and registered
2. ✓ Initial skill level is 1
3. ✓ All 20 training methods are defined correctly
4. ✓ All hide items exist in the inventory system
5. ✓ Basic skinning action (rabbit) works correctly
6. ✓ Higher-level skinning (cow) works correctly
7. ✓ No consumed items requirement
8. ✓ Each method produces exactly 1 item per action

## Design Rationale

### XP Curve
The XP progression follows a gentle exponential curve:
- Early levels (1-30): 10-70 XP per action
- Mid levels (35-60): 80-130 XP per action
- High levels (65-90): 140-225 XP per action

This balances with other gathering skills like Fishing and Woodcutting.

### Action Times
Action times increase from 2.5s (Chicken) to 9.5s (Phoenix):
- Faster than Woodcutting's high-level methods
- Comparable to Fishing's mid-tier methods
- Balanced for an active gathering skill

### Item Values
Item values are carefully balanced:
- Lower than processed items (smithing bars, cooked food)
- Higher than most raw gathering materials
- Dragonhides are premium materials (future Crafting use)

## Future Integration

### Crafting Skill
These hides are intended as materials for a future Crafting skill:
- **Leather Armor**: rabbit, cow, bear, wolf hides
- **Dragonhide Armor**: various dragonhides (green, blue, red, black)
- **Special Items**: exotic hides for unique crafted items
- **Phoenix Items**: phoenix feathers for high-tier magical equipment

### Potential Enhancements
1. **Critical Skins**: Rare chance to get 2x hides
2. **Bonus Drops**: Occasionally receive bones, meat, or teeth
3. **Speed Upgrades**: Purchasable skinning speed modifiers in UpgradeShop
4. **Tool System**: Different knives/scrapers for efficiency bonuses
5. **Area System**: Different locations with specific animal pools

## Code Example

```gdscript
# Starting skinning training
GameManager.start_training("skinning", "rabbit")

# Training automatically progresses via _process()
# Produces rabbit_hide items in inventory
# Grants XP based on training method

# Check progress
var level = GameManager.get_skill_level("skinning")
var xp = GameManager.get_skill_xp("skinning")
var hide_count = Inventory.get_item_count("rabbit_hide")

# Stop training
GameManager.stop_training()
```

## Compatibility
- ✓ Compatible with existing skill system
- ✓ Uses standard TrainingMethodData resource
- ✓ Follows RuneScape-style XP curve (1-99 levels)
- ✓ Integrates with Inventory autoload
- ✓ Works with offline progress calculation
- ✓ Compatible with UpgradeShop (ready for speed modifiers)

---

*Implementation Date*: December 2024  
*Version*: 1.0  
*Status*: Complete and Tested
