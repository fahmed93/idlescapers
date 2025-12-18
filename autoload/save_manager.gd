## SaveManager Autoload
## Handles saving, loading, and offline progress
extends Node

const SAVE_VERSION := 1

signal save_completed()
signal load_completed()
signal offline_progress_calculated(time_away: float, actions_completed: int, xp_gained: Dictionary)

## Auto-save interval in seconds
var auto_save_interval := 30.0
var _auto_save_timer := 0.0

## Last save timestamp for offline progress
var last_save_time: int = 0

## Whether auto-save is enabled (disabled until character is selected)
var auto_save_enabled: bool = false

func _ready() -> void:
	# Don't auto-load - wait for character selection
	pass

func _process(delta: float) -> void:
	if not auto_save_enabled:
		return
	
	_auto_save_timer += delta
	if _auto_save_timer >= auto_save_interval:
		_auto_save_timer = 0.0
		save_game()

## Save the game
func save_game() -> void:
	# Get save file path from CharacterManager
	var save_file := CharacterManager.get_current_save_file()
	if save_file.is_empty():
		print("[SaveManager] No character selected, cannot save.")
		return
	
	var save_data := {
		"version": SAVE_VERSION,
		"timestamp": Time.get_unix_time_from_system(),
		"skill_xp": GameManager.skill_xp.duplicate(),
		"skill_levels": GameManager.skill_levels.duplicate(),
		"inventory": Inventory.inventory.duplicate(),
		"current_skill_id": GameManager.current_skill_id,
		"current_method_id": GameManager.current_method_id,
		"is_training": GameManager.is_training,
		"gold": Store.gold,
		"purchased_upgrades": UpgradeShop.purchased_upgrades.duplicate(),
	}
	
	var file := FileAccess.open(save_file, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		last_save_time = save_data["timestamp"]
		
		# Update character stats in CharacterManager
		CharacterManager.update_character_stats(
			CharacterManager.current_slot,
			GameManager.get_total_level(),
			GameManager.get_total_xp()
		)
		
		save_completed.emit()
		print("[SaveManager] Game saved to slot %d at %s" % [
			CharacterManager.current_slot,
			Time.get_datetime_string_from_unix_time(last_save_time)
		])

## Load the game for the current character
func load_game() -> void:
	# Get save file path from CharacterManager
	var save_file := CharacterManager.get_current_save_file()
	if save_file.is_empty():
		print("[SaveManager] No character selected, cannot load.")
		return
	
	if not FileAccess.file_exists(save_file):
		print("[SaveManager] No save file found for slot %d, starting fresh." % CharacterManager.current_slot)
		_reset_game_state()
		auto_save_enabled = true
		return
	
	var file := FileAccess.open(save_file, FileAccess.READ)
	if not file:
		print("[SaveManager] Failed to open save file.")
		return
	
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error != OK:
		print("[SaveManager] Failed to parse save file: ", json.get_error_message())
		return
	
	var save_data: Dictionary = json.data
	
	# Restore skill progress
	if save_data.has("skill_xp"):
		for skill_id in save_data["skill_xp"]:
			GameManager.skill_xp[skill_id] = save_data["skill_xp"][skill_id]
	
	if save_data.has("skill_levels"):
		for skill_id in save_data["skill_levels"]:
			GameManager.skill_levels[skill_id] = int(save_data["skill_levels"][skill_id])
	
	# Restore inventory
	if save_data.has("inventory"):
		Inventory.inventory.clear()
		for item_id in save_data["inventory"]:
			Inventory.inventory[item_id] = int(save_data["inventory"][item_id])
	
	# Restore gold
	if save_data.has("gold"):
		Store.gold = int(save_data["gold"])
	
	# Restore purchased upgrades
	if save_data.has("purchased_upgrades"):
		UpgradeShop.purchased_upgrades.clear()
		for upgrade_id in save_data["purchased_upgrades"]:
			UpgradeShop.purchased_upgrades.append(upgrade_id)
	
	# Calculate offline progress
	if save_data.has("timestamp"):
		last_save_time = int(save_data["timestamp"])
		var current_time := int(Time.get_unix_time_from_system())
		var time_away := current_time - last_save_time
		
		# Validate timestamp - if it's in the future or unreasonably far in the past, skip offline progress
		if time_away < 0:
			print("[SaveManager] Warning: Save timestamp is in the future. Skipping offline progress.")
			time_away = 0
		elif time_away > 31536000:  # More than 1 year
			print("[SaveManager] Warning: Save timestamp is more than 1 year old. Skipping offline progress.")
			time_away = 0
		
		# Only process offline progress if they were training and time passed
		if time_away > 60 and save_data.get("is_training", false):
			_calculate_offline_progress(
				save_data.get("current_skill_id", ""),
				save_data.get("current_method_id", ""),
				time_away
			)
	
	auto_save_enabled = true
	load_completed.emit()
	print("[SaveManager] Game loaded successfully from slot %d." % CharacterManager.current_slot)

## Calculate offline progress
func _calculate_offline_progress(skill_id: String, method_id: String, time_away: int) -> void:
	if skill_id.is_empty() or method_id.is_empty():
		return
	
	# Cap offline progress to prevent crashes from extreme time values
	# Maximum 24 hours of offline progress
	const MAX_OFFLINE_TIME := 86400  # 24 hours in seconds
	if time_away > MAX_OFFLINE_TIME:
		print("[SaveManager] Capping offline time from %d to %d seconds" % [time_away, MAX_OFFLINE_TIME])
		time_away = MAX_OFFLINE_TIME
	
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
	
	# Check if player has required level
	if GameManager.get_skill_level(skill_id) < method.level_required:
		return
	
	# Apply speed modifier from upgrades to increase effective offline time
	# This makes training faster by simulating more time passing (conceptually different from real-time)
	var speed_modifier := UpgradeShop.get_skill_speed_modifier(skill_id)
	var effective_time := time_away * (1.0 + speed_modifier)
	
	# Calculate how many actions could have been completed
	var max_actions := int(effective_time / method.action_time)
	
	# Cap to 10,000 actions to prevent crashes and excessive processing
	const MAX_ACTIONS := 10000
	if max_actions > MAX_ACTIONS:
		print("[SaveManager] Capping offline actions from %d to %d" % [max_actions, MAX_ACTIONS])
		max_actions = MAX_ACTIONS
	
	var actions_completed := 0
	var xp_gained: Dictionary = {}
	
	# For methods that consume items, limit by available items
	if not method.consumed_items.is_empty():
		var max_by_items := max_actions
		for item_id in method.consumed_items:
			var required: int = method.consumed_items[item_id]
			var available := Inventory.get_item_count(item_id)
			var possible := available / required if required > 0 else 0
			max_by_items = mini(max_by_items, possible)
		max_actions = max_by_items
	
	# Process actions
	for i in range(max_actions):
		# Consume items
		var can_proceed := true
		for item_id in method.consumed_items:
			var amount: int = method.consumed_items[item_id]
			if not Inventory.remove_item(item_id, amount):
				can_proceed = false
				break
		
		if not can_proceed:
			break
		
		actions_completed += 1
		
		# Add XP
		var xp := method.xp_per_action
		GameManager.add_xp(skill_id, xp)
		xp_gained[skill_id] = xp_gained.get(skill_id, 0.0) + xp
		
		# Produce items based on success rate (use deterministic calculation for offline)
		# Average items = success_rate * produced_items, so we multiply by rate for offline
		var success := (method.success_rate >= 1.0) or (float(i % 100) / 100.0 < method.success_rate)
		if success:
			for item_id in method.produced_items:
				var amount: int = method.produced_items[item_id]
				Inventory.add_item(item_id, amount)
	
	if actions_completed > 0:
		offline_progress_calculated.emit(float(time_away), actions_completed, xp_gained)
		print("[SaveManager] Offline progress: %d actions, %d seconds away" % [actions_completed, time_away])

## Delete save file
func delete_save() -> void:
	var save_file := CharacterManager.get_current_save_file()
	if save_file.is_empty():
		print("[SaveManager] No character selected.")
		return
	
	if FileAccess.file_exists(save_file):
		DirAccess.remove_absolute(save_file)
		print("[SaveManager] Save file deleted for slot %d." % CharacterManager.current_slot)

## Reset all game state to defaults
func _reset_game_state() -> void:
	# Reset GameManager (uses encapsulated method)
	GameManager.reset_all_skills()
	
	# Reset Inventory
	Inventory.inventory.clear()
	
	# Reset Store
	Store.gold = 0
	
	# Reset UpgradeShop
	UpgradeShop.purchased_upgrades.clear()
	
	print("[SaveManager] Game state reset to defaults.")
