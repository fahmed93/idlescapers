## Main game scene controller
extends Control

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

func _ready() -> void:
	_setup_signals()
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
	stop_button.pressed.connect(_on_stop_button_pressed)

func _process(_delta: float) -> void:
	if GameManager.is_training:
		_update_training_progress()

func _populate_skill_sidebar() -> void:
	# Clear existing buttons
	for child in skill_sidebar.get_children():
		if child is Button:
			child.queue_free()
	skill_buttons.clear()
	
	# Create a button for each skill
	for skill_id in GameManager.skills:
		var skill: SkillData = GameManager.skills[skill_id]
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, 60)
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
	selected_skill_id = skill_id
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
	# Clear inventory grid
	for child in inventory_list.get_children():
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
		
		inventory_list.add_child(item_panel)

func _update_total_stats() -> void:
	var total_level := GameManager.get_total_level()
	var total_xp := GameManager.get_total_xp()
	var inventory_value := Inventory.get_total_value()
	total_stats_label.text = "Total Level: %d | Total XP: %.0f | Inventory Value: %d" % [total_level, total_xp, inventory_value]

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
