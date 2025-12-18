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
	
	# Fletching materials
	_add_item("arrow_shafts", "Arrow Shafts", "Wooden shafts for arrows.", ItemData.ItemType.PROCESSED, 1)
	_add_item("feather", "Feather", "A feather for fletching arrows.", ItemData.ItemType.RAW_MATERIAL, 2)
	_add_item("bowstring", "Bowstring", "String for stringing bows.", ItemData.ItemType.PROCESSED, 10)
	_add_item("bronze_arrowhead", "Bronze Arrowhead", "A bronze arrowhead.", ItemData.ItemType.PROCESSED, 3)
	
	# Bows
	_add_item("shortbow", "Shortbow", "A basic shortbow.", ItemData.ItemType.TOOL, 50)
	_add_item("longbow", "Longbow", "A basic longbow.", ItemData.ItemType.TOOL, 100)
	_add_item("oak_shortbow", "Oak Shortbow", "A shortbow made of oak.", ItemData.ItemType.TOOL, 150)
	_add_item("oak_longbow", "Oak Longbow", "A longbow made of oak.", ItemData.ItemType.TOOL, 200)
	_add_item("willow_shortbow", "Willow Shortbow", "A shortbow made of willow.", ItemData.ItemType.TOOL, 300)
	_add_item("willow_longbow", "Willow Longbow", "A longbow made of willow.", ItemData.ItemType.TOOL, 400)
	_add_item("maple_shortbow", "Maple Shortbow", "A shortbow made of maple.", ItemData.ItemType.TOOL, 600)
	_add_item("maple_longbow", "Maple Longbow", "A longbow made of maple.", ItemData.ItemType.TOOL, 800)
	_add_item("yew_shortbow", "Yew Shortbow", "A shortbow made of yew.", ItemData.ItemType.TOOL, 1200)
	_add_item("yew_longbow", "Yew Longbow", "A longbow made of yew.", ItemData.ItemType.TOOL, 1600)
	_add_item("magic_shortbow", "Magic Shortbow", "A magical shortbow.", ItemData.ItemType.TOOL, 2500)
	_add_item("magic_longbow", "Magic Longbow", "A magical longbow.", ItemData.ItemType.TOOL, 3500)
	
	# Arrows
	_add_item("headless_arrow", "Headless Arrow", "An arrow without an arrowhead.", ItemData.ItemType.PROCESSED, 2)
	_add_item("bronze_arrow", "Bronze Arrow", "An arrow with a bronze tip.", ItemData.ItemType.PROCESSED, 5)

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
