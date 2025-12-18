# Upgrades Shop Implementation Summary

## Overview
This implementation adds an "upgrades shop" feature where players can purchase upgrades that improve skill training speed. Each upgrade has a skill level requirement and applies a percentage-based speed modifier to that skill's training actions.

## Components Added

### 1. UpgradeData Resource (`resources/upgrades/upgrade_data.gd`)
- Custom Resource class defining upgrade properties
- Properties:
  - `id`: Unique identifier
  - `name`: Display name
  - `description`: Description text
  - `skill_id`: Which skill the upgrade applies to
  - `level_required`: Minimum skill level to purchase
  - `cost`: Gold cost to purchase
  - `speed_modifier`: Percentage faster (0.1 = 10% faster)
- Helper method: `get_stats_text()` for UI display

### 2. UpgradeShop Autoload (`autoload/upgrade_shop.gd`)
- Global singleton managing upgrades
- Pre-loaded upgrades for all skills:
  - **Fishing**: 4 tiers of fishing rods (10% to 50% speed)
  - **Woodcutting**: 5 tiers of axes (10% to 60% speed)
  - **Mining**: 5 tiers of pickaxes (10% to 60% speed)
  - **Cooking**: 3 tiers of cooking equipment (10% to 35% speed)
  - **Fletching**: 3 tiers of tools (10% to 40% speed)
  - **Firemaking**: 3 tiers of tools (10% to 50% speed)

- Key methods:
  - `get_upgrades_for_skill(skill_id)`: Get all upgrades for a skill
  - `is_purchased(upgrade_id)`: Check if upgrade is owned
  - `purchase_upgrade(upgrade_id)`: Buy an upgrade (validates level and gold)
  - `get_skill_speed_modifier(skill_id)`: Get total speed bonus for a skill

### 3. GameManager Updates (`autoload/game_manager.gd`)
- Modified `_process()` to apply speed modifiers:
  ```gdscript
  var speed_modifier := UpgradeShop.get_skill_speed_modifier(current_skill_id)
  var modified_delta := delta * (1.0 + speed_modifier)
  training_progress += modified_delta
  ```
- Speed modifiers stack additively (e.g., 10% + 20% = 30% faster)

### 4. SaveManager Updates (`autoload/save_manager.gd`)
- Added `purchased_upgrades` to save data
- Restores purchased upgrades on load
- Applied speed modifiers to offline progress calculation:
  ```gdscript
  var speed_modifier := UpgradeShop.get_skill_speed_modifier(skill_id)
  var effective_time := time_away * (1.0 + speed_modifier)
  ```

### 5. UI Implementation (`scripts/main.gd`)
- Added "Upgrades" button to skill sidebar
- Created upgrades shop panel with:
  - Gold display
  - Upgrades grouped by skill
  - Each upgrade shows:
    - Name (with checkmark if owned)
    - Description
    - Stats (level requirement, cost, speed bonus)
    - Purchase button (disabled if owned, locked, or insufficient gold)
- Added speed bonus indicator to training method displays
  - Shows "+X% Speed Bonus" in green when upgrades are active

### 6. Project Configuration (`project.godot`)
- Registered UpgradeShop as autoload singleton

## How It Works

### Purchase Flow
1. Player navigates to Upgrades shop
2. Upgrades are grouped by skill with color-coded headers
3. Player clicks "Buy" button (if requirements met)
4. Gold is deducted via Store.remove_gold()
5. Upgrade is added to purchased_upgrades array
6. Speed modifier is immediately applied to training

### Speed Calculation
- Base action time: 3.0 seconds
- With 10% upgrade: 3.0 / 1.10 = 2.73 seconds effective
- With 30% upgrades: 3.0 / 1.30 = 2.31 seconds effective
- Formula: `effective_time = base_time / (1.0 + speed_modifier)`

### Stacking
- Multiple upgrades for the same skill stack additively
- Example: Basic Rod (10%) + Steel Rod (20%) = 30% total bonus
- This is calculated in `get_skill_speed_modifier()`

## Testing

A test script (`test/test_upgrades.gd`) was created to verify:
1. Upgrades load correctly
2. Upgrade properties are correct
3. Purchase validation works (insufficient gold fails)
4. Purchase with gold succeeds
5. Speed modifiers calculate correctly
6. Multiple upgrades stack properly
7. Save/load persists purchased upgrades

## Usage Examples

### For Players
1. Train a skill to earn gold (sell items at Store)
2. Open Upgrades shop from sidebar
3. Purchase upgrades when you have enough gold and level
4. Training becomes faster automatically

### For Developers
```gdscript
# Get current speed bonus for a skill
var bonus = UpgradeShop.get_skill_speed_modifier("fishing")  # Returns 0.0 to 1.0+

# Check if upgrade is owned
if UpgradeShop.is_purchased("bronze_axe"):
    print("Player has bronze axe")

# Get all fishing upgrades
var fishing_upgrades = UpgradeShop.get_upgrades_for_skill("fishing")
```

## Future Enhancements
- Add upgrade icons
- Add sound effects for purchases
- Add upgrade categories (tools, equipment, perks)
- Add temporary boost upgrades
- Add prestige upgrades that unlock at max level
- Add upgrade requirements beyond gold (e.g., items needed)
