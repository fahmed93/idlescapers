## Smithing Skill
## Contains training methods for the Smithing skill
extends Node

## Create and return all smithing training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	# Level 1: Bronze Bar (copper + tin)
	var bronze_bar := TrainingMethodData.new()
	bronze_bar.id = "bronze_bar"
	bronze_bar.name = "Bronze Bar"
	bronze_bar.description = "Smelt copper and tin into a bronze bar."
	bronze_bar.level_required = 1
	bronze_bar.xp_per_action = 6.25
	bronze_bar.action_time = 2.0
	bronze_bar.consumed_items = {"copper_ore": 1, "tin_ore": 1}
	bronze_bar.produced_items = {"bronze_bar": 1}
	methods.append(bronze_bar)
	
	# Level 15: Iron Bar (50% success rate)
	var iron_bar := TrainingMethodData.new()
	iron_bar.id = "iron_bar"
	iron_bar.name = "Iron Bar"
	iron_bar.description = "Smelt iron ore into an iron bar."
	iron_bar.level_required = 15
	iron_bar.xp_per_action = 12.5
	iron_bar.action_time = 3.0
	iron_bar.consumed_items = {"iron_ore": 1}
	iron_bar.produced_items = {"iron_bar": 1}
	iron_bar.success_rate = 0.5
	methods.append(iron_bar)
	
	# Level 20: Silver Bar
	var silver_bar := TrainingMethodData.new()
	silver_bar.id = "silver_bar"
	silver_bar.name = "Silver Bar"
	silver_bar.description = "Smelt silver ore into a silver bar."
	silver_bar.level_required = 20
	silver_bar.xp_per_action = 13.75
	silver_bar.action_time = 3.0
	silver_bar.consumed_items = {"silver_ore": 1}
	silver_bar.produced_items = {"silver_bar": 1}
	methods.append(silver_bar)
	
	# Level 30: Steel Bar (iron + 2 coal)
	var steel_bar := TrainingMethodData.new()
	steel_bar.id = "steel_bar"
	steel_bar.name = "Steel Bar"
	steel_bar.description = "Smelt iron and coal into a steel bar."
	steel_bar.level_required = 30
	steel_bar.xp_per_action = 17.5
	steel_bar.action_time = 4.0
	steel_bar.consumed_items = {"iron_ore": 1, "coal": 2}
	steel_bar.produced_items = {"steel_bar": 1}
	methods.append(steel_bar)
	
	# Level 40: Gold Bar
	var gold_bar := TrainingMethodData.new()
	gold_bar.id = "gold_bar"
	gold_bar.name = "Gold Bar"
	gold_bar.description = "Smelt gold ore into a gold bar."
	gold_bar.level_required = 40
	gold_bar.xp_per_action = 22.5
	gold_bar.action_time = 3.0
	gold_bar.consumed_items = {"gold_ore": 1}
	gold_bar.produced_items = {"gold_bar": 1}
	methods.append(gold_bar)
	
	# Level 50: Mithril Bar (mithril + 4 coal)
	var mithril_bar := TrainingMethodData.new()
	mithril_bar.id = "mithril_bar"
	mithril_bar.name = "Mithril Bar"
	mithril_bar.description = "Smelt mithril ore and coal into a mithril bar."
	mithril_bar.level_required = 50
	mithril_bar.xp_per_action = 30.0
	mithril_bar.action_time = 5.0
	mithril_bar.consumed_items = {"mithril_ore": 1, "coal": 4}
	mithril_bar.produced_items = {"mithril_bar": 1}
	methods.append(mithril_bar)
	
	# Level 70: Adamantite Bar (adamantite + 6 coal)
	var adamantite_bar := TrainingMethodData.new()
	adamantite_bar.id = "adamantite_bar"
	adamantite_bar.name = "Adamantite Bar"
	adamantite_bar.description = "Smelt adamantite ore and coal into an adamantite bar."
	adamantite_bar.level_required = 70
	adamantite_bar.xp_per_action = 37.5
	adamantite_bar.action_time = 6.0
	adamantite_bar.consumed_items = {"adamantite_ore": 1, "coal": 6}
	adamantite_bar.produced_items = {"adamantite_bar": 1}
	methods.append(adamantite_bar)
	
	# Level 85: Runite Bar (runite + 8 coal)
	var runite_bar := TrainingMethodData.new()
	runite_bar.id = "runite_bar"
	runite_bar.name = "Runite Bar"
	runite_bar.description = "Smelt runite ore and coal into a runite bar."
	runite_bar.level_required = 85
	runite_bar.xp_per_action = 50.0
	runite_bar.action_time = 7.0
	runite_bar.consumed_items = {"runite_ore": 1, "coal": 8}
	runite_bar.produced_items = {"runite_bar": 1}
	methods.append(runite_bar)
	
	return methods
