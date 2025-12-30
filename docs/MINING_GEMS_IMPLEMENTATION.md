# Mining Gem Finding Feature

## Overview
This implementation adds a random chance to find gems when performing mining actions in SkillForge Idle. Higher tier gems have lower drop chances, creating a rarity system.

## Changes Made

### 1. New Gem Items (autoload/inventory.gd)
Added four gem items with increasing rarity and value:
- **Sapphire**: 100 gold value - "A brilliant blue gem"
- **Emerald**: 200 gold value - "A lustrous green gem"
- **Ruby**: 400 gold value - "A precious red gem"
- **Diamond**: 800 gold value - "A rare and valuable gem"

### 2. Bonus Items System (resources/skills/training_method_data.gd)
Added a new property to TrainingMethodData:
```gdscript
@export var bonus_items: Dictionary = {}  # item_id: chance (0.0 to 1.0) for random bonus items
```

This dictionary maps item IDs to their drop chance (as a float between 0.0 and 1.0).

### 3. Game Manager Logic (autoload/game_manager.gd)
Updated `_complete_action()` to process bonus items:
```gdscript
# Check for bonus items on success (independent random roll for each)
if success and not method.bonus_items.is_empty():
    for item_id in method.bonus_items:
        var chance: float = method.bonus_items[item_id]
        if randf() <= chance:
            Inventory.add_item(item_id, 1)
```

Each bonus item gets its own independent random roll, and they only drop on successful actions.

### 4. Mining Skill Updates (autoload/skills/mining_skill.gd)
All mining methods now have gem drop chances:
```gdscript
method.bonus_items = {
    "sapphire": 0.01,   # 1% chance
    "emerald": 0.005,   # 0.5% chance
    "ruby": 0.002,      # 0.2% chance
    "diamond": 0.001    # 0.1% chance
}
```

This applies to all mining methods:
- Copper Ore (Level 1)
- Tin Ore (Level 1)
- Iron Ore (Level 15)
- Silver Ore (Level 20)
- Coal (Level 30)
- Gold Ore (Level 40)
- Mithril Ore (Level 55)
- Adamantite Ore (Level 70)
- Runite Ore (Level 85)

### 5. Test Suite (test/test_mining_gems.gd)
Created a comprehensive test that verifies:
- Mining skill registration
- Gem items registration
- Bonus items configuration on mining methods
- Gem rarity (higher tier = lower chance)
- Actual gem drops during mining simulation (1000 actions)

## Drop Rates
The gem drop system uses independent probability rolls:
- **Sapphire**: 1 in 100 actions (1%)
- **Emerald**: 1 in 200 actions (0.5%)
- **Ruby**: 1 in 500 actions (0.2%)
- **Diamond**: 1 in 1000 actions (0.1%)

Expected drops per 1000 mining actions:
- ~10 Sapphires
- ~5 Emeralds
- ~2 Rubies
- ~1 Diamond

## Design Decisions

1. **Independent Rolls**: Each gem has its own random roll, so theoretically you could get multiple gems from a single action (though very unlikely).

2. **Success-Based**: Gems only drop on successful mining actions. Since mining has 100% success rate by default, this means you'll always get ore + chance for gems.

3. **Equal Chances Across Ore Types**: All mining methods have the same gem drop chances, regardless of ore tier. This keeps the system simple and consistent.

4. **Rarity Progression**: Diamond is 10x rarer than Sapphire, creating a clear rarity hierarchy that matches the value progression (800g vs 100g).

## Testing

Run the test scene in Godot:
1. Open `test/test_mining_gems.tscn` in the Godot editor
2. Run the scene (F6)
3. Check the console output for test results

The test simulates 1000 mining actions and verifies that gems are found at the expected rates.

## Future Enhancements

Potential improvements that could be added later:
- Different gem drop rates for different ore tiers (higher level ores = better gems)
- Additional gem types (e.g., opal, jade, dragonstone)
- Gem-specific mining spots
- Crafting system to use gems
- Achievement system for finding rare gems
