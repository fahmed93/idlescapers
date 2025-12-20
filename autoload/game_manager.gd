## GameManager Autoload
## Handles skill levels, XP calculations, and training progression
extends Node

signal skill_xp_gained(skill_id: String, xp: float)
signal skill_level_up(skill_id: String, new_level: int)
signal training_started(skill_id: String, method_id: String)
signal training_stopped(skill_id: String)
signal action_completed(skill_id: String, method_id: String, success: bool)

## Constants for XP curve (RuneScape-style)
const MAX_LEVEL := 99
const XP_MULTIPLIER := 1.0

## Skill data registry
var skills: Dictionary = {}  # skill_id: SkillData

## Player skill progress
var skill_xp: Dictionary = {}  # skill_id: current_xp
var skill_levels: Dictionary = {}  # skill_id: current_level (cached)

## Current training state
var current_skill_id: String = ""
var current_method_id: String = ""
var training_progress: float = 0.0
var is_training: bool = false

## XP table (pre-calculated for levels 1-99)
var xp_table: Array[float] = []

func _ready() -> void:
	_build_xp_table()
	_load_skills()

## Build the XP table using RuneScape-style formula
func _build_xp_table() -> void:
	xp_table.clear()
	xp_table.append(0.0)  # Level 1 = 0 XP
	
	var total_xp := 0.0
	for level in range(2, MAX_LEVEL + 1):
		# RuneScape XP formula: sum of floor(level + 300 * 2^(level/7)) / 4
		var points: float = floor((level - 1) + 300.0 * pow(2.0, (level - 1) / 7.0))
		total_xp += floor(points / 4.0)
		xp_table.append(total_xp * XP_MULTIPLIER)

## Get XP required for a specific level
func get_xp_for_level(level: int) -> float:
	if level < 1:
		return 0.0
	if level > MAX_LEVEL:
		return xp_table[xp_table.size() - 1]
	return xp_table[level - 1]

## Get level from XP amount
func get_level_from_xp(xp: float) -> int:
	for level in range(MAX_LEVEL, 0, -1):
		if xp >= get_xp_for_level(level):
			return level
	return 1

## Get progress to next level (0.0 to 1.0)
func get_level_progress(skill_id: String) -> float:
	var xp: float = skill_xp.get(skill_id, 0.0)
	var level := get_skill_level(skill_id)
	
	if level >= MAX_LEVEL:
		return 1.0
	
	var current_level_xp := get_xp_for_level(level)
	var next_level_xp := get_xp_for_level(level + 1)
	var xp_in_level := xp - current_level_xp
	var xp_needed := next_level_xp - current_level_xp
	
	return xp_in_level / xp_needed if xp_needed > 0 else 0.0

## Load all skill definitions
func _load_skills() -> void:
	# Create Fishing skill
	var fishing := SkillData.new()
	fishing.id = "fishing"
	fishing.name = "Fishing"
	fishing.description = "Catch fish from waters around the world."
	fishing.color = Color(0.2, 0.6, 0.8)
	fishing.training_methods = preload("res://autoload/skills/fishing_skill.gd").create_methods()
	skills["fishing"] = fishing
	skill_xp["fishing"] = 0.0
	skill_levels["fishing"] = 1
	
	# Create Woodcutting skill
	var woodcutting := SkillData.new()
	woodcutting.id = "woodcutting"
	woodcutting.name = "Woodcutting"
	woodcutting.description = "Chop down trees for logs and other resources."
	woodcutting.color = Color(0.4, 0.25, 0.1)
	woodcutting.training_methods = preload("res://autoload/skills/woodcutting_skill.gd").create_methods()
	skills["woodcutting"] = woodcutting
	skill_xp["woodcutting"] = 0.0
	skill_levels["woodcutting"] = 1
	
	# Create Cooking skill
	var cooking := SkillData.new()
	cooking.id = "cooking"
	cooking.name = "Cooking"
	cooking.description = "Cook raw food to create edible meals."
	cooking.color = Color(0.8, 0.4, 0.2)
	cooking.training_methods = preload("res://autoload/skills/cooking_skill.gd").create_methods()
	skills["cooking"] = cooking
	skill_xp["cooking"] = 0.0
	skill_levels["cooking"] = 1
	
	# Create Fletching skill
	var fletching := SkillData.new()
	fletching.id = "fletching"
	fletching.name = "Fletching"
	fletching.description = "Create bows, arrows, and bolts."
	fletching.color = Color(0.5, 0.7, 0.3)
	fletching.training_methods = preload("res://autoload/skills/fletching_skill.gd").create_methods()
	skills["fletching"] = fletching
	skill_xp["fletching"] = 0.0
	skill_levels["fletching"] = 1
  
	# Create Mining skill
	var mining := SkillData.new()
	mining.id = "mining"
	mining.name = "Mining"
	mining.description = "Extract ores and gems from rocks."
	mining.color = Color(0.6, 0.5, 0.4)
	mining.training_methods = preload("res://autoload/skills/mining_skill.gd").create_methods()
	skills["mining"] = mining
	skill_xp["mining"] = 0.0
	skill_levels["mining"] = 1
  
	# Create Firemaking skill
	var firemaking := SkillData.new()
	firemaking.id = "firemaking"
	firemaking.name = "Firemaking"
	firemaking.description = "Burn logs for XP and unlock special fires."
	firemaking.color = Color(0.9, 0.4, 0.1)
	firemaking.training_methods = preload("res://autoload/skills/firemaking_skill.gd").create_methods()
	skills["firemaking"] = firemaking
	skill_xp["firemaking"] = 0.0
	skill_levels["firemaking"] = 1
	
	# Create Herblore skill
	var herblore := SkillData.new()
	herblore.id = "herblore"
	herblore.name = "Herblore"
	herblore.description = "Create potions from herbs and secondary ingredients."
	herblore.color = Color(0.2, 0.8, 0.3)
	herblore.training_methods = preload("res://autoload/skills/herblore_skill.gd").create_methods()
	skills["herblore"] = herblore
	skill_xp["herblore"] = 0.0
	skill_levels["herblore"] = 1
	
	# Create Smithing skill
	var smithing := SkillData.new()
	smithing.id = "smithing"
	smithing.name = "Smithing"
	smithing.description = "Smelt ores into bars and forge equipment."
	smithing.color = Color(0.7, 0.5, 0.3)
	smithing.training_methods = preload("res://autoload/skills/smithing_skill.gd").create_methods()
	skills["smithing"] = smithing
	skill_xp["smithing"] = 0.0
	skill_levels["smithing"] = 1
	
	# Create Thieving skill
	var thieving := SkillData.new()
	thieving.id = "thieving"
	thieving.name = "Thieving"
	thieving.description = "Pickpocket NPCs and unlock chests for coins and valuables."
	thieving.color = Color(0.6, 0.3, 0.7)
	thieving.training_methods = preload("res://autoload/skills/thieving_skill.gd").create_methods()
	skills["thieving"] = thieving
	skill_xp["thieving"] = 0.0
	skill_levels["thieving"] = 1
	
	# Create Agility skill
	var agility := SkillData.new()
	agility.id = "agility"
	agility.name = "Agility"
	agility.description = "Complete obstacle courses for XP and unlocks."
	agility.color = Color(0.0, 0.8, 1.0)
	agility.training_methods = preload("res://autoload/skills/agility_skill.gd").create_methods()
	skills["agility"] = agility
	skill_xp["agility"] = 0.0
	skill_levels["agility"] = 1
	
	# Create Astrology skill
	var astrology := SkillData.new()
	astrology.id = "astrology"
	astrology.name = "Astrology"
	astrology.description = "Study celestial bodies and constellations to unlock cosmic powers."
	astrology.color = Color(0.3, 0.2, 0.7)
	astrology.training_methods = preload("res://autoload/skills/astrology_skill.gd").create_methods()
	skills["astrology"] = astrology
	skill_xp["astrology"] = 0.0
	skill_levels["astrology"] = 1
	
	# Create Jewelcrafting skill
	var jewelcrafting := SkillData.new()
	jewelcrafting.id = "jewelcrafting"
	jewelcrafting.name = "Jewelcrafting"
	jewelcrafting.description = "Prospect ores for gems and craft jewelry."
	jewelcrafting.color = Color(0.7, 0.3, 0.8)
	jewelcrafting.training_methods = preload("res://autoload/skills/jewelcrafting_skill.gd").create_methods()
	skills["jewelcrafting"] = jewelcrafting
	skill_xp["jewelcrafting"] = 0.0
	skill_levels["jewelcrafting"] = 1
  
	# Create Skinning skill
	var skinning := SkillData.new()
	skinning.id = "skinning"
	skinning.name = "Skinning"
	skinning.description = "Skin animals to collect hides to use in crafting."
	skinning.color = Color(0.7, 0.5, 0.3)
	skinning.training_methods = preload("res://autoload/skills/skinning_skill.gd").create_methods()
	skills["skinning"] = skinning
	skill_xp["skinning"] = 0.0
	skill_levels["skinning"] = 1
  
	# Create Foraging skill
	var foraging := SkillData.new()
	foraging.id = "foraging"
	foraging.name = "Foraging"
	foraging.description = "Gather herbs and natural materials from the wilderness."
	foraging.color = Color(0.45, 0.6, 0.3)
	foraging.training_methods = preload("res://autoload/skills/foraging_skill.gd").create_methods()
	skills["foraging"] = foraging
	skill_xp["foraging"] = 0.0
	skill_levels["foraging"] = 1
	
	# Create Crafting skill
	var crafting := SkillData.new()
	crafting.id = "crafting"
	crafting.name = "Crafting"
	crafting.description = "Create leather armor and dragonhide equipment from hides."
	crafting.color = Color(0.6, 0.4, 0.3)
	crafting.training_methods = preload("res://autoload/skills/crafting_skill.gd").create_methods()
	skills["crafting"] = crafting
	skill_xp["crafting"] = 0.0
	skill_levels["crafting"] = 1

## Get current skill level
func get_skill_level(skill_id: String) -> int:
	return skill_levels.get(skill_id, 1)

## Get current skill XP
func get_skill_xp(skill_id: String) -> float:
	return skill_xp.get(skill_id, 0.0)

## Add XP to a skill
func add_xp(skill_id: String, xp: float) -> void:
	if not skills.has(skill_id):
		return
	
	var old_level := get_skill_level(skill_id)
	skill_xp[skill_id] = skill_xp.get(skill_id, 0.0) + xp
	var new_level := get_level_from_xp(skill_xp[skill_id])
	skill_levels[skill_id] = new_level
	
	skill_xp_gained.emit(skill_id, xp)
	
	if new_level > old_level:
		skill_level_up.emit(skill_id, new_level)

## Start training a skill with a specific method
func start_training(skill_id: String, method_id: String) -> bool:
	if not skills.has(skill_id):
		return false
	
	var skill: SkillData = skills[skill_id]
	var method: TrainingMethodData = null
	
	for m in skill.training_methods:
		if m.id == method_id:
			method = m
			break
	
	if method == null:
		return false
	
	# Check if player has required level
	if get_skill_level(skill_id) < method.level_required:
		return false
	
	current_skill_id = skill_id
	current_method_id = method_id
	training_progress = 0.0
	is_training = true
	
	training_started.emit(skill_id, method_id)
	return true

## Stop training
func stop_training() -> void:
	if is_training:
		var old_skill := current_skill_id
		current_skill_id = ""
		current_method_id = ""
		training_progress = 0.0
		is_training = false
		training_stopped.emit(old_skill)

## Get current training method
func get_current_training_method() -> TrainingMethodData:
	if not is_training or current_skill_id.is_empty():
		return null
	
	var skill: SkillData = skills.get(current_skill_id)
	if skill == null:
		return null
	
	for method in skill.training_methods:
		if method.id == current_method_id:
			return method
	
	return null

## Process training tick
func _process(delta: float) -> void:
	if not is_training:
		return
	
	var method := get_current_training_method()
	if method == null:
		stop_training()
		return
	
	# Check if we have required items for consumption
	if not method.consumed_items.is_empty():
		for item_id in method.consumed_items:
			var required: int = method.consumed_items[item_id]
			if Inventory.get_item_count(item_id) < required:
				stop_training()
				return
	
	# Progress accumulates at normal rate
	training_progress += delta
	
	# Use effective action time which accounts for speed modifiers from upgrades
	var effective_action_time := method.get_effective_action_time(current_skill_id)
	
	if training_progress >= effective_action_time:
		training_progress -= effective_action_time
		_complete_action(method)

## Complete a training action
func _complete_action(method: TrainingMethodData) -> void:
	# Apply skill cape effect: perfect cooking (100% success rate)
	var success := randf() <= method.success_rate
	if not success and UpgradeShop.has_cape_effect("perfect_cooking") and current_skill_id == "cooking":
		success = true  # Cooking cape makes all cooking attempts succeed
	
	# Apply skill cape effect: perfect iron smelting (100% success rate for iron)
	if not success and UpgradeShop.has_cape_effect("perfect_iron_smelting") and current_skill_id == "smithing":
		# Check if this is iron smelting (method ID contains "iron")
		if "iron" in method.id.to_lower():
			success = true
	
	# Consume items (with skill cape effects for saving materials)
	if not method.consumed_items.is_empty():
		for item_id in method.consumed_items:
			var amount: int = method.consumed_items[item_id]
			
			# Apply skill cape effects: chance to save materials
			var should_consume := true
			if UpgradeShop.has_cape_effect("save_fletching_materials") and current_skill_id == "fletching":
				if randf() <= 0.10:  # 10% chance to save
					should_consume = false
			elif UpgradeShop.has_cape_effect("save_herblore_ingredients") and current_skill_id == "herblore":
				if randf() <= 0.10:  # 10% chance to save
					should_consume = false
			elif UpgradeShop.has_cape_effect("save_gems") and current_skill_id == "jewelcrafting":
				if randf() <= 0.05:  # 5% chance to save
					should_consume = false
			elif UpgradeShop.has_cape_effect("save_crafting_hides") and current_skill_id == "crafting":
				if randf() <= 0.10:  # 10% chance to save
					should_consume = false
			
			if should_consume:
				if not Inventory.remove_item(item_id, amount):
					stop_training()
					return
	
	# Calculate XP with skill cape bonuses
	var xp_to_grant := method.xp_per_action
	
	# Apply skill cape effect: double firemaking XP
	if UpgradeShop.has_cape_effect("double_firemaking_xp") and current_skill_id == "firemaking":
		xp_to_grant *= 2.0
	
	# Apply skill cape effect: extra agility XP (5%)
	if UpgradeShop.has_cape_effect("extra_agility_xp") and current_skill_id == "agility":
		xp_to_grant *= 1.05
	
	# Apply skill cape effect: extra astrology XP (5%)
	if UpgradeShop.has_cape_effect("extra_astrology_xp") and current_skill_id == "astrology":
		xp_to_grant *= 1.05
	
	# Always give XP (with cape bonuses applied)
	add_xp(current_skill_id, xp_to_grant)
	
	# Produce items on success
	if success and not method.produced_items.is_empty():
		for item_id in method.produced_items:
			var amount: int = method.produced_items[item_id]
			Inventory.add_item(item_id, amount)
			
			# Apply skill cape effects: chance to get double items
			var double_chance := 0.0
			if UpgradeShop.has_cape_effect("double_fish") and current_skill_id == "fishing":
				double_chance = 0.05
			elif UpgradeShop.has_cape_effect("double_logs") and current_skill_id == "woodcutting":
				double_chance = 0.05
			elif UpgradeShop.has_cape_effect("double_hides") and current_skill_id == "skinning":
				double_chance = 0.05
			elif UpgradeShop.has_cape_effect("double_foraging") and current_skill_id == "foraging":
				double_chance = 0.05
			
			if double_chance > 0.0 and randf() <= double_chance:
				Inventory.add_item(item_id, amount)  # Add again for double
	
	# Check for bonus items on success (independent random roll for each)
	if success and not method.bonus_items.is_empty():
		for item_id in method.bonus_items:
			var chance: float = method.bonus_items[item_id]
			
			# Apply skill cape effect: double gem chance for mining
			if UpgradeShop.has_cape_effect("double_gem_chance") and current_skill_id == "mining":
				chance *= 2.0
			
			if randf() <= chance:
				Inventory.add_item(item_id, 1)
	
	# Apply skill cape effect: extra thieving gold (10%)
	if success and UpgradeShop.has_cape_effect("extra_thieving_gold") and current_skill_id == "thieving":
		# Check if this method produces gold by looking at produced_items
		if method.produced_items.has("gold") or method.produced_items.has("coins"):
			# Add 10% bonus gold
			var bonus_gold := int(ceil(method.produced_items.get("gold", 0) * 0.10))
			if bonus_gold > 0:
				Store.add_gold(bonus_gold)
	
	action_completed.emit(current_skill_id, method.id, success)

## Get total XP across all skills
func get_total_xp() -> float:
	var total := 0.0
	for skill_id in skill_xp:
		total += skill_xp[skill_id]
	return total

## Get total level across all skills
func get_total_level() -> int:
	var total := 0
	for skill_id in skill_levels:
		total += skill_levels[skill_id]
	return total

## Reset all skill progress to defaults
func reset_all_skills() -> void:
	for skill_id in skills:
		skill_xp[skill_id] = 0.0
		skill_levels[skill_id] = 1
	current_skill_id = ""
	current_method_id = ""
	training_progress = 0.0
	is_training = false
	print("[GameManager] All skills reset to defaults.")
