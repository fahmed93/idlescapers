## Main game scene controller
extends Control

const BUTTON_HEIGHT := 60  # Standard height for sidebar buttons
const ITEM_PANEL_WIDTH := 100  # Width of inventory item panels
const ITEM_PANEL_HEIGHT := 100  # Height of inventory item panels (increased for sell buttons)
const INVENTORY_ICON_SIZE := 48  # Size of item icons in inventory display
const ItemDetailPopupScene := preload("res://scenes/item_detail_popup.tscn")
const ToastNotificationScene := preload("res://scenes/toast_notification.tscn")

# Equipment layout constants
# Note: Mobile viewport is 720px wide. After sidebar (~120px) and padding (~40px),
# available width is ~560px, so center is approximately 280px from left edge of content area.
const EQUIPMENT_SLOT_SIZE := Vector2(100, 80)
const EQUIPMENT_CENTER_X := 280.0  # Center of content area
const EQUIPMENT_SPACING_X := 120.0  # Horizontal spacing for side items
const EQUIPMENT_RING_OFFSET := 60.0  # Horizontal offset for ring slots from center
const EQUIPMENT_SLOT_LABEL_FONT_SIZE := 11  # Font size for slot names
const EQUIPMENT_ITEM_LABEL_FONT_SIZE := 10  # Font size for equipped item names

@onready var skill_sidebar: VBoxContainer = $HSplitContainer/SkillSidebar
@onready var main_content: VBoxContainer = $HSplitContainer/MainContent
@onready var menu_button: Button = $MenuButton
@onready var change_character_button: Button = $ChangeCharacterButton
@onready var selected_skill_header: VBoxContainer = $HSplitContainer/MainContent/SelectedSkillHeader
@onready var action_list: VBoxContainer = $HSplitContainer/MainContent/ActionList/ScrollContainer/ActionListContent
@onready var selected_skill_label: Label = $HSplitContainer/MainContent/SelectedSkillHeader/SkillName
@onready var skill_level_label: Label = $HSplitContainer/MainContent/SelectedSkillHeader/SkillLevel
@onready var skill_xp_bar: ProgressBar = $HSplitContainer/MainContent/SelectedSkillHeader/XPProgressBar
@onready var skill_xp_label: Label = $HSplitContainer/MainContent/SelectedSkillHeader/XPLabel
@onready var skill_speed_bonus_label: Label = $HSplitContainer/MainContent/SelectedSkillHeader/SpeedBonusLabel
@onready var action_list_label: Label = $HSplitContainer/MainContent/ActionListLabel
@onready var action_list_panel: PanelContainer = $HSplitContainer/MainContent/ActionList
@onready var training_panel: PanelContainer = $HSplitContainer/MainContent/TrainingPanel
@onready var training_label: Label = $HSplitContainer/MainContent/TrainingPanel/VBoxContainer/TrainingLabel
@onready var training_progress: ProgressBar = $HSplitContainer/MainContent/TrainingPanel/VBoxContainer/TrainingProgressBar
@onready var training_time_label: Label = $HSplitContainer/MainContent/TrainingPanel/VBoxContainer/TrainingTimeLabel
@onready var stop_button: Button = $HSplitContainer/MainContent/TrainingPanel/VBoxContainer/StopButton
@onready var inventory_panel: PanelContainer = $HSplitContainer/MainContent/InventoryPanel
@onready var inventory_list: GridContainer = $HSplitContainer/MainContent/InventoryPanel/VBoxContainer/ScrollContainer/InventoryGrid
@onready var total_stats_label: Label = $HSplitContainer/MainContent/TotalStatsPanel/TotalStatsLabel
@onready var offline_popup: PanelContainer = $OfflineProgressPopup

var selected_skill_id: String = ""
var skill_buttons: Dictionary = {}
var action_buttons: Dictionary = {}
var is_upgrades_view: bool = false
var is_inventory_view: bool = false
var is_equipment_view: bool = false
var is_skill_summary_view: bool = false
var upgrades_button: Button = null
var upgrades_panel: PanelContainer = null
var upgrades_list: VBoxContainer = null
var upgrades_gold_label: Label = null
var upgrades_hide_owned_checkbox: CheckBox = null
var hide_owned_upgrades: bool = false
var inventory_button: Button = null
var inventory_panel_view: PanelContainer = null
var inventory_items_list: GridContainer = null
var inventory_tab_bar: HBoxContainer = null
var inventory_current_tab: String = ""
var inventory_tab_buttons: Dictionary = {}  # tab_id: Button
var dragging_item: Dictionary = {}  # { item_id: String, from_tab: String, amount: int }
var drag_preview: Control = null
var equipment_button: Button = null
var equipment_panel_view: PanelContainer = null
var equipment_slots_container: Control = null
var is_sidebar_expanded: bool = false
var item_detail_popup: PanelContainer = null
var toast_container: VBoxContainer = null
var skill_summary_button: Button = null
var skill_summary_panel: PanelContainer = null
var skill_summary_grid: GridContainer = null

func _ready() -> void:
	_setup_signals()
	_create_item_detail_popup()
	_create_toast_container()
	_create_inventory_ui()
	_create_equipment_ui()
	_create_upgrades_ui()
	_create_skill_summary_ui()
	_create_player_section_buttons()
	_create_info_section_buttons()
	_populate_skill_sidebar()
	_update_total_stats()
	_hide_training_panel()
	
	# Set sidebar to collapsed by default
	_set_sidebar_collapsed(true)
	
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
	Inventory.tab_created.connect(_on_tab_created)
	Inventory.tab_deleted.connect(_on_tab_deleted)
	Inventory.tab_renamed.connect(_on_tab_renamed)
	Store.gold_changed.connect(_on_gold_changed)
	UpgradeShop.upgrade_purchased.connect(_on_upgrade_purchased)
	UpgradeShop.upgrades_updated.connect(_on_upgrades_updated)
	Equipment.equipment_changed.connect(_on_equipment_changed)
	stop_button.pressed.connect(_on_stop_button_pressed)
	menu_button.pressed.connect(_on_sidebar_toggle_pressed)
	change_character_button.pressed.connect(_on_change_character_pressed)

func _process(_delta: float) -> void:
	if GameManager.is_training:
		_update_training_progress()

## Create all buttons for the Player section
func _create_player_section_buttons() -> void:
	# Find the PlayerHeader node to insert buttons after it
	var player_header := skill_sidebar.get_node_or_null("PlayerHeader")
	if not player_header:
		push_error("PlayerHeader not found in sidebar")
		return
	
	var insert_index := player_header.get_index() + 1
	
	# Create Equipment button
	equipment_button = Button.new()
	equipment_button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
	equipment_button.text = "Equipment"
	equipment_button.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	equipment_button.pressed.connect(_on_equipment_selected)
	skill_sidebar.add_child(equipment_button)
	skill_sidebar.move_child(equipment_button, insert_index)
	insert_index += 1
	
	# Create Inventory button
	inventory_button = Button.new()
	inventory_button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
	inventory_button.text = "Inventory"
	inventory_button.add_theme_color_override("font_color", Color(0.6, 0.8, 0.6))
	inventory_button.pressed.connect(_on_inventory_selected)
	skill_sidebar.add_child(inventory_button)
	skill_sidebar.move_child(inventory_button, insert_index)
	insert_index += 1
	
	# Create Upgrades button
	upgrades_button = Button.new()
	upgrades_button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
	upgrades_button.text = "Upgrades"
	upgrades_button.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
	upgrades_button.pressed.connect(_on_upgrades_selected)
	skill_sidebar.add_child(upgrades_button)
	skill_sidebar.move_child(upgrades_button, insert_index)

## Create all buttons for the Info section
func _create_info_section_buttons() -> void:
	# Find the InfoHeader node to insert buttons after it
	var info_header := skill_sidebar.get_node_or_null("InfoHeader")
	if not info_header:
		push_error("InfoHeader not found in sidebar")
		return
	
	var insert_index := info_header.get_index() + 1
	
	# Create Skill Summary button
	skill_summary_button = Button.new()
	skill_summary_button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
	skill_summary_button.text = "Skill Summary"
	skill_summary_button.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	skill_summary_button.pressed.connect(_on_skill_summary_selected)
	skill_sidebar.add_child(skill_summary_button)
	skill_sidebar.move_child(skill_summary_button, insert_index)

func _populate_skill_sidebar() -> void:
	# Find the SkillsHeader node to insert skill buttons after it
	var skills_header := skill_sidebar.get_node_or_null("SkillsHeader")
	if not skills_header:
		push_error("SkillsHeader not found in sidebar")
		return
	
	var insert_index := skills_header.get_index() + 1
	
	# Clear existing skill buttons (but not the headers or player section buttons)
	for child in skill_sidebar.get_children():
		if child is Button and child != upgrades_button and child != inventory_button and child != equipment_button:
			child.queue_free()
		# Also remove TotalLevelLabel if it exists to recreate it
		elif child.name == "TotalLevelLabel":
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
		skill_sidebar.move_child(button, insert_index)
		skill_buttons[skill_id] = button
		insert_index += 1
	
	# Add total level display at bottom
	var total_label := Label.new()
	total_label.name = "TotalLevelLabel"
	total_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	total_label.text = "Total: %d" % GameManager.get_total_level()
	skill_sidebar.add_child(total_label)

func _on_skill_selected(skill_id: String) -> void:
	is_upgrades_view = false
	is_inventory_view = false
	is_equipment_view = false
	is_skill_summary_view = false
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
	
	# Show speed bonus from upgrades in skill header
	# Note: Speed modifier is also calculated in _populate_action_list() for time remaining
	# This is intentional to keep the functions decoupled
	var speed_modifier := UpgradeShop.get_skill_speed_modifier(selected_skill_id)
	if speed_modifier > 0:
		skill_speed_bonus_label.text = "+%.0f%% Speed Bonus" % (speed_modifier * 100)
		skill_speed_bonus_label.visible = true
	else:
		skill_speed_bonus_label.visible = false

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
	
	# Get speed modifier once for all methods (used for time remaining calculation)
	var speed_modifier := UpgradeShop.get_skill_speed_modifier(selected_skill_id)
	
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
		stats_label.text = method.get_stats_text(selected_skill_id)
		stats_label.add_theme_font_size_override("font_size", 12)
		stats_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		info_vbox.add_child(stats_label)
		
		# Show required/produced items
		var items_text := ""
		if not method.consumed_items.is_empty():
			for item_id in method.consumed_items:
				var item_data := Inventory.get_item_data(item_id)
				var item_name: String = item_data.name if item_data else item_id
				var player_count := Inventory.get_item_count(item_id)
				var count_color := "green" if player_count > 0 else "red"
				items_text += "Uses: %s x%d [color=%s](%d owned)[/color] " % [item_name, method.consumed_items[item_id], count_color, player_count]
		if not method.produced_items.is_empty():
			for item_id in method.produced_items:
				var item_data := Inventory.get_item_data(item_id)
				var item_name: String = item_data.name if item_data else item_id
				items_text += "→ %s " % item_name
		
		if not items_text.is_empty():
			var items_label := RichTextLabel.new()
			items_label.name = "ItemsLabel_%s" % method.id  # Add unique name for targeted updates
			items_label.bbcode_enabled = true
			items_label.text = items_text.strip_edges()
			items_label.fit_content = true
			items_label.scroll_active = false
			items_label.add_theme_font_size_override("normal_font_size", 11)
			items_label.add_theme_color_override("default_color", Color(0.6, 0.8, 0.6))
			info_vbox.add_child(items_label)
		
		# Show time until items run out (if method consumes items)
		if not method.consumed_items.is_empty():
			var time_remaining := method.calculate_time_until_out_of_items(speed_modifier)
			if time_remaining >= 0:
				var time_label := Label.new()
				time_label.text = TrainingMethodData.format_time_remaining(time_remaining)
				time_label.add_theme_font_size_override("font_size", 11)
				if time_remaining == 0:
					time_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
				elif time_remaining < 60:
					time_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.3))
				else:
					time_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.3))
				info_vbox.add_child(time_label)
		
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
		training_time_label.text = "0.0s / %.1fs" % method.action_time
	training_panel.visible = true
	training_progress.value = 0

func _on_training_stopped(_skill_id: String) -> void:
	_hide_training_panel()

func _hide_training_panel() -> void:
	training_panel.visible = false
	training_progress.value = 0
	training_time_label.text = "0.0s / 0.0s"

func _update_training_progress() -> void:
	var method := GameManager.get_current_training_method()
	if method:
		var progress := (GameManager.training_progress / method.action_time) * 100.0
		training_progress.value = progress
		
		# Update training label with time remaining if method consumes items
		if not method.consumed_items.is_empty():
			var speed_modifier := UpgradeShop.get_skill_speed_modifier(GameManager.current_skill_id)
			var time_remaining := method.calculate_time_until_out_of_items(speed_modifier)
			if time_remaining >= 0:
				var time_text := TrainingMethodData.format_time_remaining(time_remaining)
				training_label.text = "Training: %s (%s)" % [method.name, time_text]
			else:
				training_label.text = "Training: %s" % method.name
		else:
			training_label.text = "Training: %s" % method.name
		# Update time label to show elapsed/total time
		training_time_label.text = "%.1fs / %.1fs" % [GameManager.training_progress, method.action_time]

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

func _on_action_completed(skill_id: String, method_id: String, success: bool) -> void:
	_on_inventory_updated()
	
	# Get the training method to determine XP and items gained
	var skill: SkillData = GameManager.skills.get(skill_id)
	if skill == null:
		return
	
	var method: TrainingMethodData = null
	for m in skill.training_methods:
		if m.id == method_id:
			method = m
			break
	
	if method == null:
		return
	
	# Build items gained dictionary (only if action was successful)
	var items_gained: Dictionary = {}
	if success:
		# Add produced items
		for item_id in method.produced_items:
			var amount: int = method.produced_items[item_id]
			items_gained[item_id] = items_gained.get(item_id, 0) + amount
	
	# Show toast notification
	_show_toast_notification(skill_id, method.xp_per_action, items_gained)

## Update only item count labels in action list (performance optimization)
func _update_action_item_counts() -> void:
	if selected_skill_id.is_empty():
		return
	
	var skill: SkillData = GameManager.skills.get(selected_skill_id)
	if skill == null:
		return
	
	# Update item count labels for each training method
	for method in skill.training_methods:
		if method.consumed_items.is_empty():
			continue
		
		# Find the items label for this method
		var label_name := "ItemsLabel_%s" % method.id
		var items_label: RichTextLabel = null
		
		# Search through action list panels to find the label
		for panel in action_list.get_children():
			if panel is PanelContainer:
				items_label = panel.find_child(label_name, true, false)
				if items_label:
					break
		
		if items_label == null:
			continue
		
		# Rebuild the items text with updated counts
		var items_text := ""
		for item_id in method.consumed_items:
			var item_data := Inventory.get_item_data(item_id)
			var item_name: String = item_data.name if item_data else item_id
			var player_count := Inventory.get_item_count(item_id)
			var count_color := "green" if player_count > 0 else "red"
			items_text += "Uses: %s x%d [color=%s](%d owned)[/color] " % [item_name, method.consumed_items[item_id], count_color, player_count]
		
		# Add produced items
		if not method.produced_items.is_empty():
			for item_id in method.produced_items:
				var item_data := Inventory.get_item_data(item_id)
				var item_name: String = item_data.name if item_data else item_id
				items_text += "→ %s " % item_name
		
		items_label.text = items_text.strip_edges()

func _on_inventory_updated() -> void:
	# Update the inventory display in the dedicated inventory screen
	if inventory_items_list:
		_update_inventory_display(inventory_items_list)
	
	# Update item counts in action list if viewing a skill (targeted update for performance)
	if not selected_skill_id.is_empty() and not is_upgrades_view and not is_inventory_view:
		_update_action_item_counts()

func _update_inventory_display(grid: GridContainer) -> void:
	# Clear inventory grid
	for child in grid.get_children():
		child.queue_free()
	
	# Get items from current tab
	var items := Inventory.get_tab_items(inventory_current_tab)
	for item_id in items:
		var item_data := Inventory.get_item_data(item_id)
		var count: int = items[item_id]
		
		# Create a button instead of panel to make it clickable and draggable
		var item_button := Button.new()
		item_button.custom_minimum_size = Vector2(ITEM_PANEL_WIDTH, ITEM_PANEL_HEIGHT)
		item_button.pressed.connect(_on_item_clicked.bind(item_id))
		# Enable drag detection
		item_button.mouse_filter = Control.MOUSE_FILTER_PASS
		item_button.gui_input.connect(_on_item_gui_input.bind(item_id, inventory_current_tab))

		var vbox := VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Let clicks pass through to button
		vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)  # Fill the button completely
		item_button.add_child(vbox)
		
		# Add icon if available
		if item_data and item_data.icon:
			var icon_texture := TextureRect.new()
			icon_texture.texture = item_data.icon
			icon_texture.custom_minimum_size = Vector2(INVENTORY_ICON_SIZE, INVENTORY_ICON_SIZE)
			icon_texture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
			icon_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
			vbox.add_child(icon_texture)
		
		# Helper function to create labels with mouse filter ignored
		var create_label := func(text: String, font_size: int, color: Color = Color.WHITE) -> Label:
			var label := Label.new()
			label.text = text
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Expand to fill width
			label.add_theme_font_size_override("font_size", font_size)
			if color != Color.WHITE:
				label.add_theme_color_override("font_color", color)
			label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			return label
		
		vbox.add_child(create_label.call(item_data.name if item_data else item_id, 11))
		vbox.add_child(create_label.call("x%d" % count, 14))
		vbox.add_child(create_label.call("Tap for details", 9, Color(0.7, 0.7, 0.7)))
		
		grid.add_child(item_button)

## Handle item clicked in inventory
func _on_item_clicked(item_id: String) -> void:
	if item_detail_popup:
		item_detail_popup.show_item(item_id)

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

## Create Item Detail Popup
func _create_item_detail_popup() -> void:
	item_detail_popup = ItemDetailPopupScene.instantiate()
	item_detail_popup.name = "ItemDetailPopup"
	item_detail_popup.z_index = 100  # Ensure it's on top
	add_child(item_detail_popup)
	item_detail_popup.closed.connect(_on_item_detail_closed)

## Handle item detail popup closed
func _on_item_detail_closed() -> void:
	# Refresh inventory display if in inventory view
	if is_inventory_view:
		_on_inventory_updated()

## Create Toast Container
func _create_toast_container() -> void:
	# Create a VBoxContainer to hold toast notifications
	toast_container = VBoxContainer.new()
	toast_container.name = "ToastContainer"
	toast_container.z_index = 200  # Ensure it's on top of everything
	toast_container.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Allow clicks to pass through
	
	# Position at bottom center of screen, right above the bottom
	toast_container.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	toast_container.offset_top = -150  # Right above the bottom
	toast_container.offset_bottom = -20  # Small padding from the bottom
	
	add_child(toast_container)

## Show a toast notification
func _show_toast_notification(skill_id: String, xp_gained: float, items_gained: Dictionary) -> void:
	if toast_container == null:
		return
	
	# Create a new toast instance
	var toast: PanelContainer = ToastNotificationScene.instantiate()
	toast_container.add_child(toast)
	
	# Move the new toast to the top (index 0) so it appears above older toasts
	# Toasts automatically manage their own lifecycle (fade out after 3s + 0.5s fade)
	# When a toast is removed, toasts above it naturally move down to fill the space
	toast_container.move_child(toast, 0)
	
	# Show the action completion
	toast.show_action_completion(skill_id, xp_gained, items_gained)


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
	
	# Tab bar container
	var tab_bar_container := HBoxContainer.new()
	tab_bar_container.custom_minimum_size = Vector2(0, 40)
	inventory_vbox.add_child(tab_bar_container)
	
	# Scrollable tab bar
	var tab_scroll := ScrollContainer.new()
	tab_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tab_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	tab_bar_container.add_child(tab_scroll)
	
	inventory_tab_bar = HBoxContainer.new()
	tab_scroll.add_child(inventory_tab_bar)
	
	# Add tab button
	var add_tab_button := Button.new()
	add_tab_button.text = "+"
	add_tab_button.custom_minimum_size = Vector2(40, 40)
	add_tab_button.pressed.connect(_on_add_tab_pressed)
	tab_bar_container.add_child(add_tab_button)
	
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

## Create Equipment UI
func _create_equipment_ui() -> void:
	# Create equipment panel (hidden by default)
	equipment_panel_view = PanelContainer.new()
	equipment_panel_view.name = "EquipmentPanelView"
	equipment_panel_view.visible = false
	equipment_panel_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var equipment_vbox := VBoxContainer.new()
	equipment_panel_view.add_child(equipment_vbox)
	
	# Equipment header
	var equipment_header := Label.new()
	equipment_header.text = "Equipment"
	equipment_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	equipment_header.add_theme_font_size_override("font_size", 20)
	equipment_header.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	equipment_vbox.add_child(equipment_header)
	
	# Equipment slots container - using Control for positioned layout
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	equipment_vbox.add_child(scroll)
	
	# Use a Control node to allow absolute positioning of slots
	# Height is designed to fit all 11 slots in human-shaped layout
	equipment_slots_container = Control.new()
	equipment_slots_container.custom_minimum_size = Vector2(0, 650)
	equipment_slots_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(equipment_slots_container)
	
	# Add to main content
	main_content.add_child(equipment_panel_view)
	main_content.move_child(equipment_panel_view, inventory_panel.get_index() + 1)

## Handle equipment button click
func _on_equipment_selected() -> void:
	is_upgrades_view = false
	is_inventory_view = false
	is_equipment_view = true
	is_skill_summary_view = false
	_hide_skill_view()
	_show_equipment_view()
	_populate_equipment_slots()

## Show equipment view
func _show_equipment_view() -> void:
	# Hide other special panels
	if upgrades_panel:
		upgrades_panel.visible = false
	if inventory_panel_view:
		inventory_panel_view.visible = false
	if skill_summary_panel:
		skill_summary_panel.visible = false
	# Show equipment panel
	if equipment_panel_view:
		equipment_panel_view.visible = true
	
	# Hide skill-related UI elements
	_hide_skill_ui()

## Populate equipment slots display with human-shaped layout
func _populate_equipment_slots() -> void:
	if not equipment_slots_container:
		return
	
	# Clear existing slots (this also disconnects all old signal connections)
	for child in equipment_slots_container.get_children():
		child.queue_free()
	
	# Define slot positions in human shape
	# Positions are absolute coordinates within the container
	var slot_positions := {
		ItemData.EquipmentSlot.HELM: Vector2(EQUIPMENT_CENTER_X, 20),  # Top - head
		ItemData.EquipmentSlot.NECKLACE: Vector2(EQUIPMENT_CENTER_X, 110),  # Below helm - neck
		ItemData.EquipmentSlot.ARROWS: Vector2(EQUIPMENT_CENTER_X + EQUIPMENT_SPACING_X, 110),  # Right side of necklace
		ItemData.EquipmentSlot.MAIN_HAND: Vector2(EQUIPMENT_CENTER_X - EQUIPMENT_SPACING_X, 200),  # Left side - main hand
		ItemData.EquipmentSlot.CHEST: Vector2(EQUIPMENT_CENTER_X, 200),  # Center - body
		ItemData.EquipmentSlot.OFF_HAND: Vector2(EQUIPMENT_CENTER_X + EQUIPMENT_SPACING_X, 200),  # Right side - off hand
		ItemData.EquipmentSlot.GLOVES: Vector2(EQUIPMENT_CENTER_X, 290),  # Below chest - gloves
		ItemData.EquipmentSlot.RING_1: Vector2(EQUIPMENT_CENTER_X - EQUIPMENT_RING_OFFSET, 380),  # Below gloves left - ring 1
		ItemData.EquipmentSlot.RING_2: Vector2(EQUIPMENT_CENTER_X + EQUIPMENT_RING_OFFSET, 380),  # Below gloves right - ring 2
		ItemData.EquipmentSlot.LEGS: Vector2(EQUIPMENT_CENTER_X, 470),  # Below rings - legs
		ItemData.EquipmentSlot.BOOTS: Vector2(EQUIPMENT_CENTER_X, 560),  # Bottom - boots
	}
	
	# Create a slot panel for each equipment slot
	# Note: Iteration order doesn't matter since we use absolute positioning
	for slot in slot_positions:
		var position: Vector2 = slot_positions[slot]
		var slot_button := Button.new()
		slot_button.custom_minimum_size = EQUIPMENT_SLOT_SIZE
		slot_button.position = position - EQUIPMENT_SLOT_SIZE / 2  # Center the panel on position
		
		# Create VBox for slot content
		var vbox := VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		slot_button.add_child(vbox)
		
		var slot_name := _get_equipment_slot_name(slot)
		var slot_label := Label.new()
		slot_label.text = slot_name
		slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot_label.add_theme_font_size_override("font_size", EQUIPMENT_SLOT_LABEL_FONT_SIZE)
		slot_label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
		slot_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.add_child(slot_label)
		
		var equipped_item_id := Equipment.get_equipped_item(slot)
		var equipped_label := Label.new()
		equipped_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		equipped_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if equipped_item_id != "":
			var item_data := Inventory.get_item_data(equipped_item_id)
			equipped_label.text = item_data.name if item_data else equipped_item_id
			equipped_label.add_theme_color_override("font_color", Color(0.5, 1.0, 0.5))
			equipped_label.add_theme_font_size_override("font_size", EQUIPMENT_ITEM_LABEL_FONT_SIZE)
			# Make button clickable to unequip
			slot_button.pressed.connect(_on_unequip_from_slot.bind(slot))
		else:
			equipped_label.text = "Empty"
			equipped_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			equipped_label.add_theme_font_size_override("font_size", EQUIPMENT_ITEM_LABEL_FONT_SIZE)
			slot_button.disabled = true
		
		vbox.add_child(equipped_label)
		equipment_slots_container.add_child(slot_button)

## Get human-readable equipment slot name
func _get_equipment_slot_name(slot: ItemData.EquipmentSlot) -> String:
	match slot:
		ItemData.EquipmentSlot.HELM: return "Helm"
		ItemData.EquipmentSlot.NECKLACE: return "Necklace"
		ItemData.EquipmentSlot.CHEST: return "Chest"
		ItemData.EquipmentSlot.GLOVES: return "Gloves"
		ItemData.EquipmentSlot.RING_1: return "Ring 1"
		ItemData.EquipmentSlot.RING_2: return "Ring 2"
		ItemData.EquipmentSlot.MAIN_HAND: return "Main Hand"
		ItemData.EquipmentSlot.OFF_HAND: return "Off Hand"
		ItemData.EquipmentSlot.LEGS: return "Legs"
		ItemData.EquipmentSlot.ARROWS: return "Arrows"
		ItemData.EquipmentSlot.BOOTS: return "Boots"
		_: return "Unknown"

## Handle unequip from slot
func _on_unequip_from_slot(slot: ItemData.EquipmentSlot) -> void:
	Equipment.unequip_item(slot)

## Handle equipment changed signal
func _on_equipment_changed(_slot: ItemData.EquipmentSlot) -> void:
	if is_equipment_view:
		_populate_equipment_slots()

## Handle inventory button click
func _on_inventory_selected() -> void:
	is_upgrades_view = false
	is_inventory_view = true
	is_equipment_view = false
	is_skill_summary_view = false
	_hide_skill_view()
	_show_inventory_view()
	# Set to main tab if no tab selected
	if inventory_current_tab.is_empty():
		inventory_current_tab = Inventory.MAIN_TAB_ID
	_populate_inventory_tabs()
	_on_inventory_updated()

## Show inventory view
func _show_inventory_view() -> void:
	# Hide other special panels
	if upgrades_panel:
		upgrades_panel.visible = false
	if equipment_panel_view:
		equipment_panel_view.visible = false
	if skill_summary_panel:
		skill_summary_panel.visible = false
	# Show inventory panel
	if inventory_panel_view:
		inventory_panel_view.visible = true
	
	# Hide skill-related UI elements
	_hide_skill_ui()

## Show skill view
func _show_skill_view() -> void:
	# Hide special panels
	if upgrades_panel:
		upgrades_panel.visible = false
	if inventory_panel_view:
		inventory_panel_view.visible = false
	if equipment_panel_view:
		equipment_panel_view.visible = false
	if skill_summary_panel:
		skill_summary_panel.visible = false
	# Inventory panel stays hidden in skill view - use dedicated inventory screen instead
	inventory_panel.visible = false
	
	# Show skill-related UI elements
	_show_skill_ui()

## Hide skill view
func _hide_skill_view() -> void:
	# Nothing to hide - inventory panel is already hidden
	pass

## Helper function to hide skill-related UI elements
func _hide_skill_ui() -> void:
	selected_skill_header.visible = false
	action_list_label.visible = false
	action_list_panel.visible = false

## Helper function to show skill-related UI elements
func _show_skill_ui() -> void:
	selected_skill_header.visible = true
	action_list_label.visible = true
	action_list_panel.visible = true

## Update gold display when gold changes
func _on_gold_changed(new_amount: int) -> void:
	_update_total_stats()
	
	# Update gold label in upgrades panel
	if upgrades_gold_label:
		upgrades_gold_label.text = "Gold: %d" % new_amount

## Create Upgrades Shop UI
func _create_upgrades_ui() -> void:
	# Create upgrades panel (hidden by default)
	upgrades_panel = PanelContainer.new()
	upgrades_panel.name = "UpgradesPanel"
	upgrades_panel.visible = false
	upgrades_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var upgrades_vbox := VBoxContainer.new()
	upgrades_panel.add_child(upgrades_vbox)
	
	# Upgrades header with checkbox
	var header_hbox := HBoxContainer.new()
	upgrades_vbox.add_child(header_hbox)
	
	# Hide owned checkbox on the left
	upgrades_hide_owned_checkbox = CheckBox.new()
	upgrades_hide_owned_checkbox.text = "Hide Owned"
	upgrades_hide_owned_checkbox.button_pressed = hide_owned_upgrades
	upgrades_hide_owned_checkbox.toggled.connect(_on_hide_owned_toggled)
	header_hbox.add_child(upgrades_hide_owned_checkbox)
	
	# Upgrades title in the center
	var upgrades_header := Label.new()
	upgrades_header.text = "Upgrades"
	upgrades_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	upgrades_header.add_theme_font_size_override("font_size", 20)
	upgrades_header.add_theme_color_override("font_color", Color(0.5, 0.8, 1.0))
	upgrades_header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_hbox.add_child(upgrades_header)
	
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

## Create Skill Summary UI
func _create_skill_summary_ui() -> void:
	# Create skill summary panel (hidden by default)
	skill_summary_panel = PanelContainer.new()
	skill_summary_panel.name = "SkillSummaryPanel"
	skill_summary_panel.visible = false
	skill_summary_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var summary_vbox := VBoxContainer.new()
	skill_summary_panel.add_child(summary_vbox)
	
	# Skill Summary header
	var summary_header := Label.new()
	summary_header.text = "Skill Summary"
	summary_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	summary_header.add_theme_font_size_override("font_size", 20)
	summary_header.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	summary_vbox.add_child(summary_header)
	
	# Scroll container for grid
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	summary_vbox.add_child(scroll)
	
	# Grid container for skills
	skill_summary_grid = GridContainer.new()
	skill_summary_grid.columns = 3
	skill_summary_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(skill_summary_grid)
	
	# Add to main content
	main_content.add_child(skill_summary_panel)
	main_content.move_child(skill_summary_panel, inventory_panel.get_index() + 1)

## Show upgrades view
func _on_upgrades_selected() -> void:
	is_upgrades_view = true
	is_inventory_view = false
	is_equipment_view = false
	is_skill_summary_view = false
	_hide_skill_view()
	_show_upgrades_view()
	_populate_upgrades_list()

## Show upgrades view
func _show_upgrades_view() -> void:
	# Hide other special panels
	if inventory_panel_view:
		inventory_panel_view.visible = false
	if equipment_panel_view:
		equipment_panel_view.visible = false
	if skill_summary_panel:
		skill_summary_panel.visible = false
	# Show upgrades panel
	if upgrades_panel:
		upgrades_panel.visible = true
	
	# Hide skill-related UI elements
	_hide_skill_ui()

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
		
		# Filter out owned upgrades if hide_owned_upgrades is true
		var filtered_upgrades: Array[UpgradeData] = []
		if hide_owned_upgrades:
			filtered_upgrades = skill_upgrades.filter(func(upgrade): return not UpgradeShop.is_purchased(upgrade.id))
		else:
			filtered_upgrades = skill_upgrades
		
		# Skip this skill if all upgrades are filtered out
		if filtered_upgrades.is_empty():
			continue
		
		# Add skill header
		var skill_header := Label.new()
		skill_header.text = skill.name
		skill_header.add_theme_font_size_override("font_size", 16)
		skill_header.add_theme_color_override("font_color", skill.color)
		upgrades_list.add_child(skill_header)
		
		# Add upgrades for this skill
		for upgrade in filtered_upgrades:
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

## Handle hide owned checkbox toggled
func _on_hide_owned_toggled(button_pressed: bool) -> void:
	hide_owned_upgrades = button_pressed
	_populate_upgrades_list()

## Handle upgrade purchased signal
func _on_upgrade_purchased(upgrade_id: String) -> void:
	var upgrade: UpgradeData = UpgradeShop.upgrades.get(upgrade_id)
	if upgrade:
		print("[Main] Purchased upgrade: %s for %s" % [upgrade.name, upgrade.skill_id])
		# Refresh skill display and action list if viewing the skill that was upgraded
		if selected_skill_id == upgrade.skill_id:
			_update_skill_display()
			_populate_action_list()

## Handle upgrades updated signal
func _on_upgrades_updated() -> void:
	if is_upgrades_view:
		_populate_upgrades_list()

## Handle skill summary button click
func _on_skill_summary_selected() -> void:
	is_upgrades_view = false
	is_inventory_view = false
	is_equipment_view = false
	is_skill_summary_view = true
	_hide_skill_view()
	_show_skill_summary_view()
	_populate_skill_summary()

## Show skill summary panel and hide others
func _show_skill_summary_view() -> void:
	# Hide other special panels
	if upgrades_panel:
		upgrades_panel.visible = false
	if inventory_panel_view:
		inventory_panel_view.visible = false
	if equipment_panel_view:
		equipment_panel_view.visible = false
	# Show skill summary panel
	if skill_summary_panel:
		skill_summary_panel.visible = true
	
	# Hide skill-related UI elements
	_hide_skill_ui()

## Populate skill summary grid
func _populate_skill_summary() -> void:
	if not skill_summary_grid:
		return
	
	# Clear existing items
	for child in skill_summary_grid.get_children():
		child.queue_free()
	
	# Add each skill to the grid
	for skill_id in GameManager.skills:
		var skill: SkillData = GameManager.skills[skill_id]
		var level := GameManager.get_skill_level(skill_id)
		
		# Create a panel for each skill
		var skill_panel := PanelContainer.new()
		skill_panel.custom_minimum_size = Vector2(100, 80)
		
		var vbox := VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		skill_panel.add_child(vbox)
		
		# Skill name
		var name_label := Label.new()
		name_label.text = skill.name
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size", 12)
		name_label.add_theme_color_override("font_color", skill.color)
		vbox.add_child(name_label)
		
		# Level display
		var level_label := Label.new()
		level_label.text = "%d/99" % level
		level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		level_label.add_theme_font_size_override("font_size", 16)
		vbox.add_child(level_label)
		
		skill_summary_grid.add_child(skill_panel)

## Toggle sidebar visibility
func _on_sidebar_toggle_pressed() -> void:
	print("Sidebar toggle pressed! Current state: ", is_sidebar_expanded)
	is_sidebar_expanded = not is_sidebar_expanded
	_set_sidebar_collapsed(not is_sidebar_expanded)
	print("New state: ", is_sidebar_expanded)

## Set sidebar collapsed/expanded state
func _set_sidebar_collapsed(collapsed: bool) -> void:
	skill_sidebar.visible = not collapsed
	is_sidebar_expanded = not collapsed
	
	# Update toggle button text
	if collapsed:
		menu_button.text = "☰"
	else:
		menu_button.text = "✕"

## Handle change character button pressed
func _on_change_character_pressed() -> void:
	# Stop any active training
	if GameManager.is_training:
		GameManager.stop_training()
	
	# Save the current game state
	SaveManager.save_game()
	
	# Disable auto-save while transitioning
	SaveManager.auto_save_enabled = false
	
	# Reset current character slot
	CharacterManager.current_slot = -1
	
	# Change back to startup scene
	get_tree().change_scene_to_file("res://scenes/startup.tscn")

## Populate inventory tabs
func _populate_inventory_tabs() -> void:
	if not inventory_tab_bar:
		return
	
	# Clear existing tab buttons
	for child in inventory_tab_bar.get_children():
		child.queue_free()
	inventory_tab_buttons.clear()
	
	# Create button for each tab
	for tab_id in Inventory.tab_order:
		var tab_button := Button.new()
		tab_button.custom_minimum_size = Vector2(80, 30)
		tab_button.text = Inventory.get_tab_name(tab_id)
		tab_button.toggle_mode = true
		tab_button.button_pressed = (tab_id == inventory_current_tab)
		tab_button.pressed.connect(_on_tab_selected.bind(tab_id))
		
		# Enable drop detection for moving items between tabs
		tab_button.mouse_filter = Control.MOUSE_FILTER_PASS
		tab_button.gui_input.connect(_on_tab_gui_input.bind(tab_id))
		
		# Add context menu for non-main tabs
		if tab_id != Inventory.MAIN_TAB_ID:
			tab_button.mouse_entered.connect(_on_tab_mouse_entered.bind(tab_button, tab_id))
		
		inventory_tab_bar.add_child(tab_button)
		inventory_tab_buttons[tab_id] = tab_button

## Handle tab selection
func _on_tab_selected(tab_id: String) -> void:
	inventory_current_tab = tab_id
	_populate_inventory_tabs()  # Refresh tab buttons to update pressed state
	_on_inventory_updated()

## Handle add tab button pressed
func _on_add_tab_pressed() -> void:
	var tab_name := "Tab %d" % (Inventory.tab_order.size())
	Inventory.create_tab(tab_name)

## Handle tab created signal
func _on_tab_created(_tab_id: String, _tab_name: String) -> void:
	_populate_inventory_tabs()

## Handle tab deleted signal
func _on_tab_deleted(tab_id: String) -> void:
	# Switch to main tab if current tab was deleted
	if inventory_current_tab == tab_id:
		inventory_current_tab = Inventory.MAIN_TAB_ID
	_populate_inventory_tabs()
	_on_inventory_updated()

## Handle tab renamed signal
func _on_tab_renamed(_tab_id: String, _new_name: String) -> void:
	_populate_inventory_tabs()

## Handle mouse entered on tab for context menu
func _on_tab_mouse_entered(tab_button: Button, tab_id: String) -> void:
	# Add right-click context menu for rename/delete
	if not tab_button.is_connected("gui_input", _on_tab_context_menu):
		tab_button.gui_input.connect(_on_tab_context_menu.bind(tab_id))

## Handle tab context menu (right-click)
func _on_tab_context_menu(event: InputEvent, tab_id: String) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_show_tab_context_menu(tab_id)

## Show tab context menu
func _show_tab_context_menu(tab_id: String) -> void:
	# Create a simple popup menu
	var popup := PopupMenu.new()
	popup.add_item("Rename", 0)
	popup.add_item("Delete", 1)
	popup.id_pressed.connect(_on_tab_context_option.bind(tab_id, popup))
	add_child(popup)
	popup.popup_centered()

## Handle tab context menu option selected
func _on_tab_context_option(option_id: int, tab_id: String, popup: PopupMenu) -> void:
	if option_id == 0:  # Rename
		_show_rename_tab_dialog(tab_id)
	elif option_id == 1:  # Delete
		Inventory.delete_tab(tab_id)
	popup.queue_free()

## Show rename tab dialog
func _show_rename_tab_dialog(tab_id: String) -> void:
	# Create a simple dialog with LineEdit
	var dialog := AcceptDialog.new()
	dialog.title = "Rename Tab"
	dialog.dialog_text = "Enter new name for tab:"
	
	var line_edit := LineEdit.new()
	line_edit.text = Inventory.get_tab_name(tab_id)
	line_edit.custom_minimum_size = Vector2(200, 0)
	dialog.add_child(line_edit)
	
	dialog.confirmed.connect(func(): 
		Inventory.rename_tab(tab_id, line_edit.text)
		dialog.queue_free()
	)
	dialog.canceled.connect(func(): dialog.queue_free())
	
	add_child(dialog)
	dialog.popup_centered()

## Handle GUI input on items for drag detection
func _on_item_gui_input(event: InputEvent, item_id: String, from_tab: String) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Start drag
			var amount := Inventory.get_item_count_in_tab(from_tab, item_id)
			dragging_item = {
				"item_id": item_id,
				"from_tab": from_tab,
				"amount": amount
			}
			_create_drag_preview(item_id)
	elif event is InputEventMouseMotion and not dragging_item.is_empty():
		# Update drag preview position
		if drag_preview:
			drag_preview.global_position = get_global_mouse_position() - drag_preview.size / 2

## Handle GUI input on tabs for drop detection
func _on_tab_gui_input(event: InputEvent, to_tab: String) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			# Drop item on tab
			if not dragging_item.is_empty():
				var item_id: String = dragging_item["item_id"]
				var from_tab: String = dragging_item["from_tab"]
				var amount: int = dragging_item["amount"]
				
				if Inventory.move_item_between_tabs(item_id, from_tab, to_tab, amount):
					print("[Main] Moved %d x %s from %s to %s" % [amount, item_id, from_tab, to_tab])
				
				_end_drag()

## Create drag preview visual
func _create_drag_preview(item_id: String) -> void:
	if drag_preview:
		drag_preview.queue_free()
	
	var item_data := Inventory.get_item_data(item_id)
	if not item_data:
		return
	
	drag_preview = PanelContainer.new()
	drag_preview.z_index = 1000
	drag_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	drag_preview.add_child(vbox)
	
	if item_data.icon:
		var icon := TextureRect.new()
		icon.texture = item_data.icon
		icon.custom_minimum_size = Vector2(48, 48)
		icon.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		vbox.add_child(icon)
	
	var label := Label.new()
	label.text = item_data.name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label)
	
	add_child(drag_preview)
	drag_preview.global_position = get_global_mouse_position() - Vector2(24, 24)

## End drag operation
func _end_drag() -> void:
	dragging_item.clear()
	if drag_preview:
		drag_preview.queue_free()
		drag_preview = null

## Handle input for global drag end
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if not dragging_item.is_empty():
				_end_drag()
