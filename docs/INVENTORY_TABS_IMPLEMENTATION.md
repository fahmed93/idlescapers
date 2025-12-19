# Inventory Tabs Implementation

## Overview
The Inventory Tabs feature allows players to organize their items across multiple tabs, making it easier to manage large inventories. Players can drag and drop items between tabs, create custom tabs, and rename or delete them as needed.

## Features

### Tab Management
- **Main Tab**: Always present and cannot be deleted. Contains the player's primary inventory.
- **Custom Tabs**: Players can create up to 10 total tabs (including the main tab).
- **Tab Creation**: Click the "+" button next to the tab bar to create a new tab.
- **Tab Renaming**: Right-click on any custom tab and select "Rename" to change its name.
- **Tab Deletion**: Right-click on any custom tab and select "Delete" to remove it. Items in deleted tabs are automatically moved to the Main tab.

### Drag and Drop
- **Drag Items**: Click and hold on any item to start dragging it.
- **Visual Feedback**: A preview of the item follows the mouse cursor while dragging.
- **Drop on Tabs**: Release the mouse button while hovering over a tab button to move the item to that tab.
- **Move All**: When an item is moved, all of that item type in the source tab is moved to the destination tab.

### Persistence
- Tab configuration and item distribution are automatically saved.
- Tabs are restored when loading a saved game.
- Backward compatible with old save files (creates default tab structure on first load).

## Architecture

### Data Structure (Inventory Autoload)

```gdscript
# Tab storage
var tabs: Dictionary = {}  # tab_id: { name: String, items: Dictionary }
var tab_order: Array[String] = []  # Ordered list of tab IDs
const MAIN_TAB_ID := "main"
const MAX_TABS := 10
```

Each tab contains:
- `name`: Display name of the tab
- `items`: Dictionary mapping item_id to quantity

### Key Functions

#### Tab Management
```gdscript
# Create a new tab
func create_tab(tab_name: String) -> String

# Delete a tab (cannot delete main tab)
func delete_tab(tab_id: String) -> bool

# Rename a tab
func rename_tab(tab_id: String, new_name: String) -> bool

# Get tab name
func get_tab_name(tab_id: String) -> String
```

#### Item Management
```gdscript
# Add item to specific tab
func add_item_to_tab(tab_id: String, item_id: String, amount: int = 1) -> bool

# Remove item from specific tab
func remove_item_from_tab(tab_id: String, item_id: String, amount: int = 1) -> bool

# Move item between tabs
func move_item_between_tabs(item_id: String, from_tab: String, to_tab: String, amount: int = 1) -> bool

# Get items in a tab
func get_tab_items(tab_id: String) -> Dictionary

# Get item count in a tab
func get_item_count_in_tab(tab_id: String, item_id: String) -> int
```

### Signals

```gdscript
signal tab_created(tab_id: String, tab_name: String)
signal tab_deleted(tab_id: String)
signal tab_renamed(tab_id: String, new_name: String)
signal item_moved_between_tabs(item_id: String, from_tab: String, to_tab: String)
```

## UI Components

### Tab Bar
Located at the top of the inventory view, the tab bar contains:
- Tab buttons for each created tab (scrollable if many tabs)
- "+" button to create new tabs
- Visual indication of the currently selected tab

### Context Menu
Right-clicking on custom tabs shows a popup menu with:
- **Rename**: Opens a dialog to rename the tab
- **Delete**: Removes the tab and moves its items to Main tab

### Drag Preview
When dragging an item:
- A semi-transparent panel shows the item icon and name
- Follows the mouse cursor
- Disappears when the item is dropped or drag is cancelled

## Save Format

```json
{
  "inventory_tabs": {
    "main": {
      "name": "Main",
      "items": {
        "raw_shrimp": 50,
        "cooked_salmon": 30
      }
    },
    "tab_1": {
      "name": "Fish",
      "items": {
        "raw_trout": 20
      }
    }
  },
  "inventory_tab_order": ["main", "tab_1"]
}
```

## Backward Compatibility

The system maintains backward compatibility with existing save files:
1. The legacy `inventory` field is still saved for older versions
2. On load, if `inventory_tabs` is not present, the system initializes with a main tab containing the legacy inventory
3. The main tab's items dictionary is always a reference to the legacy `inventory` dictionary

## Usage Examples

### Creating a Tab
```gdscript
var new_tab_id = Inventory.create_tab("My Custom Tab")
if not new_tab_id.is_empty():
    print("Tab created with ID: ", new_tab_id)
```

### Moving Items
```gdscript
# Move 10 shrimp from main to custom tab
if Inventory.move_item_between_tabs("raw_shrimp", Inventory.MAIN_TAB_ID, "tab_1", 10):
    print("Items moved successfully")
```

### Checking Tab Contents
```gdscript
var items = Inventory.get_tab_items("tab_1")
for item_id in items:
    print("%s: %d" % [item_id, items[item_id]])
```

## Testing

Run the inventory tabs test suite:
```bash
godot --headless --path . test/test_inventory_tabs.tscn
```

The test covers:
- Tab creation and deletion
- Item distribution across tabs
- Moving items between tabs
- Tab renaming
- Edge cases (max tabs, invalid operations, etc.)

## Known Limitations

1. Maximum of 10 tabs to prevent UI clutter
2. When moving items, all of that item type is moved (no partial stack splitting)
3. Main tab cannot be deleted or moved in the tab order
4. Tab names are not validated for length or special characters

## Future Enhancements

Potential improvements for future versions:
- Drag to reorder tabs
- Tab icons/colors for better organization
- Auto-sort items within tabs
- Quick-move buttons (move all items of type)
- Tab templates/presets
- Split stack functionality (move partial quantities)
