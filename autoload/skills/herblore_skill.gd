## Herblore Skill
## Contains training methods for the Herblore skill
extends Node

## Create and return all herblore training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	# Level 1: Attack Potion
	var attack_potion := TrainingMethodData.new()
	attack_potion.id = "attack_potion"
	attack_potion.name = "Attack Potion"
	attack_potion.description = "Brew a potion that boosts Attack."
	attack_potion.level_required = 1
	attack_potion.xp_per_action = 25.0
	attack_potion.action_time = 2.0
	attack_potion.consumed_items = {"guam_leaf": 1, "eye_of_newt": 1}
	attack_potion.produced_items = {"attack_potion": 1}
	methods.append(attack_potion)
	
	# Level 5: Antipoison
	var antipoison := TrainingMethodData.new()
	antipoison.id = "antipoison"
	antipoison.name = "Antipoison"
	antipoison.description = "Brew a potion that cures poison."
	antipoison.level_required = 5
	antipoison.xp_per_action = 37.5
	antipoison.action_time = 2.0
	antipoison.consumed_items = {"marrentill": 1, "unicorn_horn_dust": 1}
	antipoison.produced_items = {"antipoison": 1}
	methods.append(antipoison)
	
	# Level 12: Strength Potion
	var strength_potion := TrainingMethodData.new()
	strength_potion.id = "strength_potion"
	strength_potion.name = "Strength Potion"
	strength_potion.description = "Brew a potion that boosts Strength."
	strength_potion.level_required = 12
	strength_potion.xp_per_action = 50.0
	strength_potion.action_time = 2.5
	strength_potion.consumed_items = {"tarromin": 1, "limpwurt_root": 1}
	strength_potion.produced_items = {"strength_potion": 1}
	methods.append(strength_potion)
	
	# Level 22: Restore Potion
	var restore_potion := TrainingMethodData.new()
	restore_potion.id = "restore_potion"
	restore_potion.name = "Restore Potion"
	restore_potion.description = "Brew a potion that restores stats."
	restore_potion.level_required = 22
	restore_potion.xp_per_action = 62.5
	restore_potion.action_time = 2.5
	restore_potion.consumed_items = {"harralander": 1, "red_spiders_eggs": 1}
	restore_potion.produced_items = {"restore_potion": 1}
	methods.append(restore_potion)
	
	# Level 26: Energy Potion
	var energy_potion := TrainingMethodData.new()
	energy_potion.id = "energy_potion"
	energy_potion.name = "Energy Potion"
	energy_potion.description = "Brew a potion that restores energy."
	energy_potion.level_required = 26
	energy_potion.xp_per_action = 67.5
	energy_potion.action_time = 2.5
	energy_potion.consumed_items = {"harralander": 1, "chocolate_dust": 1}
	energy_potion.produced_items = {"energy_potion": 1}
	methods.append(energy_potion)
	
	# Level 30: Defence Potion
	var defence_potion := TrainingMethodData.new()
	defence_potion.id = "defence_potion"
	defence_potion.name = "Defence Potion"
	defence_potion.description = "Brew a potion that boosts Defence."
	defence_potion.level_required = 30
	defence_potion.xp_per_action = 75.0
	defence_potion.action_time = 2.5
	defence_potion.consumed_items = {"ranarr_weed": 1, "white_berries": 1}
	defence_potion.produced_items = {"defence_potion": 1}
	methods.append(defence_potion)
	
	# Level 38: Prayer Potion
	var prayer_potion := TrainingMethodData.new()
	prayer_potion.id = "prayer_potion"
	prayer_potion.name = "Prayer Potion"
	prayer_potion.description = "Brew a potion that restores Prayer points."
	prayer_potion.level_required = 38
	prayer_potion.xp_per_action = 87.5
	prayer_potion.action_time = 3.0
	prayer_potion.consumed_items = {"ranarr_weed": 1, "snape_grass": 1}
	prayer_potion.produced_items = {"prayer_potion": 1}
	methods.append(prayer_potion)
	
	# Level 45: Super Attack
	var super_attack := TrainingMethodData.new()
	super_attack.id = "super_attack"
	super_attack.name = "Super Attack"
	super_attack.description = "Brew a powerful Attack-boosting potion."
	super_attack.level_required = 45
	super_attack.xp_per_action = 100.0
	super_attack.action_time = 3.0
	super_attack.consumed_items = {"irit_leaf": 1, "eye_of_newt": 1}
	super_attack.produced_items = {"super_attack": 1}
	methods.append(super_attack)
	
	# Level 48: Super Strength
	var super_strength := TrainingMethodData.new()
	super_strength.id = "super_strength"
	super_strength.name = "Super Strength"
	super_strength.description = "Brew a powerful Strength-boosting potion."
	super_strength.level_required = 48
	super_strength.xp_per_action = 125.0
	super_strength.action_time = 3.0
	super_strength.consumed_items = {"kwuarm": 1, "limpwurt_root": 1}
	super_strength.produced_items = {"super_strength": 1}
	methods.append(super_strength)
	
	# Level 55: Super Restore
	var super_restore := TrainingMethodData.new()
	super_restore.id = "super_restore"
	super_restore.name = "Super Restore"
	super_restore.description = "Brew a potion that fully restores stats."
	super_restore.level_required = 55
	super_restore.xp_per_action = 142.5
	super_restore.action_time = 3.0
	super_restore.consumed_items = {"snapdragon": 1, "red_spiders_eggs": 1}
	super_restore.produced_items = {"super_restore": 1}
	methods.append(super_restore)
	
	# Level 66: Super Defence
	var super_defence := TrainingMethodData.new()
	super_defence.id = "super_defence"
	super_defence.name = "Super Defence"
	super_defence.description = "Brew a powerful Defence-boosting potion."
	super_defence.level_required = 66
	super_defence.xp_per_action = 150.0
	super_defence.action_time = 3.0
	super_defence.consumed_items = {"cadantine": 1, "white_berries": 1}
	super_defence.produced_items = {"super_defence": 1}
	methods.append(super_defence)
	
	# Level 66: Saradomin Brew
	var saradomin_brew := TrainingMethodData.new()
	saradomin_brew.id = "saradomin_brew"
	saradomin_brew.name = "Saradomin Brew"
	saradomin_brew.description = "Brew a holy potion blessed by Saradomin."
	saradomin_brew.level_required = 66
	saradomin_brew.xp_per_action = 180.0
	saradomin_brew.action_time = 3.5
	saradomin_brew.consumed_items = {"toadflax": 1, "crushed_nest": 1}
	saradomin_brew.produced_items = {"saradomin_brew": 1}
	methods.append(saradomin_brew)
	
	# Level 72: Ranging Potion
	var ranging_potion := TrainingMethodData.new()
	ranging_potion.id = "ranging_potion"
	ranging_potion.name = "Ranging Potion"
	ranging_potion.description = "Brew a potion that boosts Ranged."
	ranging_potion.level_required = 72
	ranging_potion.xp_per_action = 162.5
	ranging_potion.action_time = 3.0
	ranging_potion.consumed_items = {"dwarf_weed": 1, "wine_of_zamorak": 1}
	ranging_potion.produced_items = {"ranging_potion": 1}
	methods.append(ranging_potion)
	
	# Level 78: Antifire
	var antifire := TrainingMethodData.new()
	antifire.id = "antifire"
	antifire.name = "Antifire Potion"
	antifire.description = "Brew a potion that protects from dragonfire."
	antifire.level_required = 78
	antifire.xp_per_action = 157.5
	antifire.action_time = 3.0
	antifire.consumed_items = {"lantadyme": 1, "dragon_scale_dust": 1}
	antifire.produced_items = {"antifire": 1}
	methods.append(antifire)
	
	# Level 81: Magic Potion
	var magic_potion := TrainingMethodData.new()
	magic_potion.id = "magic_potion"
	magic_potion.name = "Magic Potion"
	magic_potion.description = "Brew a potion that boosts Magic."
	magic_potion.level_required = 81
	magic_potion.xp_per_action = 172.5
	magic_potion.action_time = 3.0
	magic_potion.consumed_items = {"lantadyme": 1, "potato_cactus": 1}
	magic_potion.produced_items = {"magic_potion": 1}
	methods.append(magic_potion)
	
	# Level 85: Zamorak Brew
	var zamorak_brew := TrainingMethodData.new()
	zamorak_brew.id = "zamorak_brew"
	zamorak_brew.name = "Zamorak Brew"
	zamorak_brew.description = "Brew a dark potion blessed by Zamorak."
	zamorak_brew.level_required = 85
	zamorak_brew.xp_per_action = 175.0
	zamorak_brew.action_time = 3.5
	zamorak_brew.consumed_items = {"torstol": 1, "jangerberries": 1}
	zamorak_brew.produced_items = {"zamorak_brew": 1}
	methods.append(zamorak_brew)
	
	# Level 90: Overload
	var overload := TrainingMethodData.new()
	overload.id = "overload"
	overload.name = "Overload"
	overload.description = "Brew the ultimate combat potion."
	overload.level_required = 90
	overload.xp_per_action = 1000.0
	overload.action_time = 5.0
	overload.consumed_items = {
		"torstol": 1, 
		"super_attack": 1, 
		"super_strength": 1, 
		"super_defence": 1,
		"ranging_potion": 1,
		"magic_potion": 1
	}
	overload.produced_items = {"overload": 1}
	methods.append(overload)
	
	return methods
