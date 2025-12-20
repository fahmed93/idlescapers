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
	_add_upgrade("crystal_fishing_rod", "Crystal Fishing Rod", "fishing",
		"A magical rod that makes fishing 70% faster.", 80, 25000, 0.70)
	
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
	_add_upgrade("enchanted_oven", "Enchanted Oven", "cooking",
		"A magical oven that makes cooking 50% faster.", 70, 12000, 0.50)
	_add_upgrade("gourmet_toolkit", "Gourmet Toolkit", "cooking",
		"Professional tools that make cooking 65% faster.", 85, 20000, 0.65)
	
	# Fletching upgrades
	_add_upgrade("fletching_knife", "Fletching Knife", "fletching",
		"A sharp knife that makes fletching 10% faster.", 1, 100, 0.10)
	_add_upgrade("precision_tools", "Precision Tools", "fletching",
		"Professional tools that make fletching 25% faster.", 30, 2000, 0.25)
	_add_upgrade("master_fletcher_kit", "Master Fletcher Kit", "fletching",
		"A complete kit that makes fletching 40% faster.", 60, 8000, 0.40)
	_add_upgrade("elven_workbench", "Elven Workbench", "fletching",
		"A refined workbench that makes fletching 55% faster.", 75, 15000, 0.55)
	_add_upgrade("artisan_bowstring", "Artisan Bowstring Tool", "fletching",
		"A specialized tool that makes fletching 70% faster.", 90, 30000, 0.70)
	
	# Firemaking upgrades
	_add_upgrade("tinderbox", "Quality Tinderbox", "firemaking",
		"A reliable tinderbox that makes firemaking 10% faster.", 1, 100, 0.10)
	_add_upgrade("fire_starter", "Fire Starter", "firemaking",
		"An advanced tool that makes firemaking 20% faster.", 20, 1000, 0.20)
	_add_upgrade("pyromaniac_gloves", "Pyromaniac's Gloves", "firemaking",
		"Fire-resistant gloves that make firemaking 35% faster.", 40, 3000, 0.35)
	_add_upgrade("infernal_adze", "Infernal Adze", "firemaking",
		"A magical tool that makes firemaking 50% faster.", 75, 20000, 0.50)
	_add_upgrade("eternal_flame", "Eternal Flame", "firemaking",
		"A mystical flame that makes firemaking 80% faster.", 92, 40000, 0.80)
	
	# Smithing upgrades
	_add_upgrade("smithing_hammer", "Smithing Hammer", "smithing",
		"A sturdy hammer that makes smithing 10% faster.", 1, 100, 0.10)
	_add_upgrade("iron_anvil", "Iron Anvil", "smithing",
		"A better anvil that makes smithing 20% faster.", 20, 600, 0.20)
	_add_upgrade("steel_tongs", "Steel Tongs", "smithing",
		"Precision tongs that make smithing 30% faster.", 40, 2500, 0.30)
	_add_upgrade("master_forge", "Master Forge", "smithing",
		"A superior forge that makes smithing 45% faster.", 65, 10000, 0.45)
	_add_upgrade("dwarven_smithy", "Dwarven Smithy", "smithing",
		"A legendary workshop that makes smithing 65% faster.", 85, 25000, 0.65)
	
	# Herblore upgrades
	_add_upgrade("mortar_pestle", "Mortar & Pestle", "herblore",
		"Basic grinding tools that make herblore 10% faster.", 1, 100, 0.10)
	_add_upgrade("herb_pouch", "Herb Pouch", "herblore",
		"An enchanted pouch that makes herblore 20% faster.", 25, 800, 0.20)
	_add_upgrade("alchemist_vials", "Alchemist's Vials", "herblore",
		"Quality vials that make herblore 30% faster.", 45, 3000, 0.30)
	_add_upgrade("brewing_cauldron", "Brewing Cauldron", "herblore",
		"A magical cauldron that makes herblore 50% faster.", 70, 12000, 0.50)
	_add_upgrade("master_herbalist_kit", "Master Herbalist Kit", "herblore",
		"Complete set that makes herblore 70% faster.", 90, 30000, 0.70)
	
	# Thieving upgrades
	_add_upgrade("lockpicks", "Lockpicks", "thieving",
		"Basic tools that make thieving 10% faster.", 1, 100, 0.10)
	_add_upgrade("stealth_boots", "Stealth Boots", "thieving",
		"Quiet footwear that makes thieving 20% faster.", 20, 700, 0.20)
	_add_upgrade("thieves_gloves", "Thief's Gloves", "thieving",
		"Dexterous gloves that make thieving 35% faster.", 40, 2800, 0.35)
	_add_upgrade("shadow_cloak", "Shadow Cloak", "thieving",
		"A concealing cloak that makes thieving 50% faster.", 65, 11000, 0.50)
	_add_upgrade("master_thief_outfit", "Master Thief Outfit", "thieving",
		"Complete outfit that makes thieving 75% faster.", 88, 28000, 0.75)
	
	# Agility upgrades
	_add_upgrade("running_shoes", "Running Shoes", "agility",
		"Light footwear that makes agility 10% faster.", 1, 100, 0.10)
	_add_upgrade("training_weights", "Training Weights", "agility",
		"Resistance gear that makes agility 20% faster.", 22, 750, 0.20)
	_add_upgrade("agility_gloves", "Agility Gloves", "agility",
		"Grippy gloves that make agility 30% faster.", 42, 3200, 0.30)
	_add_upgrade("parkour_gear", "Parkour Gear", "agility",
		"Professional equipment that makes agility 45% faster.", 68, 13000, 0.45)
	_add_upgrade("graceful_outfit", "Graceful Outfit", "agility",
		"Lightweight outfit that makes agility 65% faster.", 90, 32000, 0.65)
	
	# Astrology upgrades
	_add_upgrade("basic_telescope", "Basic Telescope", "astrology",
		"A simple telescope that makes astrology 10% faster.", 1, 100, 0.10)
	_add_upgrade("star_chart", "Star Chart", "astrology",
		"Detailed charts that make astrology 20% faster.", 28, 900, 0.20)
	_add_upgrade("crystal_lens", "Crystal Lens", "astrology",
		"A clear lens that makes astrology 35% faster.", 48, 4000, 0.35)
	_add_upgrade("observatory", "Observatory", "astrology",
		"A dedicated space that makes astrology 55% faster.", 72, 16000, 0.55)
	_add_upgrade("celestial_globe", "Celestial Globe", "astrology",
		"A mystical globe that makes astrology 80% faster.", 95, 45000, 0.80)
	
	# Jewelcrafting upgrades
	_add_upgrade("jewelers_loupe", "Jeweler's Loupe", "jewelcrafting",
		"A magnifying tool that makes jewelcrafting 10% faster.", 1, 100, 0.10)
	_add_upgrade("gem_chisel", "Gem Chisel", "jewelcrafting",
		"A precise chisel that makes jewelcrafting 20% faster.", 24, 850, 0.20)
	_add_upgrade("polishing_wheel", "Polishing Wheel", "jewelcrafting",
		"A fine wheel that makes jewelcrafting 35% faster.", 46, 3500, 0.35)
	_add_upgrade("master_jeweler_bench", "Master Jeweler Bench", "jewelcrafting",
		"A professional bench that makes jewelcrafting 50% faster.", 69, 14000, 0.50)
	_add_upgrade("enchanted_tools", "Enchanted Tools", "jewelcrafting",
		"Magical tools that make jewelcrafting 70% faster.", 91, 35000, 0.70)
	
	# Skinning upgrades
	_add_upgrade("skinning_knife", "Skinning Knife", "skinning",
		"A sharp blade that makes skinning 10% faster.", 1, 100, 0.10)
	_add_upgrade("hunters_gloves", "Hunter's Gloves", "skinning",
		"Protective gloves that make skinning 20% faster.", 21, 680, 0.20)
	_add_upgrade("tanning_rack", "Tanning Rack", "skinning",
		"A proper rack that makes skinning 30% faster.", 41, 2900, 0.30)
	_add_upgrade("master_skinner_kit", "Master Skinner Kit", "skinning",
		"Professional tools that make skinning 45% faster.", 66, 11500, 0.45)
	_add_upgrade("legendary_flayer", "Legendary Flayer", "skinning",
		"A mythical blade that makes skinning 65% faster.", 87, 29000, 0.65)
	
	# Foraging upgrades
	_add_upgrade("wicker_basket", "Wicker Basket", "foraging",
		"A sturdy basket that makes foraging 10% faster.", 1, 100, 0.10)
	_add_upgrade("foraging_satchel", "Foraging Satchel", "foraging",
		"An organized satchel that makes foraging 20% faster.", 23, 780, 0.20)
	_add_upgrade("herbalists_guide", "Herbalist's Guide", "foraging",
		"A detailed guide that makes foraging 35% faster.", 44, 3300, 0.35)
	_add_upgrade("nature_sense", "Nature Sense Amulet", "foraging",
		"A mystical amulet that makes foraging 50% faster.", 67, 13500, 0.50)
	_add_upgrade("druid_staff", "Druid's Staff", "foraging",
		"A powerful staff that makes foraging 70% faster.", 89, 31000, 0.70)
	
	# Crafting upgrades
	_add_upgrade("crafting_needle", "Crafting Needle", "crafting",
		"A fine needle that makes crafting 10% faster.", 1, 100, 0.10)
	_add_upgrade("artisan_scissors", "Artisan Scissors", "crafting",
		"Sharp scissors that make crafting 20% faster.", 26, 880, 0.20)
	_add_upgrade("weaving_loom", "Weaving Loom", "crafting",
		"A quality loom that makes crafting 35% faster.", 47, 3800, 0.35)
	_add_upgrade("master_workbench", "Master Workbench", "crafting",
		"A versatile bench that makes crafting 55% faster.", 71, 15500, 0.55)
	_add_upgrade("artificers_toolkit", "Artificer's Toolkit", "crafting",
		"Magical tools that make crafting 75% faster.", 93, 38000, 0.75)
	
	# === SKILL CAPES (Level 99) ===
	_add_skill_cape("fishing_cape", "Fishing Skillcape", "fishing",
		"Mastery of fishing grants 5% chance to catch double fish.", 99, 99000, "double_fish")
	_add_skill_cape("cooking_cape", "Cooking Skillcape", "cooking",
		"Mastery of cooking grants 100% success rate - never burn food again!", 99, 99000, "perfect_cooking")
	_add_skill_cape("woodcutting_cape", "Woodcutting Skillcape", "woodcutting",
		"Mastery of woodcutting grants 5% chance to get double logs.", 99, 99000, "double_logs")
	_add_skill_cape("fletching_cape", "Fletching Skillcape", "fletching",
		"Mastery of fletching grants 10% chance to save materials.", 99, 99000, "save_fletching_materials")
	_add_skill_cape("mining_cape", "Mining Skillcape", "mining",
		"Mastery of mining grants double chance for bonus gem drops.", 99, 99000, "double_gem_chance")
	_add_skill_cape("firemaking_cape", "Firemaking Skillcape", "firemaking",
		"Mastery of firemaking grants double XP from all fires.", 99, 99000, "double_firemaking_xp")
	_add_skill_cape("smithing_cape", "Smithing Skillcape", "smithing",
		"Mastery of smithing grants 100% success rate for iron smelting.", 99, 99000, "perfect_iron_smelting")
	_add_skill_cape("herblore_cape", "Herblore Skillcape", "herblore",
		"Mastery of herblore grants 10% chance to save ingredients.", 99, 99000, "save_herblore_ingredients")
	_add_skill_cape("thieving_cape", "Thieving Skillcape", "thieving",
		"Mastery of thieving grants 10% extra gold from pickpocketing.", 99, 99000, "extra_thieving_gold")
	_add_skill_cape("agility_cape", "Agility Skillcape", "agility",
		"Mastery of agility grants 5% extra XP from courses.", 99, 99000, "extra_agility_xp")
	_add_skill_cape("astrology_cape", "Astrology Skillcape", "astrology",
		"Mastery of astrology grants 5% extra XP from celestial studies.", 99, 99000, "extra_astrology_xp")
	_add_skill_cape("jewelcrafting_cape", "Jewelcrafting Skillcape", "jewelcrafting",
		"Mastery of jewelcrafting grants 5% chance to save gems.", 99, 99000, "save_gems")
	_add_skill_cape("skinning_cape", "Skinning Skillcape", "skinning",
		"Mastery of skinning grants 5% chance to get double hides.", 99, 99000, "double_hides")
	_add_skill_cape("foraging_cape", "Foraging Skillcape", "foraging",
		"Mastery of foraging grants 5% chance to get double materials.", 99, 99000, "double_foraging")
	_add_skill_cape("crafting_cape", "Crafting Skillcape", "crafting",
		"Mastery of crafting grants 10% chance to save hides.", 99, 99000, "save_crafting_hides")

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
	upgrade.is_skill_cape = false
	upgrades[id] = upgrade

## Helper to add skill cape definition
func _add_skill_cape(id: String, display_name: String, skill_id: String,
	desc: String, level_req: int, cost: int, effect_id: String) -> void:
	var upgrade := UpgradeData.new()
	upgrade.id = id
	upgrade.name = display_name
	upgrade.skill_id = skill_id
	upgrade.description = desc
	upgrade.level_required = level_req
	upgrade.cost = cost
	upgrade.speed_modifier = 0.0  # Skill capes don't provide speed bonuses
	upgrade.is_skill_cape = true
	upgrade.cape_effect_id = effect_id
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
	
	# Deduct gold (this also validates if player has enough)
	if not Store.remove_gold(upgrade.cost):
		push_warning("[UpgradeShop] Insufficient gold for %s" % upgrade_id)
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

## Check if a skill cape is owned for a specific skill
func has_skill_cape(skill_id: String) -> bool:
	for upgrade_id in purchased_upgrades:
		if upgrades.has(upgrade_id):
			var upgrade: UpgradeData = upgrades[upgrade_id]
			if upgrade.is_skill_cape and upgrade.skill_id == skill_id:
				return true
	return false

## Get cape effect ID for a skill if the cape is owned
func get_cape_effect(skill_id: String) -> String:
	for upgrade_id in purchased_upgrades:
		if upgrades.has(upgrade_id):
			var upgrade: UpgradeData = upgrades[upgrade_id]
			if upgrade.is_skill_cape and upgrade.skill_id == skill_id:
				return upgrade.cape_effect_id
	return ""

## Check if a specific cape effect is active
func has_cape_effect(effect_id: String) -> bool:
	for upgrade_id in purchased_upgrades:
		if upgrades.has(upgrade_id):
			var upgrade: UpgradeData = upgrades[upgrade_id]
			if upgrade.is_skill_cape and upgrade.cape_effect_id == effect_id:
				return true
	return false
