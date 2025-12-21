## Startup screen controller
## Handles character selection, creation, and deletion
extends Control

const MAIN_SCENE := "res://scenes/main.tscn"
const LOGIN_SCENE := "res://scenes/login.tscn"
const MAX_CHARACTERS := 3

@onready var character_slots_container: VBoxContainer = $CenterContainer/MainPanel/VBoxContainer/CharacterSlots
@onready var create_dialog: PanelContainer = $CreateCharacterDialog
@onready var character_name_input: LineEdit = $CreateCharacterDialog/VBoxContainer/NameInput
@onready var create_button: Button = $CreateCharacterDialog/VBoxContainer/ButtonsContainer/CreateButton
@onready var cancel_button: Button = $CreateCharacterDialog/VBoxContainer/ButtonsContainer/CancelButton
@onready var delete_dialog: AcceptDialog = $DeleteConfirmDialog
@onready var account_label: Label = $CenterContainer/MainPanel/VBoxContainer/AccountLabel
@onready var logout_button: Button = $CenterContainer/MainPanel/VBoxContainer/LogoutButton

var selected_slot: int = -1
var slot_buttons: Array[Button] = []

## Helper function to format timestamp
## Returns "Unknown" for zero timestamps, otherwise returns datetime string
func _format_timestamp(timestamp: int) -> String:
	if timestamp == 0:
		return "Unknown"
	return Time.get_datetime_string_from_unix_time(timestamp)

func _ready() -> void:
	# Check if user is logged in
	if not AccountManager.is_logged_in():
		print("[Startup] No user logged in, redirecting to login screen.")
		get_tree().change_scene_to_file(LOGIN_SCENE)
		return
	
	print("[Startup] User logged in: %s" % AccountManager.current_username)
	
	# Update account label
	account_label.text = "Logged in as: %s" % AccountManager.current_username
	
	# Setup dialogs
	create_dialog.visible = false
	delete_dialog.visible = false
	
	# Connect dialog buttons
	create_button.pressed.connect(_on_create_confirmed)
	cancel_button.pressed.connect(_on_create_canceled)
	delete_dialog.confirmed.connect(_on_delete_confirmed)
	logout_button.pressed.connect(_on_logout_pressed)
	
	# Populate character slots
	_populate_character_slots()
	
	# Connect to CharacterManager signals
	CharacterManager.character_created.connect(_on_character_created)
	CharacterManager.character_deleted.connect(_on_character_deleted)

func _populate_character_slots() -> void:
	# Clear existing slot buttons
	for child in character_slots_container.get_children():
		child.queue_free()
	slot_buttons.clear()
	
	# Get character slots for current account
	var account_slots: Array = AccountManager.get_character_slots()
	
	# Create buttons for each slot
	for slot in range(MAX_CHARACTERS):
		var slot_panel := PanelContainer.new()
		slot_panel.custom_minimum_size = Vector2(0, 100)
		
		var hbox := HBoxContainer.new()
		slot_panel.add_child(hbox)
		
		# Character info area
		var info_vbox := VBoxContainer.new()
		info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(info_vbox)
		
		var character_data := CharacterManager.get_character(slot)
		var is_account_slot: bool = account_slots.has(slot)
		
		# Show character if it belongs to current account, or show empty slot if not occupied
		if character_data.is_empty():
			# Empty slot
			var empty_label := Label.new()
			empty_label.text = "Slot %d - Empty" % (slot + 1)
			empty_label.add_theme_font_size_override("font_size", 18)
			empty_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			info_vbox.add_child(empty_label)
			
			# Create button
			var create_btn := Button.new()
			create_btn.text = "Create\nCharacter"
			create_btn.custom_minimum_size = Vector2(100, 80)
			create_btn.pressed.connect(_on_create_character_pressed.bind(slot))
			hbox.add_child(create_btn)
		elif is_account_slot:
			# Occupied slot belonging to current account
			var name_label := Label.new()
			name_label.text = character_data.get("name", "Unknown")
			name_label.add_theme_font_size_override("font_size", 20)
			info_vbox.add_child(name_label)
			
			var stats_label := Label.new()
			stats_label.text = "Total Level: %d | Total XP: %.0f" % [
				character_data.get("total_level", 0),
				character_data.get("total_xp", 0.0)
			]
			stats_label.add_theme_font_size_override("font_size", 12)
			stats_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
			info_vbox.add_child(stats_label)
			
			var created_timestamp: int = character_data.get("created_at", 0)
			var created_label := Label.new()
			created_label.text = "Created: %s" % _format_timestamp(created_timestamp)
			created_label.add_theme_font_size_override("font_size", 10)
			created_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
			info_vbox.add_child(created_label)
			
			var last_played_timestamp: int = character_data.get("last_played", 0)
			var last_played_label := Label.new()
			last_played_label.text = "Last Played: %s" % _format_timestamp(last_played_timestamp)
			last_played_label.add_theme_font_size_override("font_size", 10)
			last_played_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
			info_vbox.add_child(last_played_label)
			
			# Buttons container
			var buttons_vbox := VBoxContainer.new()
			hbox.add_child(buttons_vbox)
			
			# Play button
			var play_btn := Button.new()
			play_btn.text = "Play"
			play_btn.custom_minimum_size = Vector2(100, 40)
			play_btn.pressed.connect(_on_play_character_pressed.bind(slot))
			buttons_vbox.add_child(play_btn)
			
			# Delete button
			var delete_btn := Button.new()
			delete_btn.text = "Delete"
			delete_btn.custom_minimum_size = Vector2(100, 40)
			delete_btn.add_theme_color_override("font_color", Color(0.8, 0.3, 0.3))
			delete_btn.pressed.connect(_on_delete_character_pressed.bind(slot))
			buttons_vbox.add_child(delete_btn)
		else:
			# Slot occupied by another account - show as unavailable
			var unavailable_label := Label.new()
			unavailable_label.text = "Slot %d - Unavailable" % (slot + 1)
			unavailable_label.add_theme_font_size_override("font_size", 16)
			unavailable_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			info_vbox.add_child(unavailable_label)
		
		character_slots_container.add_child(slot_panel)

func _on_create_character_pressed(slot: int) -> void:
	selected_slot = slot
	character_name_input.text = ""
	create_dialog.visible = true
	character_name_input.grab_focus()

func _on_create_confirmed() -> void:
	var character_name := character_name_input.text.strip_edges()
	
	if character_name.is_empty():
		print("[Startup] Character name cannot be empty.")
		return
	
	# Enforce 20-character limit
	if character_name.length() > 20:
		print("[Startup] Character name too long (max 20 characters).")
		return
	
	if CharacterManager.create_character(selected_slot, character_name):
		# Link character slot to current account
		AccountManager.add_character_slot(selected_slot)
		create_dialog.visible = false
		_populate_character_slots()
	else:
		print("[Startup] Failed to create character '%s' in slot %d. Slot may already be occupied." % [character_name, selected_slot])

func _on_create_canceled() -> void:
	create_dialog.visible = false
	selected_slot = -1

func _on_play_character_pressed(slot: int) -> void:
	if CharacterManager.select_character(slot):
		# Load the character's save data
		SaveManager.load_game()
		
		# Change to main game scene
		get_tree().change_scene_to_file(MAIN_SCENE)

func _on_delete_character_pressed(slot: int) -> void:
	selected_slot = slot
	var character_data := CharacterManager.get_character(slot)
	var character_name: String = character_data.get("name", "Unknown")
	delete_dialog.dialog_text = "Are you sure you want to delete '%s'?\nThis action cannot be undone!" % character_name
	delete_dialog.popup_centered()

func _on_delete_confirmed() -> void:
	if selected_slot >= 0:
		CharacterManager.delete_character(selected_slot)
		# Remove character slot from current account
		AccountManager.remove_character_slot(selected_slot)
		_populate_character_slots()
		selected_slot = -1

func _on_character_created(slot: int, character_name: String) -> void:
	print("[Startup] Character created: %s in slot %d" % [character_name, slot])

func _on_character_deleted(slot: int) -> void:
	print("[Startup] Character deleted from slot %d" % slot)

func _on_logout_pressed() -> void:
	AccountManager.logout()
	get_tree().change_scene_to_file(LOGIN_SCENE)
