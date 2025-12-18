# Foraging Skill Implementation

## Overview
The Foraging skill has been successfully implemented for IdleScapers. This skill allows players to gather dirty herbs from the wilderness, which serve as the raw material source for the Herblore skill.

## What Was Implemented

### 1. Foraging Skill (`autoload/skills/foraging_skill.gd`)
Created a new skill file containing 14 training methods (herb gathering):

#### Herbs by Level:
- **Level 1**: Dirty Guam Leaf (8 XP, 2.5s)
- **Level 5**: Dirty Marrentill (10 XP, 2.8s)
- **Level 11**: Dirty Tarromin (12 XP, 3.0s)
- **Level 20**: Dirty Harralander (15 XP, 3.2s)
- **Level 25**: Dirty Ranarr Weed (20 XP, 3.5s)
- **Level 30**: Dirty Toadflax (25 XP, 3.8s)
- **Level 40**: Dirty Irit Leaf (35 XP, 4.0s)
- **Level 48**: Dirty Avantoe (45 XP, 4.2s)
- **Level 54**: Dirty Kwuarm (55 XP, 4.5s)
- **Level 59**: Dirty Snapdragon (70 XP, 4.8s)
- **Level 65**: Dirty Cadantine (85 XP, 5.0s)
- **Level 67**: Dirty Lantadyme (95 XP, 5.2s)
- **Level 70**: Dirty Dwarf Weed (110 XP, 5.5s)
- **Level 75**: Dirty Torstol (150 XP, 6.0s)

### 2. Skill Registration (`autoload/game_manager.gd`)
- Registered Foraging skill with ID "foraging"
- Set skill color to earthy green (0.45, 0.6, 0.3)
- Initialized skill XP and level tracking
- Loaded training methods from foraging_skill.gd

### 3. Items Added (`autoload/inventory.gd`)

#### Dirty Herbs (14 total):
All dirty herbs are added as RAW_MATERIAL type:
- dirty_guam_leaf (value: 5)
- dirty_marrentill (value: 7)
- dirty_tarromin (value: 9)
- dirty_harralander (value: 11)
- dirty_ranarr_weed (value: 18)
- dirty_toadflax (value: 22)
- dirty_irit_leaf (value: 30)
- dirty_avantoe (value: 38)
- dirty_kwuarm (value: 50)
- dirty_snapdragon (value: 65)
- dirty_cadantine (value: 75)
- dirty_lantadyme (value: 90)
- dirty_dwarf_weed (value: 105)
- dirty_torstol (value: 150)

Dirty herb values are set slightly lower than their clean counterparts to reflect their unprocessed state.

### 4. Testing (`test/test_foraging.gd` and `test/test_foraging.tscn`)
Created comprehensive test suite that validates:
- Skill is properly registered
- All 14 training methods load correctly
- Specific methods have correct level requirements
- All dirty herb items are registered
- Training simulation works (can gather herbs and gain XP)
- Each foraging method produces exactly one dirty herb
- All produced items are dirty herbs (start with "dirty_")

## Technical Details

### Files Modified:
1. `autoload/game_manager.gd` - Added Foraging skill registration
2. `autoload/inventory.gd` - Added 14 new dirty herb items

### Files Created:
1. `autoload/skills/foraging_skill.gd` - Skill definition with 14 training methods
2. `test/test_foraging.gd` - Test script
3. `test/test_foraging.tscn` - Test scene
4. `docs/FORAGING_IMPLEMENTATION.md` - This documentation

### Design Patterns Followed:
- Static `create_methods()` function returning `Array[TrainingMethodData]`
- Skill color theme (earthy green for Foraging)
- Produced items pattern for gathering
- Item type classification (RAW_MATERIAL for dirty herbs)
- XP scaling appropriate to level requirements
- Action times progressively increase with level
- Level requirements align loosely with Herblore requirements

## Integration with Herblore

The Foraging skill provides the raw material input for the Herblore skill:

```
Foraging (gather) → Dirty Herbs → [Future: Cleaning] → Clean Herbs → Herblore (potions)
```

Currently, the clean herbs (guam_leaf, marrentill, etc.) are still directly available in the inventory system. A future enhancement could:
1. Add a cleaning mechanic (possibly in Herblore itself)
2. Convert dirty herbs to clean herbs
3. Remove direct access to clean herbs, making foraging essential

## Validation
✅ All files created with correct structure
✅ All referenced items are registered in inventory (14 dirty herbs)
✅ Follows established code patterns from other skills
✅ Test suite created for validation
✅ Level progression covers early to late game (1-75)
✅ XP rates balanced relative to action times

## Integration
The Foraging skill is now fully integrated into the game:
- Players can select Foraging from the skills menu
- Training methods display with level requirements
- Dirty herbs can be gathered when player has required level
- XP is gained when gathering herbs
- Levels unlock new herb types up to level 75

## Future Enhancements (Optional)
- Add herb cleaning mechanic (convert dirty → clean herbs)
- Add rare herb drops or special gathering nodes
- Add seasonal or weather-based herb availability
- Add foraging tools that increase gathering speed
- Add rare secondary materials (seeds, berries, etc.)
- Make clean herbs only obtainable through cleaning dirty herbs
- Add XP for cleaning herbs (could be in Herblore skill)
