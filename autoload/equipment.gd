## Equipment Autoload
## Manages equipped items for the player character
extends Node

signal equipment_changed(slot: ItemData.EquipmentSlot)
signal item_equipped(slot: ItemData.EquipmentSlot, item_id: String)
signal item_unequipped(slot: ItemData.EquipmentSlot, item_id: String)

## Dictionary mapping slot enum to equipped item_id
var equipped_items: Dictionary = {}  # EquipmentSlot: item_id

func _ready() -> void:
	# Initialize all slots as empty
	for slot in ItemData.EquipmentSlot.values():
		if slot != ItemData.EquipmentSlot.NONE:
			equipped_items[slot] = ""

## Equip an item to a slot
## Returns true if successful, false otherwise
func equip_item(item_id: String) -> bool:
	var item_data := Inventory.get_item_data(item_id)
	if item_data == null:
		push_error("Cannot equip unknown item: %s" % item_id)
		return false
	
	if item_data.equipment_slot == ItemData.EquipmentSlot.NONE:
		push_error("Item %s is not equippable" % item_id)
		return false
	
	# Check if player has the item
	if not Inventory.has_item(item_id, 1):
		push_error("Player does not have item: %s" % item_id)
		return false
	
	var slot := item_data.equipment_slot
	
	# Handle ring slot specially (has two ring slots)
	if slot == ItemData.EquipmentSlot.RING:
		slot = _get_available_ring_slot()
		if slot == ItemData.EquipmentSlot.NONE:
			push_error("Both ring slots are occupied")
			return false
	
	# Unequip current item in slot if any
	if equipped_items.get(slot, "") != "":
		unequip_item(slot)
	
	# Remove from inventory (equipment items are not stackable in slots)
	if not Inventory.remove_item(item_id, 1):
		return false
	
	# Equip the item
	equipped_items[slot] = item_id
	item_equipped.emit(slot, item_id)
	equipment_changed.emit(slot)
	
	print("[Equipment] Equipped %s to slot %d" % [item_id, slot])
	return true

## Unequip an item from a slot
## Returns true if successful, false otherwise
func unequip_item(slot: ItemData.EquipmentSlot) -> bool:
	if slot == ItemData.EquipmentSlot.NONE:
		return false
	
	var item_id: String = equipped_items.get(slot, "")
	if item_id == "":
		return false
	
	# Add back to inventory
	Inventory.add_item(item_id, 1)
	
	# Unequip the item
	equipped_items[slot] = ""
	item_unequipped.emit(slot, item_id)
	equipment_changed.emit(slot)
	
	print("[Equipment] Unequipped %s from slot %d" % [item_id, slot])
	return true

## Get the item ID equipped in a slot
func get_equipped_item(slot: ItemData.EquipmentSlot) -> String:
	return equipped_items.get(slot, "")

## Check if an item is equipped
func is_item_equipped(item_id: String) -> bool:
	for slot in equipped_items:
		if equipped_items[slot] == item_id:
			return true
	return false

## Get the slot where an item is equipped (or NONE if not equipped)
func get_equipped_slot(item_id: String) -> ItemData.EquipmentSlot:
	for slot in equipped_items:
		if equipped_items[slot] == item_id:
			return slot
	return ItemData.EquipmentSlot.NONE

## Helper to find an available ring slot
## Returns RING (slot 5) or NONE if both slots are full
func _get_available_ring_slot() -> ItemData.EquipmentSlot:
	# We'll use slot RING (5) as first ring slot
	# For second ring, we need to track it separately
	# Let's use a simple approach: check if RING slot is empty first
	if equipped_items.get(ItemData.EquipmentSlot.RING, "") == "":
		return ItemData.EquipmentSlot.RING
	# For simplicity, we'll only support one ring for now
	# Can be extended later to support ring1/ring2
	return ItemData.EquipmentSlot.NONE

## Get all equipped items as a dictionary
func get_all_equipped() -> Dictionary:
	return equipped_items.duplicate()

## Clear all equipped items (returns them to inventory)
func unequip_all() -> void:
	for slot in equipped_items.keys():
		if equipped_items[slot] != "":
			unequip_item(slot)

## Serialize equipment data for saving
func to_dict() -> Dictionary:
	var data := {}
	for slot in equipped_items:
		data[str(slot)] = equipped_items[slot]
	return data

## Load equipment data from saved data
func from_dict(data: Dictionary) -> void:
	equipped_items.clear()
	for slot_str in data:
		var slot: int = int(slot_str)
		equipped_items[slot] = data[slot_str]
	
	# Ensure all slots exist
	for slot in ItemData.EquipmentSlot.values():
		if slot != ItemData.EquipmentSlot.NONE and not equipped_items.has(slot):
			equipped_items[slot] = ""
