## Inventory Autoload
## Manages player items and item data
extends Node

signal item_added(item_id: String, amount: int, new_total: int)
signal item_removed(item_id: String, amount: int, new_total: int)
signal inventory_updated()

## Item data registry
var items: Dictionary = {}  # item_id: ItemData

## Player inventory
var inventory: Dictionary = {}  # item_id: quantity

func _ready() -> void:
	_load_items()

## Load all item definitions
func _load_items() -> void:
	# Fish (raw)
	_add_item("raw_shrimp", "Raw Shrimp", "A small shrimp.", ItemData.ItemType.RAW_MATERIAL, 5)
	_add_item("raw_sardine", "Raw Sardine", "A small oily fish.", ItemData.ItemType.RAW_MATERIAL, 10)
	_add_item("raw_herring", "Raw Herring", "A silver fish.", ItemData.ItemType.RAW_MATERIAL, 15)
	_add_item("raw_trout", "Raw Trout", "A freshwater fish.", ItemData.ItemType.RAW_MATERIAL, 25)
	_add_item("raw_salmon", "Raw Salmon", "A large pink fish.", ItemData.ItemType.RAW_MATERIAL, 40)
	_add_item("raw_lobster", "Raw Lobster", "A valuable crustacean.", ItemData.ItemType.RAW_MATERIAL, 80)
	_add_item("raw_swordfish", "Raw Swordfish", "A large fish with a bill.", ItemData.ItemType.RAW_MATERIAL, 120)
	_add_item("raw_monkfish", "Raw Monkfish", "A strange looking fish.", ItemData.ItemType.RAW_MATERIAL, 180)
	_add_item("raw_shark", "Raw Shark", "An apex predator.", ItemData.ItemType.RAW_MATERIAL, 300)
	_add_item("raw_anglerfish", "Raw Anglerfish", "A deep sea fish.", ItemData.ItemType.RAW_MATERIAL, 500)
	
	# Fish (cooked)
	_add_item("cooked_shrimp", "Cooked Shrimp", "A tasty cooked shrimp.", ItemData.ItemType.CONSUMABLE, 10)
	_add_item("cooked_sardine", "Cooked Sardine", "A cooked sardine.", ItemData.ItemType.CONSUMABLE, 20)
	_add_item("cooked_herring", "Cooked Herring", "A cooked herring.", ItemData.ItemType.CONSUMABLE, 30)
	_add_item("cooked_trout", "Cooked Trout", "A cooked trout.", ItemData.ItemType.CONSUMABLE, 50)
	_add_item("cooked_salmon", "Cooked Salmon", "A cooked salmon.", ItemData.ItemType.CONSUMABLE, 80)
	_add_item("cooked_lobster", "Cooked Lobster", "A cooked lobster.", ItemData.ItemType.CONSUMABLE, 150)
	_add_item("cooked_swordfish", "Cooked Swordfish", "A cooked swordfish.", ItemData.ItemType.CONSUMABLE, 250)
	_add_item("cooked_monkfish", "Cooked Monkfish", "A cooked monkfish.", ItemData.ItemType.CONSUMABLE, 350)
	_add_item("cooked_shark", "Cooked Shark", "A cooked shark.", ItemData.ItemType.CONSUMABLE, 600)
	_add_item("cooked_anglerfish", "Cooked Anglerfish", "A cooked anglerfish.", ItemData.ItemType.CONSUMABLE, 1000)
	
	# Logs
	_add_item("logs", "Logs", "Standard wooden logs.", ItemData.ItemType.RAW_MATERIAL, 5)
	_add_item("oak_logs", "Oak Logs", "Sturdy oak logs.", ItemData.ItemType.RAW_MATERIAL, 20)
	_add_item("willow_logs", "Willow Logs", "Flexible willow logs.", ItemData.ItemType.RAW_MATERIAL, 40)
	_add_item("maple_logs", "Maple Logs", "Quality maple logs.", ItemData.ItemType.RAW_MATERIAL, 80)
	_add_item("yew_logs", "Yew Logs", "Valuable yew logs.", ItemData.ItemType.RAW_MATERIAL, 200)
	_add_item("magic_logs", "Magic Logs", "Magical logs.", ItemData.ItemType.RAW_MATERIAL, 500)
	_add_item("redwood_logs", "Redwood Logs", "Massive redwood logs.", ItemData.ItemType.RAW_MATERIAL, 1000)
	
	# Ores
	_add_item("copper_ore", "Copper Ore", "A basic ore used in bronze.", ItemData.ItemType.RAW_MATERIAL, 3)
	_add_item("tin_ore", "Tin Ore", "A basic ore used in bronze.", ItemData.ItemType.RAW_MATERIAL, 3)
	_add_item("iron_ore", "Iron Ore", "Common ore for iron and steel.", ItemData.ItemType.RAW_MATERIAL, 15)
	_add_item("coal", "Coal", "Used to smelt better ores.", ItemData.ItemType.RAW_MATERIAL, 25)
	_add_item("silver_ore", "Silver Ore", "Shiny ore for silver bars.", ItemData.ItemType.RAW_MATERIAL, 30)
	_add_item("gold_ore", "Gold Ore", "Precious ore for gold bars.", ItemData.ItemType.RAW_MATERIAL, 50)
	_add_item("mithril_ore", "Mithril Ore", "A rare blue ore.", ItemData.ItemType.RAW_MATERIAL, 100)
	_add_item("adamantite_ore", "Adamantite Ore", "A green ore of great strength.", ItemData.ItemType.RAW_MATERIAL, 200)
	_add_item("runite_ore", "Runite Ore", "The rarest and strongest ore.", ItemData.ItemType.RAW_MATERIAL, 500)
	
	# Bars
	_add_item("bronze_bar", "Bronze Bar", "A bar of bronze metal.", ItemData.ItemType.PROCESSED, 10)
	_add_item("iron_bar", "Iron Bar", "A bar of iron metal.", ItemData.ItemType.PROCESSED, 25)
	_add_item("steel_bar", "Steel Bar", "A bar of steel metal.", ItemData.ItemType.PROCESSED, 50)
	_add_item("silver_bar", "Silver Bar", "A bar of silver metal.", ItemData.ItemType.PROCESSED, 60)
	_add_item("gold_bar", "Gold Bar", "A bar of gold metal.", ItemData.ItemType.PROCESSED, 100)
	_add_item("mithril_bar", "Mithril Bar", "A bar of mithril metal.", ItemData.ItemType.PROCESSED, 200)
	_add_item("adamantite_bar", "Adamantite Bar", "A bar of adamantite metal.", ItemData.ItemType.PROCESSED, 400)
	_add_item("runite_bar", "Runite Bar", "A bar of runite metal.", ItemData.ItemType.PROCESSED, 1000)

## Helper to add item definition
func _add_item(id: String, display_name: String, desc: String, type: ItemData.ItemType, value: int) -> void:
	var item := ItemData.new()
	item.id = id
	item.name = display_name
	item.description = desc
	item.type = type
	item.value = value
	items[id] = item

## Get item data by ID
func get_item_data(item_id: String) -> ItemData:
	return items.get(item_id)

## Get current item count
func get_item_count(item_id: String) -> int:
	return inventory.get(item_id, 0)

## Add items to inventory
func add_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	
	var current: int = inventory.get(item_id, 0)
	inventory[item_id] = current + amount
	
	item_added.emit(item_id, amount, inventory[item_id])
	inventory_updated.emit()
	return true

## Remove items from inventory
func remove_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	
	var current: int = inventory.get(item_id, 0)
	if current < amount:
		return false
	
	inventory[item_id] = current - amount
	if inventory[item_id] <= 0:
		inventory.erase(item_id)
	
	item_removed.emit(item_id, amount, inventory.get(item_id, 0))
	inventory_updated.emit()
	return true

## Check if player has enough of an item
func has_item(item_id: String, amount: int = 1) -> bool:
	return get_item_count(item_id) >= amount

## Get all inventory items
func get_all_items() -> Dictionary:
	return inventory.duplicate()

## Clear all inventory
func clear_inventory() -> void:
	inventory.clear()
	inventory_updated.emit()

## Get total value of inventory
func get_total_value() -> int:
	var total := 0
	for item_id in inventory:
		var item_data := get_item_data(item_id)
		if item_data:
			total += item_data.value * inventory[item_id]
	return total
