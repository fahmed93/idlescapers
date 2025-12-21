## Mining Skill
## Contains training methods for the Mining skill
extends Node

## Create and return all mining training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var copper := TrainingMethodData.new()
	copper.id = "copper_ore"
	copper.name = "Copper Ore"
	copper.description = "Mine copper from rocks."
	copper.level_required = 1
	copper.xp_per_action = 17.5
	copper.action_time = 2.5
	copper.produced_items = {"copper_ore": 1}
	copper.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(copper)
	
	var tin := TrainingMethodData.new()
	tin.id = "tin_ore"
	tin.name = "Tin Ore"
	tin.description = "Mine tin from rocks."
	tin.level_required = 1
	tin.xp_per_action = 17.5
	tin.action_time = 2.5
	tin.produced_items = {"tin_ore": 1}
	tin.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(tin)
	
	var iron := TrainingMethodData.new()
	iron.id = "iron_ore"
	iron.name = "Iron Ore"
	iron.description = "Mine iron from rocks."
	iron.level_required = 15
	iron.xp_per_action = 35.0
	iron.action_time = 3.0
	iron.produced_items = {"iron_ore": 1}
	iron.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(iron)
	
	var silver := TrainingMethodData.new()
	silver.id = "silver_ore"
	silver.name = "Silver Ore"
	silver.description = "Mine silver from rocks."
	silver.level_required = 20
	silver.xp_per_action = 40.0
	silver.action_time = 4.0
	silver.produced_items = {"silver_ore": 1}
	silver.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(silver)
	
	var coal_ore := TrainingMethodData.new()
	coal_ore.id = "coal"
	coal_ore.name = "Coal"
	coal_ore.description = "Mine coal for smelting."
	coal_ore.level_required = 30
	coal_ore.xp_per_action = 50.0
	coal_ore.action_time = 3.5
	coal_ore.produced_items = {"coal": 1}
	coal_ore.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(coal_ore)
	
	var gold := TrainingMethodData.new()
	gold.id = "gold_ore"
	gold.name = "Gold Ore"
	gold.description = "Mine gold from rocks."
	gold.level_required = 40
	gold.xp_per_action = 65.0
	gold.action_time = 4.0
	gold.produced_items = {"gold_ore": 1}
	gold.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(gold)
	
	var mithril := TrainingMethodData.new()
	mithril.id = "mithril_ore"
	mithril.name = "Mithril Ore"
	mithril.description = "Mine mithril from rocks."
	mithril.level_required = 55
	mithril.xp_per_action = 80.0
	mithril.action_time = 5.0
	mithril.produced_items = {"mithril_ore": 1}
	mithril.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(mithril)
	
	var adamantite := TrainingMethodData.new()
	adamantite.id = "adamantite_ore"
	adamantite.name = "Adamantite Ore"
	adamantite.description = "Mine adamantite from rocks."
	adamantite.level_required = 70
	adamantite.xp_per_action = 95.0
	adamantite.action_time = 6.0
	adamantite.produced_items = {"adamantite_ore": 1}
	adamantite.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(adamantite)
	
	var runite := TrainingMethodData.new()
	runite.id = "runite_ore"
	runite.name = "Runite Ore"
	runite.description = "Mine runite from rocks."
	runite.level_required = 85
	runite.xp_per_action = 125.0
	runite.action_time = 8.0
	runite.produced_items = {"runite_ore": 1}
	runite.bonus_items = {"sapphire": 0.01, "emerald": 0.005, "ruby": 0.002, "diamond": 0.001}
	methods.append(runite)
	
	return methods
