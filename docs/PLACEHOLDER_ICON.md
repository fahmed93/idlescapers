# Placeholder Icon Feature

## Overview
Items without dedicated icon artwork now display a question mark placeholder icon in the inventory UI, providing visual consistency and making it clear which items lack custom artwork.

## Implementation Details

### Placeholder Icon
- **Location**: `assets/icons/items/placeholder.svg`
- **Format**: SVG (Scalable Vector Graphics)
- **Size**: 48x48 pixels (scalable)
- **Design**: Dark gray circular background with a light gray question mark symbol

### Code Changes
The placeholder icon is implemented in `scripts/main.gd`:

```gdscript
# Preload the placeholder icon as a constant
const PlaceholderIcon := preload("res://assets/icons/items/placeholder.svg")

# In _update_inventory_display():
var icon_texture := TextureRect.new()
if item_data and item_data.icon:
    icon_texture.texture = item_data.icon  # Use item's dedicated icon
else:
    icon_texture.texture = PlaceholderIcon  # Use placeholder
```

## Behavior

### Before
- Items with dedicated icons: Displayed their icon
- Items without icons: No icon displayed (text only)

### After
- Items with dedicated icons: Display their icon (unchanged)
- Items without icons: Display the question mark placeholder icon

## Testing

### Automated Test
Run `test/test_inventory_icon_display.tscn` to verify:
- Items with icons load correctly
- Items without icons have `null` icon property (placeholder used in UI)
- No crashes or errors occur

### Manual Verification
Run `test/manual_verify_inventory_icons.tscn` and:
1. Navigate to the Inventory view
2. Verify log items show their specific icons
3. Verify fish items (without dedicated icons) show the question mark placeholder
4. Verify all items are clickable and functional

## Adding New Icons

To add a dedicated icon for an item:

1. Create a 48x48+ pixel icon (PNG or SVG recommended)
2. Place it in `assets/icons/items/`
3. Update the item definition in `autoload/inventory.gd`:

```gdscript
_add_item("item_id", "Item Name", "Description", ItemData.ItemType.RAW_MATERIAL, 
          value, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/item_icon.png")
```

If no icon path is provided, the placeholder will be used automatically.

## Design Rationale

1. **Visual Consistency**: All inventory slots now have an icon, creating a more uniform appearance
2. **Clear Communication**: The question mark clearly indicates "no custom icon available"
3. **No Errors**: Eliminates potential null reference issues in UI code
4. **Minimal Changes**: Single preloaded asset, simple conditional logic
5. **Scalability**: SVG format ensures the icon looks good at any size
