## Item Detail Popup
## Shows detailed information about an item with sell options
extends PanelContainer

signal closed()

const SELL_X_AMOUNT := 10  # Amount to sell when using "Sell X" button

@onready var item_name_label: Label = $VBoxContainer/ItemNameLabel
@onready var item_description_label: Label = $VBoxContainer/ItemDescriptionLabel
@onready var item_value_label: Label = $VBoxContainer/ItemValueLabel
@onready var stack_value_label: Label = $VBoxContainer/StackValueLabel
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
	
	# Update button states
	_update_buttons()
	
	# Show the popup
	visible = true

## Update button states based on current item count
func _update_buttons() -> void:
	var has_items := current_item_count > 0
	sell_one_button.disabled = not has_items
	sell_x_button.disabled = not has_items
	sell_all_button.disabled = not has_items

## Handle close button
func _on_close_pressed() -> void:
	visible = false
	closed.emit()

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
	if current_item_count <= 0:
		# No more items, close the popup
		_on_close_pressed()
	else:
		# Update the display
		show_item(current_item_id)
