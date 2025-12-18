## Item Detail Popup
## Shows detailed information about an item with sell options
extends PanelContainer

signal closed()

const SELL_X_AMOUNT := 10  # Amount to sell when using "Sell X" button

@onready var item_name_label: Label = $VBoxContainer/ItemNameLabel
@onready var item_description_label: Label = $VBoxContainer/ItemDescriptionLabel
@onready var item_value_label: Label = $VBoxContainer/ItemValueLabel
@onready var stack_value_label: Label = $VBoxContainer/StackValueLabel
@onready var equipment_slot_label: Label = $VBoxContainer/EquipmentSlotLabel
@onready var equip_button: Button = $VBoxContainer/ButtonsContainer/EquipButton
@onready var unequip_button: Button = $VBoxContainer/ButtonsContainer/UnequipButton
@onready var sell_one_button: Button = $VBoxContainer/ButtonsContainer/SellOneButton
@onready var sell_x_button: Button = $VBoxContainer/ButtonsContainer/SellXButton
@onready var sell_all_button: Button = $VBoxContainer/ButtonsContainer/SellAllButton
@onready var close_button: Button = $VBoxContainer/CloseButton

var current_item_id: String = ""
var current_item_count: int = 0

func _ready() -> void:
	close_button.pressed.connect(_on_close_pressed)
	sell_one_button.pressed.connect(_on_sell_one_pressed)
	sell_x_button.pressed.connect(_on_sell_x_pressed)
	sell_all_button.pressed.connect(_on_sell_all_pressed)
	
	# Create equip/unequip buttons dynamically if they don't exist in scene
	_ensure_equipment_ui()
	
	equip_button.pressed.connect(_on_equip_pressed)
	unequip_button.pressed.connect(_on_unequip_pressed)

## Ensure equipment UI elements exist
func _ensure_equipment_ui() -> void:
	var buttons_container = $VBoxContainer/ButtonsContainer
	
	# Create equipment slot label if it doesn't exist
	if not equipment_slot_label:
		equipment_slot_label = Label.new()
		equipment_slot_label.name = "EquipmentSlotLabel"
		equipment_slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		equipment_slot_label.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0))
		equipment_slot_label.add_theme_font_size_override("font_size", 14)
		$VBoxContainer.add_child(equipment_slot_label)
		$VBoxContainer.move_child(equipment_slot_label, stack_value_label.get_index() + 1)
	
	# Create equip button if it doesn't exist
	if not equip_button:
		equip_button = Button.new()
		equip_button.name = "EquipButton"
		equip_button.custom_minimum_size = Vector2(0, 45)
		equip_button.add_theme_font_size_override("font_size", 16)
		equip_button.text = "Equip"
		buttons_container.add_child(equip_button)
		buttons_container.move_child(equip_button, 0)
	
	# Create unequip button if it doesn't exist
	if not unequip_button:
		unequip_button = Button.new()
		unequip_button.name = "UnequipButton"
		unequip_button.custom_minimum_size = Vector2(0, 45)
		unequip_button.add_theme_font_size_override("font_size", 16)
		unequip_button.text = "Unequip"
		buttons_container.add_child(unequip_button)
		buttons_container.move_child(unequip_button, 1)

## Show item details
func show_item(item_id: String) -> void:
	current_item_id = item_id
	current_item_count = Inventory.get_item_count(item_id)
	
	var item_data := Inventory.get_item_data(item_id)
	if item_data == null:
		push_warning("[ItemDetailPopup] Cannot show item '%s': Item data not found" % item_id)
		hide()
		return
	
	# Set item information
	item_name_label.text = item_data.name
	item_description_label.text = item_data.description
	item_value_label.text = "Value: %d gold" % item_data.value
	
	# Calculate and display stack value
	var stack_value := item_data.value * current_item_count
	stack_value_label.text = "Stack Value: %d gold (x%d)" % [stack_value, current_item_count]
	
	# Show equipment slot if applicable
	if item_data.equipment_slot != ItemData.EquipmentSlot.NONE:
		var slot_name := _get_slot_name(item_data.equipment_slot)
		equipment_slot_label.text = "Slot: %s" % slot_name
		equipment_slot_label.visible = true
	else:
		equipment_slot_label.visible = false
	
	# Update button states
	_update_buttons()
	
	# Show the popup
	visible = true

## Get human-readable slot name
func _get_slot_name(slot: ItemData.EquipmentSlot) -> String:
	match slot:
		ItemData.EquipmentSlot.HELM: return "Helm"
		ItemData.EquipmentSlot.NECKLACE: return "Necklace"
		ItemData.EquipmentSlot.CHEST: return "Chest"
		ItemData.EquipmentSlot.GLOVES: return "Gloves"
		ItemData.EquipmentSlot.RING: return "Ring"
		ItemData.EquipmentSlot.MAIN_HAND: return "Main Hand"
		ItemData.EquipmentSlot.OFF_HAND: return "Off Hand"
		ItemData.EquipmentSlot.LEGS: return "Legs"
		ItemData.EquipmentSlot.ARROWS: return "Arrows"
		ItemData.EquipmentSlot.BOOTS: return "Boots"
		_: return "Unknown"

## Update button states based on current item count and equipment status
func _update_buttons() -> void:
	var item_data := Inventory.get_item_data(current_item_id)
	if item_data == null:
		return
	
	var has_items := current_item_count > 0
	var is_equippable := item_data.equipment_slot != ItemData.EquipmentSlot.NONE
	var is_equipped := Equipment.is_item_equipped(current_item_id)
	
	# Equip/Unequip buttons
	equip_button.visible = is_equippable
	unequip_button.visible = is_equippable
	equip_button.disabled = not has_items or is_equipped
	unequip_button.disabled = not is_equipped
	
	# Sell buttons
	sell_one_button.disabled = not has_items
	sell_x_button.disabled = not has_items
	sell_all_button.disabled = not has_items

## Handle close button
func _on_close_pressed() -> void:
	visible = false
	closed.emit()

## Handle equip button
func _on_equip_pressed() -> void:
	if Equipment.equip_item(current_item_id):
		current_item_count = Inventory.get_item_count(current_item_id)
		_refresh_display()

## Handle unequip button
func _on_unequip_pressed() -> void:
	var slot := Equipment.get_equipped_slot(current_item_id)
	if slot != ItemData.EquipmentSlot.NONE and Equipment.unequip_item(slot):
		current_item_count = Inventory.get_item_count(current_item_id)
		_refresh_display()

## Handle sell one button
func _on_sell_one_pressed() -> void:
	if Store.sell_item(current_item_id, 1):
		current_item_count = Inventory.get_item_count(current_item_id)
		_refresh_display()

## Handle sell X button
func _on_sell_x_pressed() -> void:
	# Sell SELL_X_AMOUNT items or all if less
	var amount_to_sell: int = min(SELL_X_AMOUNT, current_item_count)
	if amount_to_sell > 0 and Store.sell_item(current_item_id, amount_to_sell):
		current_item_count = Inventory.get_item_count(current_item_id)
		_refresh_display()

## Handle sell all button
func _on_sell_all_pressed() -> void:
	if Store.sell_item(current_item_id, current_item_count):
		_refresh_display()

## Refresh the display after selling
func _refresh_display() -> void:
	if current_item_count <= 0 and not Equipment.is_item_equipped(current_item_id):
		# No more items and not equipped, close the popup
		_on_close_pressed()
	else:
		# Update the display
		show_item(current_item_id)
