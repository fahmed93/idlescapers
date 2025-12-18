## Store Autoload
## Manages player gold and item selling
extends Node

signal gold_changed(new_amount: int)
signal item_sold(item_id: String, amount: int, gold_earned: int)

## Player gold
var gold: int = 0

## Get current gold amount
func get_gold() -> int:
	return gold

## Add gold
func add_gold(amount: int) -> void:
	if amount <= 0:
		return
	
	gold += amount
	gold_changed.emit(gold)

## Remove gold (for future shop purchases)
func remove_gold(amount: int) -> bool:
	if amount <= 0:
		return false
	
	if gold < amount:
		return false
	
	gold -= amount
	gold_changed.emit(gold)
	return true

## Check if player has enough gold
func has_gold(amount: int) -> bool:
	return gold >= amount

## Sell an item from inventory
func sell_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	
	# Check if player has the item
	if not Inventory.has_item(item_id, amount):
		return false
	
	# Get item data to determine value
	var item_data := Inventory.get_item_data(item_id)
	if item_data == null:
		return false
	
	# Calculate total value
	var gold_earned := item_data.value * amount
	
	# Remove item from inventory
	if Inventory.remove_item(item_id, amount):
		add_gold(gold_earned)
		item_sold.emit(item_id, amount, gold_earned)
		return true
	
	return false

## Sell all of a specific item
func sell_all(item_id: String) -> bool:
	var count := Inventory.get_item_count(item_id)
	if count <= 0:
		return false
	
	return sell_item(item_id, count)
