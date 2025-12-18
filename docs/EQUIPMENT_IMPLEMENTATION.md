# Equipment System Implementation

## Overview
The equipment system allows players to equip items to their character in designated slots, providing a foundation for future stat bonuses and gameplay enhancements.

## Architecture

### Equipment Slots
The game supports 11 equipment slots:
- **Helm** - Head protection (helmets, cowls)
- **Necklace** - Neck jewelry
- **Chest** - Body armor (platebodies, leather bodies)
- **Gloves** - Hand protection (gloves, vambraces)
- **Ring 1** - First ring slot
- **Ring 2** - Second ring slot
- **Main Hand** - Primary weapon (swords, daggers, bows)
- **Off Hand** - Secondary weapon or shield
- **Legs** - Leg armor (platelegs, chaps)
- **Arrows** - Ammunition for ranged weapons
- **Boots** - Foot protection

### Data Model

#### ItemData Resource Extension
```gdscript
enum EquipmentSlot { 
    NONE,
    HELM, NECKLACE, CHEST, GLOVES, 
    RING_1, RING_2, 
    MAIN_HAND, OFF_HAND, 
    LEGS, ARROWS, BOOTS,
    RING = RING_1  # Alias for items that can go in either ring slot
}

@export var equipment_slot: EquipmentSlot = EquipmentSlot.NONE
```

#### Equipment Autoload
Located at `autoload/equipment.gd`, manages:
- Equipped items dictionary (slot → item_id mapping)
- Equip/unequip operations with validation
- Save/load serialization
- Signal emissions for UI updates

### Key Functions

#### Equipment.equip_item(item_id: String) → bool
- Validates item exists and is equippable
- Checks player has item in inventory
- Handles special ring slot logic (fills first available slot)
- Auto-unequips existing item in target slot
- Removes item from inventory
- Emits `item_equipped` and `equipment_changed` signals

#### Equipment.unequip_item(slot: EquipmentSlot) → bool
- Returns equipped item to inventory
- Clears slot
- Emits `item_unequipped` and `equipment_changed` signals

#### Equipment.get_equipped_item(slot: EquipmentSlot) → String
- Returns item_id of equipped item or empty string

### Integration Points

#### Save System
Equipment data is serialized as part of save files:
```gdscript
{
    "equipment": {
        "1": "bronze_full_helm",
        "3": "bronze_platebody",
        ...
    }
}
```

#### Inventory Integration
- Equipped items are removed from inventory
- Unequipping returns items to inventory
- Item detail popup shows equip/unequip buttons for equippable items

#### UI Components

**Equipment Tab** (`scripts/main.gd`)
- Accessible from sidebar button
- Displays all 11 equipment slots in a human-shaped layout
- Slot positioning mimics a character's body:
  - Helm at top (head)
  - Necklace below helm (neck area)
  - Main Hand (left), Chest (center), Off Hand (right) in middle row
  - Gloves below chest (hands)
  - Ring 1 and Ring 2 symmetrically below gloves
  - Legs in lower section
  - Boots at bottom (feet)
  - Arrows positioned on right side (back/quiver)
- Shows equipped item name or "Empty"
- Clickable slots to unequip items (disabled when empty)

**Item Detail Popup** (`scripts/item_detail_popup.gd`)
- Shows equipment slot for equippable items
- Displays equip button (disabled if already equipped)
- Displays unequip button (disabled if not equipped)

## Equippable Items

### Weapons (Main Hand)
- **Daggers**: bronze → iron → steel → mithril → adamantite → runite
- **Swords**: bronze → iron → steel → mithril → adamantite → runite
- **Scimitars**: bronze → iron → steel → mithril → adamantite → runite
- **Bows**: shortbow, longbow (regular, oak, willow, maple, yew, magic)

### Armor (Metal)
- **Helms**: bronze_full_helm → iron → steel → mithril → adamantite → runite
- **Platebodies**: bronze → iron → steel → mithril → adamantite → runite (chest slot)
- **Platelegs**: bronze → iron → steel → mithril → adamantite → runite

### Armor (Leather/Hide)
- **Gloves**: leather_gloves, leather_vambraces, dragonhide vambraces (all tiers)
- **Boots**: leather_boots
- **Chest**: leather_body, hard_leather_body, studded_body, snake_skin_body, dragonhide bodies (all tiers)
- **Legs**: leather_chaps, studded_chaps, snake_skin_chaps, dragonhide chaps (all tiers)
- **Helm**: leather_cowl

### Jewelry
- **Rings**: sapphire, emerald, ruby, diamond, dragonstone, onyx (can equip 2)
- **Necklaces**: sapphire, emerald, ruby, diamond, dragonstone, onyx

### Ammunition
- **Arrows**: headless_arrow, bronze_arrow (arrows slot)

## Usage Examples

### Equipping Items from Inventory
```gdscript
# Player clicks item in inventory, opens detail popup
# Clicks "Equip" button
Equipment.equip_item("bronze_sword")  # → true if successful
```

### Unequipping from Equipment Screen
```gdscript
# Player clicks "Unequip" button in equipment slot
Equipment.unequip_item(ItemData.EquipmentSlot.MAIN_HAND)  # → true if successful
```

### Checking Equipment Status
```gdscript
# Check if player has weapon equipped
var weapon := Equipment.get_equipped_item(ItemData.EquipmentSlot.MAIN_HAND)
if weapon != "":
    print("Wielding: " + weapon)

# Check if specific item is equipped anywhere
if Equipment.is_item_equipped("runite_platebody"):
    print("Wearing runite platebody")
```

## Testing

Test coverage includes:
- Equipping and unequipping items
- Slot validation
- Inventory integration
- Ring slot special handling (2 slots)
- Item replacement in slots
- Save/load persistence

Run tests with:
```bash
godot --headless test/test_equipment.tscn
```

## Future Enhancements

### Potential Features
1. **Stat Bonuses**: Equipment provides combat/skill bonuses
2. **Equipment Requirements**: Level requirements to equip items
3. **Set Bonuses**: Bonuses for wearing complete armor sets
4. **Weapon Types**: Different weapon categories (melee, ranged, magic)
5. **Two-Handed Weapons**: Weapons that occupy both hands
6. **Shields**: Off-hand defensive items
7. **Equipment Presets**: Save and quickly swap equipment loadouts
8. **Visual Representation**: Character sprite showing equipped items

### Technical Debt
- Consider adding equipment slot validation beyond basic checks
- Add animation/transitions for equip/unequip actions
- Implement equipment comparison UI
- Add tooltip showing item stats when hovering over slots

## Files Modified/Created

### New Files
- `autoload/equipment.gd` - Equipment management autoload
- `test/test_equipment.gd` - Comprehensive equipment tests
- `test/test_equipment.tscn` - Test scene
- `docs/EQUIPMENT_IMPLEMENTATION.md` - This file

### Modified Files
- `resources/items/item_data.gd` - Added EquipmentSlot enum and equipment_slot field
- `autoload/inventory.gd` - Updated item definitions with equipment slots
- `autoload/save_manager.gd` - Added equipment save/load
- `scripts/main.gd` - Added equipment UI tab and functionality
- `scripts/item_detail_popup.gd` - Added equip/unequip buttons
- `project.godot` - Registered Equipment autoload

## Signal Reference

### Equipment Signals
```gdscript
signal equipment_changed(slot: ItemData.EquipmentSlot)
signal item_equipped(slot: ItemData.EquipmentSlot, item_id: String)
signal item_unequipped(slot: ItemData.EquipmentSlot, item_id: String)
```

Connect to these signals to update UI or apply stat bonuses when equipment changes.
