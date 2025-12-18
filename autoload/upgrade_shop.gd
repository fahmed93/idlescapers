## UpgradeShop Autoload
## Manages upgrades that players can purchase to improve skill training
extends Node

signal upgrade_purchased(upgrade_id: String)
signal upgrades_updated()

## Available upgrades registry
var upgrades: Dictionary = {}  # upgrade_id: UpgradeData

## Purchased upgrades
var purchased_upgrades: Array[String] = []

func _ready() -> void:
	_load_upgrades()

## Load all upgrade definitions
func _load_upgrades() -> void:
	# Fishing upgrades
	_add_upgrade("basic_fishing_rod", "Basic Fishing Rod", "fishing", 
		"A simple rod that makes fishing 10% faster.", 1, 100, 0.10)
	_add_upgrade("steel_fishing_rod", "Steel Fishing Rod", "fishing",
		"An improved rod that makes fishing 20% faster.", 20, 500, 0.20)
	_add_upgrade("mithril_fishing_rod", "Mithril Fishing Rod", "fishing",
		"A lightweight rod that makes fishing 30% faster.", 40, 2000, 0.30)
	_add_upgrade("dragon_fishing_rod", "Dragon Fishing Rod", "fishing",
		"A powerful rod that makes fishing 50% faster.", 60, 10000, 0.50)
	
	# Woodcutting upgrades
	_add_upgrade("bronze_axe", "Bronze Axe", "woodcutting",
		"A basic axe that makes woodcutting 10% faster.", 1, 100, 0.10)
	_add_upgrade("iron_axe", "Iron Axe", "woodcutting",
		"An iron axe that makes woodcutting 20% faster.", 15, 500, 0.20)
	_add_upgrade("steel_axe", "Steel Axe", "woodcutting",
		"A sturdy axe that makes woodcutting 30% faster.", 30, 2000, 0.30)
	_add_upgrade("mithril_axe", "Mithril Axe", "woodcutting",
		"A lightweight axe that makes woodcutting 40% faster.", 45, 5000, 0.40)
	_add_upgrade("dragon_axe", "Dragon Axe", "woodcutting",
		"A powerful axe that makes woodcutting 60% faster.", 61, 15000, 0.60)
	
	# Mining upgrades
	_add_upgrade("bronze_pickaxe", "Bronze Pickaxe", "mining",
		"A basic pickaxe that makes mining 10% faster.", 1, 100, 0.10)
	_add_upgrade("iron_pickaxe", "Iron Pickaxe", "mining",
		"An iron pickaxe that makes mining 20% faster.", 15, 500, 0.20)
	_add_upgrade("steel_pickaxe", "Steel Pickaxe", "mining",
		"A sturdy pickaxe that makes mining 30% faster.", 30, 2000, 0.30)
	_add_upgrade("mithril_pickaxe", "Mithril Pickaxe", "mining",
		"A lightweight pickaxe that makes mining 40% faster.", 45, 5000, 0.40)
	_add_upgrade("dragon_pickaxe", "Dragon Pickaxe", "mining",
		"A powerful pickaxe that makes mining 60% faster.", 61, 15000, 0.60)
	
	# Cooking upgrades
	_add_upgrade("cooking_gloves", "Cooking Gloves", "cooking",
		"Heat-resistant gloves that make cooking 10% faster.", 1, 100, 0.10)
	_add_upgrade("chef_hat", "Chef's Hat", "cooking",
		"A professional hat that makes cooking 15% faster.", 25, 800, 0.15)
	_add_upgrade("master_chef_outfit", "Master Chef Outfit", "cooking",
		"A complete outfit that makes cooking 35% faster.", 50, 5000, 0.35)
	
	# Fletching upgrades
	_add_upgrade("fletching_knife", "Fletching Knife", "fletching",
		"A sharp knife that makes fletching 10% faster.", 1, 100, 0.10)
	_add_upgrade("precision_tools", "Precision Tools", "fletching",
		"Professional tools that make fletching 25% faster.", 30, 2000, 0.25)
	_add_upgrade("master_fletcher_kit", "Master Fletcher Kit", "fletching",
		"A complete kit that makes fletching 40% faster.", 60, 8000, 0.40)
	
	# Firemaking upgrades
	_add_upgrade("tinderbox", "Quality Tinderbox", "firemaking",
		"A reliable tinderbox that makes firemaking 10% faster.", 1, 100, 0.10)
	_add_upgrade("fire_starter", "Fire Starter", "firemaking",
		"An advanced tool that makes firemaking 20% faster.", 20, 1000, 0.20)
	_add_upgrade("infernal_adze", "Infernal Adze", "firemaking",
		"A magical tool that makes firemaking 50% faster.", 75, 20000, 0.50)

## Helper to add upgrade definition
func _add_upgrade(id: String, display_name: String, skill_id: String, 
	desc: String, level_req: int, cost: int, speed_mod: float) -> void:
	var upgrade := UpgradeData.new()
	upgrade.id = id
	upgrade.name = display_name
	upgrade.skill_id = skill_id
	upgrade.description = desc
	upgrade.level_required = level_req
	upgrade.cost = cost
	upgrade.speed_modifier = speed_mod
	upgrades[id] = upgrade

## Get all upgrades for a specific skill
func get_upgrades_for_skill(skill_id: String) -> Array[UpgradeData]:
	var skill_upgrades: Array[UpgradeData] = []
	for upgrade_id in upgrades:
		var upgrade: UpgradeData = upgrades[upgrade_id]
		if upgrade.skill_id == skill_id:
			skill_upgrades.append(upgrade)
	return skill_upgrades

## Check if an upgrade is purchased
func is_purchased(upgrade_id: String) -> bool:
	return upgrade_id in purchased_upgrades

## Purchase an upgrade
func purchase_upgrade(upgrade_id: String) -> bool:
	if not upgrades.has(upgrade_id):
		push_warning("[UpgradeShop] Unknown upgrade: %s" % upgrade_id)
		return false
	
	if is_purchased(upgrade_id):
		push_warning("[UpgradeShop] Upgrade already purchased: %s" % upgrade_id)
		return false
	
	var upgrade: UpgradeData = upgrades[upgrade_id]
	
	# Check if player has required level
	var player_level := GameManager.get_skill_level(upgrade.skill_id)
	if player_level < upgrade.level_required:
		push_warning("[UpgradeShop] Insufficient level for %s: %d < %d" % 
			[upgrade_id, player_level, upgrade.level_required])
		return false
	
	# Check if player has enough gold
	if not Store.has_gold(upgrade.cost):
		push_warning("[UpgradeShop] Insufficient gold for %s: %d < %d" % 
			[upgrade_id, Store.get_gold(), upgrade.cost])
		return false
	
	# Deduct gold
	if not Store.remove_gold(upgrade.cost):
		return false
	
	# Add to purchased upgrades
	purchased_upgrades.append(upgrade_id)
	upgrade_purchased.emit(upgrade_id)
	upgrades_updated.emit()
	
	print("[UpgradeShop] Purchased upgrade: %s" % upgrade.name)
	return true

## Get total speed modifier for a skill from all purchased upgrades
func get_skill_speed_modifier(skill_id: String) -> float:
	var total_modifier := 0.0
	for upgrade_id in purchased_upgrades:
		if upgrades.has(upgrade_id):
			var upgrade: UpgradeData = upgrades[upgrade_id]
			if upgrade.skill_id == skill_id:
				total_modifier += upgrade.speed_modifier
	return total_modifier

## Get all purchased upgrades
func get_purchased_upgrades() -> Array[String]:
	return purchased_upgrades.duplicate()

## Clear all purchased upgrades (for testing/reset)
func clear_purchased() -> void:
	purchased_upgrades.clear()
	upgrades_updated.emit()
