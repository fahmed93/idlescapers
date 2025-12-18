## Main game scene controller
extends Control

const BUTTON_HEIGHT := 60  # Standard height for sidebar buttons

@onready var skill_sidebar: VBoxContainer = $HSplitContainer/SkillSidebar
@onready var main_content: VBoxContainer = $HSplitContainer/MainContent
@onready var action_list: VBoxContainer = $HSplitContainer/MainContent/ActionList/ScrollContainer/ActionListContent
@onready var selected_skill_label: Label = $HSplitContainer/MainContent/SelectedSkillHeader/SkillName
@onready var skill_level_label: Label = $HSplitContainer/MainContent/SelectedSkillHeader/SkillLevel
@onready var skill_xp_bar: ProgressBar = $HSplitContainer/MainContent/SelectedSkillHeader/XPProgressBar
@onready var skill_xp_label: Label = $HSplitContainer/MainContent/SelectedSkillHeader/XPLabel
@onready var training_panel: PanelContainer = $HSplitContainer/MainContent/TrainingPanel
@onready var training_label: Label = $HSplitContainer/MainContent/TrainingPanel/VBoxContainer/TrainingLabel
@onready var training_progress: ProgressBar = $HSplitContainer/MainContent/TrainingPanel/VBoxContainer/TrainingProgressBar
@onready var stop_button: Button = $HSplitContainer/MainContent/TrainingPanel/VBoxContainer/StopButton
@onready var inventory_panel: PanelContainer = $HSplitContainer/MainContent/InventoryPanel
@onready var inventory_list: GridContainer = $HSplitContainer/MainContent/InventoryPanel/VBoxContainer/ScrollContainer/InventoryGrid
@onready var total_stats_label: Label = $HSplitContainer/MainContent/TotalStatsPanel/TotalStatsLabel
@onready var offline_popup: PanelContainer = $OfflineProgressPopup

var selected_skill_id: String = ""
var skill_buttons: Dictionary = {}
var action_buttons: Dictionary = {}
var is_store_view: bool = false
var is_upgrades_view: bool = false
var is_inventory_view: bool = false
var store_button: Button = null
var store_panel: PanelContainer = null
var store_items_list: VBoxContainer = null
var store_gold_label: Label = null
var upgrades_button: Button = null
var upgrades_panel: PanelContainer = null
var upgrades_list: VBoxContainer = null
var upgrades_gold_label: Label = null
var inventory_button: Button = null
var inventory_panel_view: PanelContainer = null
var inventory_items_list: GridContainer = null

func _ready() -> void:
	_setup_signals()
	_create_inventory_ui()
	_create_inventory_button()
	_create_store_ui()
	_create_store_button()
	_create_upgrades_ui()
	_create_upgrades_button()
	_populate_skill_sidebar()
	_update_total_stats()
	_hide_training_panel()
	
	# Select first skill by default
	if not GameManager.skills.is_empty():
		_on_skill_selected(GameManager.skills.keys()[0])
	
	# Connect to offline progress signal
	SaveManager.offline_progress_calculated.connect(_on_offline_progress)

func _setup_signals() -> void:
	GameManager.skill_xp_gained.connect(_on_skill_xp_gained)
	GameManager.skill_level_up.connect(_on_skill_level_up)
	GameManager.training_started.connect(_on_training_started)
	GameManager.training_stopped.connect(_on_training_stopped)
	GameManager.action_completed.connect(_on_action_completed)
	Inventory.inventory_updated.connect(_on_inventory_updated)
	Store.gold_changed.connect(_on_gold_changed)
	Store.item_sold.connect(_on_item_sold)
	UpgradeShop.upgrade_purchased.connect(_on_upgrade_purchased)
	UpgradeShop.upgrades_updated.connect(_on_upgrades_updated)
	stop_button.pressed.connect(_on_stop_button_pressed)

func _process(_delta: float) -> void:
	if GameManager.is_training:
		_update_training_progress()

func _populate_skill_sidebar() -> void:
	# Clear existing buttons (but not the header, store button, or upgrades button)
	for child in skill_sidebar.get_children():
		if child is Button and child != store_button and child != upgrades_button:
			child.queue_free()
	skill_buttons.clear()
	
	# Create a button for each skill
	for skill_id in GameManager.skills:
		var skill: SkillData = GameManager.skills[skill_id]
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
		button.text = "%s\nLv. %d" % [skill.name, GameManager.get_skill_level(skill_id)]
		button.add_theme_color_override("font_color", skill.color)
		button.pressed.connect(_on_skill_selected.bind(skill_id))
		skill_sidebar.add_child(button)
		skill_buttons[skill_id] = button
	
	# Add total level display at bottom
	var total_label := Label.new()
	total_label.name = "TotalLevelLabel"
	total_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	total_label.text = "Total: %d" % GameManager.get_total_level()
	skill_sidebar.add_child(total_label)

func _on_skill_selected(skill_id: String) -> void:
	is_store_view = false
	is_upgrades_view = false
	is_inventory_view = false
	selected_skill_id = skill_id
	_show_skill_view()
	_update_skill_display()
	_populate_action_list()

func _update_skill_display() -> void:
	if selected_skill_id.is_empty():
		return
	
	var skill: SkillData = GameManager.skills.get(selected_skill_id)
	if skill == null:
		return
	
	var level := GameManager.get_skill_level(selected_skill_id)
	var xp := GameManager.get_skill_xp(selected_skill_id)
	var progress := GameManager.get_level_progress(selected_skill_id)
	var current_level_xp := GameManager.get_xp_for_level(level)
	var next_level_xp := GameManager.get_xp_for_level(level + 1)
	
	selected_skill_label.text = skill.name
	selected_skill_label.add_theme_color_override("font_color", skill.color)
	skill_level_label.text = "Level %d" % level
	skill_xp_bar.value = progress * 100
	
	if level >= GameManager.MAX_LEVEL:
		skill_xp_label.text = "MAX LEVEL - %.0f XP" % xp
	else:
		skill_xp_label.text = "%.0f / %.0f XP" % [xp - current_level_xp, next_level_xp - current_level_xp]

func _populate_action_list() -> void:
	# Clear existing action buttons
	for child in action_list.get_children():
		child.queue_free()
	action_buttons.clear()
	
	if selected_skill_id.is_empty():
		return
	
	var skill: SkillData = GameManager.skills.get(selected_skill_id)
	if skill == null:
		return
	
	var player_level := GameManager.get_skill_level(selected_skill_id)
	
	for method in skill.training_methods:
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(0, 80)
		
		var hbox := HBoxContainer.new()
		hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		panel.add_child(hbox)
		
		var info_vbox := VBoxContainer.new()
		info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(info_vbox)
		
		var name_label := Label.new()
		name_label.text = method.name
		if player_level < method.level_required:
			name_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		info_vbox.add_child(name_label)
		
		var stats_label := Label.new()
		stats_label.text = method.get_stats_text()
		stats_label.add_theme_font_size_override("font_size", 12)
		stats_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		info_vbox.add_child(stats_label)
		
		# Show speed bonus from upgrades
		var speed_modifier := UpgradeShop.get_skill_speed_modifier(selected_skill_id)
		if speed_modifier > 0:
			var bonus_label := Label.new()
			bonus_label.text = "+%.0f%% Speed Bonus" % (speed_modifier * 100)
			bonus_label.add_theme_font_size_override("font_size", 11)
			bonus_label.add_theme_color_override("font_color", Color(0.5, 1.0, 0.5))
			info_vbox.add_child(bonus_label)
		
		# Show required/produced items
		var items_text := ""
		if not method.consumed_items.is_empty():
			for item_id in method.consumed_items:
				var item_data := Inventory.get_item_data(item_id)
				var item_name: String = item_data.name if item_data else item_id
				items_text += "Uses: %s x%d " % [item_name, method.consumed_items[item_id]]
		if not method.produced_items.is_empty():
			for item_id in method.produced_items:
				var item_data := Inventory.get_item_data(item_id)
				var item_name: String = item_data.name if item_data else item_id
				items_text += "→ %s " % item_name
		
		if not items_text.is_empty():
			var items_label := Label.new()
			items_label.text = items_text.strip_edges()
			items_label.add_theme_font_size_override("font_size", 11)
			items_label.add_theme_color_override("font_color", Color(0.6, 0.8, 0.6))
			info_vbox.add_child(items_label)
		
		var train_button := Button.new()
		train_button.custom_minimum_size = Vector2(80, 40)
		
		if player_level >= method.level_required:
			train_button.text = "Train"
			train_button.pressed.connect(_on_train_button_pressed.bind(method.id))
		else:
			train_button.text = "Lv %d" % method.level_required
			train_button.disabled = true
		
		hbox.add_child(train_button)
		action_buttons[method.id] = train_button
		action_list.add_child(panel)

func _on_train_button_pressed(method_id: String) -> void:
	GameManager.start_training(selected_skill_id, method_id)

func _on_stop_button_pressed() -> void:
	GameManager.stop_training()

func _on_training_started(_skill_id: String, method_id: String) -> void:
	var method := GameManager.get_current_training_method()
	if method:
		training_label.text = "Training: %s" % method.name
	training_panel.visible = true
	training_progress.value = 0

func _on_training_stopped(_skill_id: String) -> void:
	_hide_training_panel()

func _hide_training_panel() -> void:
	training_panel.visible = false
	training_progress.value = 0

func _update_training_progress() -> void:
	var method := GameManager.get_current_training_method()
	if method:
		var progress := (GameManager.training_progress / method.action_time) * 100.0
		training_progress.value = progress

func _on_skill_xp_gained(skill_id: String, _xp: float) -> void:
	if skill_id == selected_skill_id:
		_update_skill_display()
	_update_sidebar_button(skill_id)
	_update_total_stats()

func _on_skill_level_up(skill_id: String, new_level: int) -> void:
	print("[Main] %s leveled up to %d!" % [skill_id, new_level])
	_update_sidebar_button(skill_id)
	if skill_id == selected_skill_id:
		_populate_action_list()  # Refresh to show newly unlocked methods
	_update_total_stats()

func _update_sidebar_button(skill_id: String) -> void:
	if skill_buttons.has(skill_id):
		var skill: SkillData = GameManager.skills[skill_id]
		var button: Button = skill_buttons[skill_id]
		button.text = "%s\nLv. %d" % [skill.name, GameManager.get_skill_level(skill_id)]
	
	# Update total level label
	var total_label := skill_sidebar.get_node_or_null("TotalLevelLabel")
	if total_label:
		total_label.text = "Total: %d" % GameManager.get_total_level()

func _on_action_completed(_skill_id: String, _method_id: String, _success: bool) -> void:
	_on_inventory_updated()

func _on_inventory_updated() -> void:
	# Update both inventory displays (skill view and inventory view)
	_update_inventory_display(inventory_list)
	if inventory_items_list:
		_update_inventory_display(inventory_items_list)

func _update_inventory_display(grid: GridContainer) -> void:
	# Clear inventory grid
	for child in grid.get_children():
		child.queue_free()
	
	var items := Inventory.get_all_items()
	for item_id in items:
		var item_data := Inventory.get_item_data(item_id)
		var count: int = items[item_id]
		
		var item_panel := PanelContainer.new()
		item_panel.custom_minimum_size = Vector2(100, 60)
		
		var vbox := VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		item_panel.add_child(vbox)
		
		var name_label := Label.new()
		name_label.text = item_data.name if item_data else item_id
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size", 11)
		vbox.add_child(name_label)
		
		var count_label := Label.new()
		count_label.text = "x%d" % count
		count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		count_label.add_theme_font_size_override("font_size", 14)
		vbox.add_child(count_label)
		
		grid.add_child(item_panel)

func _update_total_stats() -> void:
	var total_level := GameManager.get_total_level()
	var total_xp := GameManager.get_total_xp()
	var inventory_value := Inventory.get_total_value()
	var gold := Store.get_gold()
	total_stats_label.text = "Total Level: %d | Total XP: %.0f | Inventory Value: %d | Gold: %d" % [total_level, total_xp, inventory_value, gold]

func _on_offline_progress(time_away: float, actions_completed: int, xp_gained: Dictionary) -> void:
	# Show offline progress popup
	var hours := int(time_away / 3600)
	var minutes := int((int(time_away) % 3600) / 60)
	
	var message := "Welcome back!\n\n"
	message += "You were away for %dh %dm\n" % [hours, minutes]
	message += "Actions completed: %d\n\n" % actions_completed
	
	for skill_id in xp_gained:
		var skill: SkillData = GameManager.skills.get(skill_id)
		if skill:
			message += "%s XP gained: %.0f\n" % [skill.name, xp_gained[skill_id]]
	
	var popup_label := offline_popup.get_node_or_null("VBoxContainer/MessageLabel")
	if popup_label:
		popup_label.text = message
	
	offline_popup.visible = true
	
	# Refresh displays
	_update_skill_display()
	_on_inventory_updated()
	_update_total_stats()
	for skill_id in GameManager.skills:
		_update_sidebar_button(skill_id)

func _on_close_offline_popup() -> void:
	offline_popup.visible = false

## Create Inventory UI
func _create_inventory_ui() -> void:
	# Create inventory panel (hidden by default)
	inventory_panel_view = PanelContainer.new()
	inventory_panel_view.name = "InventoryPanelView"
	inventory_panel_view.visible = false
	inventory_panel_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var inventory_vbox := VBoxContainer.new()
	inventory_panel_view.add_child(inventory_vbox)
	
	# Inventory header
	var inventory_header := Label.new()
	inventory_header.text = "Inventory"
	inventory_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	inventory_header.add_theme_font_size_override("font_size", 20)
	inventory_header.add_theme_color_override("font_color", Color(0.6, 0.8, 0.6))
	inventory_vbox.add_child(inventory_header)
	
	# Inventory items list
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	inventory_vbox.add_child(scroll)
	
	inventory_items_list = GridContainer.new()
	inventory_items_list.columns = 4
	inventory_items_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(inventory_items_list)
	
	# Add to main content
	main_content.add_child(inventory_panel_view)
	main_content.move_child(inventory_panel_view, inventory_panel.get_index() + 1)

## Create Inventory button
func _create_inventory_button() -> void:
	inventory_button = Button.new()
	inventory_button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
	inventory_button.text = "Inventory"
	inventory_button.add_theme_color_override("font_color", Color(0.6, 0.8, 0.6))
	inventory_button.pressed.connect(_on_inventory_selected)
	skill_sidebar.add_child(inventory_button)

## Show inventory view
func _on_inventory_selected() -> void:
	is_store_view = false
	is_upgrades_view = false
	is_inventory_view = true
	_hide_skill_view()
	_show_inventory_view()
	_on_inventory_updated()

## Show inventory view
func _show_inventory_view() -> void:
	if store_panel:
		store_panel.visible = false
	if upgrades_panel:
		upgrades_panel.visible = false
	if inventory_panel_view:
		inventory_panel_view.visible = true

## Create Store UI
func _create_store_ui() -> void:
	# Create store panel (hidden by default)
	store_panel = PanelContainer.new()
	store_panel.name = "StorePanel"
	store_panel.visible = false
	store_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var store_vbox := VBoxContainer.new()
	store_panel.add_child(store_vbox)
	
	# Store header
	var store_header := Label.new()
	store_header.text = "Store - Sell Items"
	store_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	store_header.add_theme_font_size_override("font_size", 20)
	store_header.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	store_vbox.add_child(store_header)
	
	store_gold_label = Label.new()
	store_gold_label.text = "Gold: %d" % Store.get_gold()
	store_gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	store_gold_label.add_theme_font_size_override("font_size", 16)
	store_vbox.add_child(store_gold_label)
	
	# Store items list
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	store_vbox.add_child(scroll)
	
	store_items_list = VBoxContainer.new()
	store_items_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(store_items_list)
	
	# Add to main content (store panel will be positioned after inventory panel)
	main_content.add_child(store_panel)
	# Note: inventory_panel is a @onready var, so it's guaranteed to be in tree at this point
	main_content.move_child(store_panel, inventory_panel.get_index() + 1)

## Create Store button
func _create_store_button() -> void:
	store_button = Button.new()
	store_button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
	store_button.text = "Store\n%d Gold" % Store.get_gold()
	store_button.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))  # Gold color
	store_button.pressed.connect(_on_store_selected)
	skill_sidebar.add_child(store_button)

## Show store view
func _on_store_selected() -> void:
	is_store_view = true
	is_upgrades_view = false
	is_inventory_view = false
	_hide_skill_view()
	_show_store_view()
	_populate_store_items()

## Show skill view
func _show_skill_view() -> void:
	if store_panel:
		store_panel.visible = false
	if upgrades_panel:
		upgrades_panel.visible = false
	if inventory_panel_view:
		inventory_panel_view.visible = false
	# Inventory panel stays hidden in skill view - use dedicated inventory screen instead
	inventory_panel.visible = false

## Hide skill view
func _hide_skill_view() -> void:
	# Nothing to hide - inventory panel is already hidden
	pass

## Show store view
func _show_store_view() -> void:
	if inventory_panel_view:
		inventory_panel_view.visible = false
	if upgrades_panel:
		upgrades_panel.visible = false
	if store_panel:
		store_panel.visible = true

## Populate store items list
func _populate_store_items() -> void:
	if not store_items_list:
		return
	
	# Clear existing items
	for child in store_items_list.get_children():
		child.queue_free()
	
	var items := Inventory.get_all_items()
	if items.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No items to sell"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		store_items_list.add_child(empty_label)
		return
	
	for item_id in items:
		var item_data := Inventory.get_item_data(item_id)
		if item_data == null:
			continue  # Skip items without data
		
		var count: int = items[item_id]
		
		var item_panel := PanelContainer.new()
		item_panel.custom_minimum_size = Vector2(0, 70)
		
		var hbox := HBoxContainer.new()
		item_panel.add_child(hbox)
		
		# Item info
		var info_vbox := VBoxContainer.new()
		info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(info_vbox)
		
		var name_label := Label.new()
		name_label.text = item_data.name
		info_vbox.add_child(name_label)
		
		var count_label := Label.new()
		count_label.text = "Owned: %d" % count
		count_label.add_theme_font_size_override("font_size", 12)
		count_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		info_vbox.add_child(count_label)
		
		var value_label := Label.new()
		value_label.text = "Value: %d gold each" % item_data.value
		value_label.add_theme_font_size_override("font_size", 12)
		value_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
		info_vbox.add_child(value_label)
		
		# Sell buttons
		var button_vbox := VBoxContainer.new()
		hbox.add_child(button_vbox)
		
		var sell_one_button := Button.new()
		sell_one_button.text = "Sell 1"
		sell_one_button.custom_minimum_size = Vector2(80, 30)
		sell_one_button.pressed.connect(_on_sell_item.bind(item_id, 1))
		button_vbox.add_child(sell_one_button)
		
		var sell_all_button := Button.new()
		sell_all_button.text = "Sell All"
		sell_all_button.custom_minimum_size = Vector2(80, 30)
		sell_all_button.pressed.connect(_on_sell_all_item.bind(item_id))
		button_vbox.add_child(sell_all_button)
		
		store_items_list.add_child(item_panel)

## Handle selling an item
func _on_sell_item(item_id: String, amount: int) -> void:
	if Store.sell_item(item_id, amount):
		_populate_store_items()

## Handle selling all of an item
func _on_sell_all_item(item_id: String) -> void:
	var count := Inventory.get_item_count(item_id)
	if count > 0 and Store.sell_item(item_id, count):
		_populate_store_items()

## Update gold display when gold changes
func _on_gold_changed(new_amount: int) -> void:
	_update_total_stats()
	
	# Update store button text
	if store_button:
		store_button.text = "Store\n%d Gold" % new_amount
	
	# Update gold label in store panel
	if store_gold_label:
		store_gold_label.text = "Gold: %d" % new_amount
	
	# Update gold label in upgrades panel
	if upgrades_gold_label:
		upgrades_gold_label.text = "Gold: %d" % new_amount

## Handle item sold signal
func _on_item_sold(item_id: String, amount: int, gold_earned: int) -> void:
	print("[Main] Sold %d x %s for %d gold" % [amount, item_id, gold_earned])

## Create Upgrades Shop UI
func _create_upgrades_ui() -> void:
	# Create upgrades panel (hidden by default)
	upgrades_panel = PanelContainer.new()
	upgrades_panel.name = "UpgradesPanel"
	upgrades_panel.visible = false
	upgrades_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var upgrades_vbox := VBoxContainer.new()
	upgrades_panel.add_child(upgrades_vbox)
	
	# Upgrades header
	var upgrades_header := Label.new()
	upgrades_header.text = "Upgrades Shop"
	upgrades_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	upgrades_header.add_theme_font_size_override("font_size", 20)
	upgrades_header.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
	upgrades_vbox.add_child(upgrades_header)
	
	upgrades_gold_label = Label.new()
	upgrades_gold_label.text = "Gold: %d" % Store.get_gold()
	upgrades_gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	upgrades_gold_label.add_theme_font_size_override("font_size", 16)
	upgrades_vbox.add_child(upgrades_gold_label)
	
	# Upgrades list
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	upgrades_vbox.add_child(scroll)
	
	upgrades_list = VBoxContainer.new()
	upgrades_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(upgrades_list)
	
	# Add to main content
	main_content.add_child(upgrades_panel)
	main_content.move_child(upgrades_panel, inventory_panel.get_index() + 1)

## Create Upgrades button
func _create_upgrades_button() -> void:
	upgrades_button = Button.new()
	upgrades_button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
	upgrades_button.text = "Upgrades"
	upgrades_button.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
	upgrades_button.pressed.connect(_on_upgrades_selected)
	skill_sidebar.add_child(upgrades_button)

## Show upgrades view
func _on_upgrades_selected() -> void:
	is_store_view = false
	is_upgrades_view = true
	is_inventory_view = false
	_hide_skill_view()
	_show_upgrades_view()
	_populate_upgrades_list()

## Show upgrades view
func _show_upgrades_view() -> void:
	if store_panel:
		store_panel.visible = false
	if inventory_panel_view:
		inventory_panel_view.visible = false
	if upgrades_panel:
		upgrades_panel.visible = true

## Populate upgrades list
func _populate_upgrades_list() -> void:
	if not upgrades_list:
		return
	
	# Clear existing items
	for child in upgrades_list.get_children():
		child.queue_free()
	
	# Group upgrades by skill
	for skill_id in GameManager.skills:
		var skill: SkillData = GameManager.skills[skill_id]
		var skill_upgrades := UpgradeShop.get_upgrades_for_skill(skill_id)
		
		if skill_upgrades.is_empty():
			continue
		
		# Add skill header
		var skill_header := Label.new()
		skill_header.text = skill.name
		skill_header.add_theme_font_size_override("font_size", 16)
		skill_header.add_theme_color_override("font_color", skill.color)
		upgrades_list.add_child(skill_header)
		
		# Add upgrades for this skill
		for upgrade in skill_upgrades:
			var upgrade_panel := PanelContainer.new()
			upgrade_panel.custom_minimum_size = Vector2(0, 80)
			
			var hbox := HBoxContainer.new()
			upgrade_panel.add_child(hbox)
			
			# Upgrade info
			var info_vbox := VBoxContainer.new()
			info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hbox.add_child(info_vbox)
			
			var name_label := Label.new()
			name_label.text = upgrade.name
			var is_purchased := UpgradeShop.is_purchased(upgrade.id)
			if is_purchased:
				name_label.add_theme_color_override("font_color", Color(0.3, 0.8, 0.3))
				name_label.text += " ✓"
			elif GameManager.get_skill_level(skill_id) < upgrade.level_required:
				name_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			info_vbox.add_child(name_label)
			
			var desc_label := Label.new()
			desc_label.text = upgrade.description
			desc_label.add_theme_font_size_override("font_size", 11)
			desc_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
			info_vbox.add_child(desc_label)
			
			var stats_label := Label.new()
			stats_label.text = upgrade.get_stats_text()
			stats_label.add_theme_font_size_override("font_size", 12)
			stats_label.add_theme_color_override("font_color", Color(0.6, 0.8, 0.6))
			info_vbox.add_child(stats_label)
			
			# Purchase button
			var button := Button.new()
			button.custom_minimum_size = Vector2(80, 40)
			button.text = "Buy"
			
			if is_purchased:
				button.text = "Owned"
				button.disabled = true
			elif GameManager.get_skill_level(skill_id) < upgrade.level_required:
				button.text = "Lv %d" % upgrade.level_required
				button.disabled = true
			elif not Store.has_gold(upgrade.cost):
				button.disabled = true
			else:
				button.pressed.connect(_on_purchase_upgrade.bind(upgrade.id))
			
			hbox.add_child(button)
			upgrades_list.add_child(upgrade_panel)

## Handle purchasing an upgrade
func _on_purchase_upgrade(upgrade_id: String) -> void:
	if UpgradeShop.purchase_upgrade(upgrade_id):
		_populate_upgrades_list()

## Handle upgrade purchased signal
func _on_upgrade_purchased(upgrade_id: String) -> void:
	var upgrade: UpgradeData = UpgradeShop.upgrades.get(upgrade_id)
	if upgrade:
		print("[Main] Purchased upgrade: %s for %s" % [upgrade.name, upgrade.skill_id])

## Handle upgrades updated signal
func _on_upgrades_updated() -> void:
	if is_upgrades_view:
		_populate_upgrades_list()


