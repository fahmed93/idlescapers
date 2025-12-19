# Log Icons Implementation

## Overview
This document describes the implementation of icons for all 17 log types in IdleScapers.

## Generated Icons

All log icons are 64x64 PNG files with RGBA transparency, located in `assets/icons/items/`. Each icon features a cross-section view of a log with distinctive colors representing the wood type.

### Icon Files Created

| Log Type | File | Color Scheme |
|----------|------|--------------|
| Normal Logs | `logs.png` | Brown bark with lighter brown inner wood |
| Oak Logs | `oak_logs.png` | Tan/light brown |
| Willow Logs | `willow_logs.png` | Green-gray |
| Maple Logs | `maple_logs.png` | Orange-brown with golden highlights |
| Yew Logs | `yew_logs.png` | Dark red-brown |
| Magic Logs | `magic_logs.png` | Purple/mystical |
| Redwood Logs | `redwood_logs.png` | Reddish-brown |
| Achey Logs | `achey_logs.png` | Pale brown/burlywood |
| Teak Logs | `teak_logs.png` | Golden brown |
| Mahogany Logs | `mahogany_logs.png` | Rich reddish-brown |
| Arctic Pine Logs | `arctic_pine_logs.png` | Light steel blue/white |
| Eucalyptus Logs | `eucalyptus_logs.png` | Silver-gray |
| Elder Logs | `elder_logs.png` | Mystical white |
| Blisterwood Logs | `blisterwood_logs.png` | Dark purple/cursed |
| Bloodwood Logs | `bloodwood_logs.png` | Deep red/crimson |
| Crystal Logs | `crystal_logs.png` | Turquoise/shimmering |
| Spirit Logs | `spirit_logs.png` | Ethereal green |

## Implementation Details

### Icon Design
Each icon shows a circular cross-section of a log with:
- **Outer ring (bark)**: Main characteristic color
- **Inner wood**: Lighter shade of the bark color
- **Core**: Darker accent color
- **Radial texture lines**: 8 lines from core to inner wood for visual detail

### Code Changes

#### 1. Updated `Inventory._add_item()`
Added optional `icon_path` parameter to load icon textures:

```gdscript
func _add_item(id: String, display_name: String, desc: String, type: ItemData.ItemType, 
               value: int, equipment_slot: ItemData.EquipmentSlot = ItemData.EquipmentSlot.NONE, 
               icon_path: String = "") -> void:
    var item := ItemData.new()
    item.id = id
    item.name = display_name
    item.description = desc
    item.type = type
    item.value = value
    item.equipment_slot = equipment_slot
    if icon_path != "":
        item.icon = load(icon_path)
    items[id] = item
```

#### 2. Updated Log Item Definitions
All 17 log items now include icon paths:

```gdscript
_add_item("logs", "Logs", "Standard wooden logs.", ItemData.ItemType.RAW_MATERIAL, 5, 
          ItemData.EquipmentSlot.NONE, "res://assets/icons/items/logs.png")
_add_item("oak_logs", "Oak Logs", "Sturdy oak logs.", ItemData.ItemType.RAW_MATERIAL, 20, 
          ItemData.EquipmentSlot.NONE, "res://assets/icons/items/oak_logs.png")
// ... (15 more log types)
```

### Godot Import Files
Each PNG file has a corresponding `.import` file for Godot's asset pipeline with settings:
- Importer: `texture`
- Type: `CompressedTexture2D`
- Compression mode: 0 (lossless)
- No mipmaps
- RGBA channel mapping preserved

## Testing

A test scene was created at `test/test_log_icons.tscn` to verify:
- All 17 log items exist in the inventory system
- Each item has a non-null icon
- Icons are loaded as Texture2D objects

Run the test with:
```bash
godot --headless --path . test/test_log_icons.tscn
```

## Visual Preview

All 17 log icons displayed together:

![Log Icons Preview](https://github.com/user-attachments/assets/824289a7-f690-4ab1-85ae-5410d84c5907)

From left to right, top to bottom:
- Row 1: Normal, Oak, Willow, Maple, Yew
- Row 2: Magic, Redwood, Achey, Teak, Mahogany
- Row 3: Arctic Pine, Eucalyptus, Elder, Blisterwood, Bloodwood
- Row 4: Crystal, Spirit

## Future Enhancements

Potential improvements for the icon system:
1. Add icons for other item types (fish, ores, etc.)
2. Create higher resolution icons for different display contexts
3. Add item rarity borders or effects
4. Implement icon animations for special items
5. Add tooltips showing item icons in the UI

## Files Modified

- `autoload/inventory.gd` - Updated `_add_item()` signature and all log item definitions
- `assets/icons/items/*.png` - 17 new icon files
- `assets/icons/items/*.png.import` - 17 Godot import configuration files
- `test/test_log_icons.gd` - New test to verify icon loading
- `test/test_log_icons.tscn` - Test scene for icon verification

## Related

- Woodcutting skill: `autoload/skills/woodcutting_skill.gd`
- Firemaking skill: `autoload/skills/firemaking_skill.gd` (consumes logs)
- Fletching skill: `autoload/skills/fletching_skill.gd` (uses logs)
- Item data class: `resources/items/item_data.gd`
