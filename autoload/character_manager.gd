## CharacterManager Autoload
## Handles character slot management (max 3 characters)
extends Node

const MAX_CHARACTERS := 3
const CHARACTERS_FILE := "user://idlescapers_characters.json"

signal character_created(slot: int, character_name: String)
signal character_deleted(slot: int)
signal character_selected(slot: int)

## Character data structure
## {
##   "slot": int,
##   "name": String,
##   "created_at": int (unix timestamp),
##   "last_played": int (unix timestamp),
##   "total_level": int,
##   "total_xp": float
## }
var characters: Dictionary = {}  # slot_index: character_data

## Currently selected character slot (-1 means no character selected)
var current_slot: int = -1

func _ready() -> void:
	load_characters()
	_migrate_old_save_if_exists()

## Load character list from file
func load_characters() -> void:
	if not FileAccess.file_exists(CHARACTERS_FILE):
		print("[CharacterManager] No characters file found, starting fresh.")
		characters.clear()
		return
	
	var file := FileAccess.open(CHARACTERS_FILE, FileAccess.READ)
	if not file:
		print("[CharacterManager] Failed to open characters file.")
		return
	
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error != OK:
		print("[CharacterManager] Failed to parse characters file: ", json.get_error_message())
		return
	
	characters = json.data
	print("[CharacterManager] Loaded %d characters." % characters.size())

## Save character list to file
func save_characters() -> void:
	var file := FileAccess.open(CHARACTERS_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(characters, "\t"))
		file.close()
		print("[CharacterManager] Characters saved.")

## Create a new character in the specified slot
func create_character(slot: int, character_name: String) -> bool:
	if slot < 0 or slot >= MAX_CHARACTERS:
		print("[CharacterManager] Invalid slot: %d" % slot)
		return false
	
	if characters.has(str(slot)):
		print("[CharacterManager] Slot %d already occupied." % slot)
		return false
	
	if character_name.strip_edges().is_empty():
		print("[CharacterManager] Character name cannot be empty.")
		return false
	
	var now := int(Time.get_unix_time_from_system())
	
	# Calculate initial total level (number of skills at level 1)
	var initial_total_level := GameManager.skills.size()
	
	var character_data := {
		"slot": slot,
		"name": character_name.strip_edges(),
		"created_at": now,
		"last_played": now,
		"total_level": initial_total_level,
		"total_xp": 0.0
	}
	
	characters[str(slot)] = character_data
	save_characters()
	character_created.emit(slot, character_name)
	print("[CharacterManager] Created character '%s' in slot %d." % [character_name, slot])
	return true

## Delete a character from the specified slot
func delete_character(slot: int) -> bool:
	if slot < 0 or slot >= MAX_CHARACTERS:
		print("[CharacterManager] Invalid slot: %d" % slot)
		return false
	
	if not characters.has(str(slot)):
		print("[CharacterManager] No character in slot %d." % slot)
		return false
	
	# Delete the save file for this character
	var save_file := _get_save_file_path(slot)
	if FileAccess.file_exists(save_file):
		DirAccess.remove_absolute(save_file)
		print("[CharacterManager] Deleted save file: %s" % save_file)
	
	characters.erase(str(slot))
	save_characters()
	character_deleted.emit(slot)
	print("[CharacterManager] Deleted character in slot %d." % slot)
	return true

## Select a character to play
func select_character(slot: int) -> bool:
	if slot < 0 or slot >= MAX_CHARACTERS:
		print("[CharacterManager] Invalid slot: %d" % slot)
		return false
	
	if not characters.has(str(slot)):
		print("[CharacterManager] No character in slot %d." % slot)
		return false
	
	current_slot = slot
	
	# Update last played time
	characters[str(slot)]["last_played"] = int(Time.get_unix_time_from_system())
	save_characters()
	
	character_selected.emit(slot)
	print("[CharacterManager] Selected character in slot %d." % slot)
	return true

## Get character data for a slot
func get_character(slot: int) -> Dictionary:
	return characters.get(str(slot), {})

## Get all characters
func get_all_characters() -> Dictionary:
	return characters.duplicate()

## Check if a slot is occupied
func is_slot_occupied(slot: int) -> bool:
	return characters.has(str(slot))

## Get the number of characters
func get_character_count() -> int:
	return characters.size()

## Check if max characters reached
func is_max_characters_reached() -> bool:
	return characters.size() >= MAX_CHARACTERS

## Get save file path for a character slot
func _get_save_file_path(slot: int) -> String:
	return "user://idlescapers_save_slot_%d.json" % slot

## Get current character's save file path
func get_current_save_file() -> String:
	if current_slot < 0:
		return ""
	return _get_save_file_path(current_slot)

## Update character stats (called by SaveManager after save)
func update_character_stats(slot: int, total_level: int, total_xp: float) -> void:
	if characters.has(str(slot)):
		characters[str(slot)]["total_level"] = total_level
		characters[str(slot)]["total_xp"] = total_xp
		characters[str(slot)]["last_played"] = int(Time.get_unix_time_from_system())
		save_characters()

## Migrate old save file to slot 0 if it exists
func _migrate_old_save_if_exists() -> void:
	const OLD_SAVE_FILE := "user://idlescapers_save.json"
	
	# Only migrate if old save exists and we have no characters
	if FileAccess.file_exists(OLD_SAVE_FILE) and characters.is_empty():
		print("[CharacterManager] Found old save file. Migrating to slot 0...")
		
		# Read old save to get actual total level and XP
		var old_file := FileAccess.open(OLD_SAVE_FILE, FileAccess.READ)
		var total_level := GameManager.skills.size()  # Default to initial level
		var total_xp := 0.0
		
		if old_file:
			var json_string := old_file.get_as_text()
			old_file.close()
			
			var json := JSON.new()
			if json.parse(json_string) == OK:
				var save_data: Dictionary = json.data
				
				# Calculate total level from old save
				if save_data.has("skill_levels"):
					total_level = 0
					for skill_id in save_data["skill_levels"]:
						total_level += int(save_data["skill_levels"][skill_id])
				
				# Calculate total XP from old save
				if save_data.has("skill_xp"):
					total_xp = 0.0
					for skill_id in save_data["skill_xp"]:
						total_xp += save_data["skill_xp"][skill_id]
		
		# Create a character in slot 0
		var now := int(Time.get_unix_time_from_system())
		var character_data := {
			"slot": 0,
			"name": "Legacy Character",
			"created_at": now,
			"last_played": now,
			"total_level": total_level,
			"total_xp": total_xp
		}
		
		characters["0"] = character_data
		save_characters()
		
		# Copy old save file to new slot 0 save file
		var new_save_file := _get_save_file_path(0)
		var copy_file := FileAccess.open(OLD_SAVE_FILE, FileAccess.READ)
		if copy_file:
			var content := copy_file.get_as_text()
			copy_file.close()
			
			var new_file := FileAccess.open(new_save_file, FileAccess.WRITE)
			if new_file:
				new_file.store_string(content)
				new_file.close()
				print("[CharacterManager] Successfully migrated old save to slot 0.")
				
				# Delete old save file
				DirAccess.remove_absolute(OLD_SAVE_FILE)
				print("[CharacterManager] Removed old save file.")
