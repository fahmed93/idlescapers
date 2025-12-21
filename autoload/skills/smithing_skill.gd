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
	
	# ===== SMITHING ITEMS (Crafting from bars) =====
	
	# BRONZE ITEMS (Level 1+)
	# Level 1: Bronze Arrowheads (15 per bar)
	var bronze_arrowheads := TrainingMethodData.new()
	bronze_arrowheads.id = "bronze_arrowheads"
	bronze_arrowheads.name = "Bronze Arrowheads"
	bronze_arrowheads.description = "Smith bronze arrowheads from a bronze bar."
	bronze_arrowheads.level_required = 1
	bronze_arrowheads.xp_per_action = 12.5
	bronze_arrowheads.action_time = 2.0
	bronze_arrowheads.consumed_items = {"bronze_bar": 1}
	bronze_arrowheads.produced_items = {"bronze_arrowhead": 15}
	methods.append(bronze_arrowheads)
	
	# Level 1: Bronze Dagger
	var bronze_dagger := TrainingMethodData.new()
	bronze_dagger.id = "bronze_dagger"
	bronze_dagger.name = "Bronze Dagger"
	bronze_dagger.description = "Smith a bronze dagger."
	bronze_dagger.level_required = 1
	bronze_dagger.xp_per_action = 12.5
	bronze_dagger.action_time = 2.5
	bronze_dagger.consumed_items = {"bronze_bar": 1}
	bronze_dagger.produced_items = {"bronze_dagger": 1}
	methods.append(bronze_dagger)
	
	# Level 3: Bronze Full Helm
	var bronze_full_helm := TrainingMethodData.new()
	bronze_full_helm.id = "bronze_full_helm"
	bronze_full_helm.name = "Bronze Full Helm"
	bronze_full_helm.description = "Smith a bronze full helmet."
	bronze_full_helm.level_required = 3
	bronze_full_helm.xp_per_action = 25.0
	bronze_full_helm.action_time = 3.0
	bronze_full_helm.consumed_items = {"bronze_bar": 2}
	bronze_full_helm.produced_items = {"bronze_full_helm": 1}
	methods.append(bronze_full_helm)
	
	# Level 4: Bronze Sword
	var bronze_sword := TrainingMethodData.new()
	bronze_sword.id = "bronze_sword"
	bronze_sword.name = "Bronze Sword"
	bronze_sword.description = "Smith a bronze sword."
	bronze_sword.level_required = 4
	bronze_sword.xp_per_action = 12.5
	bronze_sword.action_time = 2.5
	bronze_sword.consumed_items = {"bronze_bar": 1}
	bronze_sword.produced_items = {"bronze_sword": 1}
	methods.append(bronze_sword)
	
	# Level 5: Bronze Scimitar
	var bronze_scimitar := TrainingMethodData.new()
	bronze_scimitar.id = "bronze_scimitar"
	bronze_scimitar.name = "Bronze Scimitar"
	bronze_scimitar.description = "Smith a bronze scimitar."
	bronze_scimitar.level_required = 5
	bronze_scimitar.xp_per_action = 25.0
	bronze_scimitar.action_time = 3.0
	bronze_scimitar.consumed_items = {"bronze_bar": 2}
	bronze_scimitar.produced_items = {"bronze_scimitar": 1}
	methods.append(bronze_scimitar)
	
	# Level 16: Bronze Platelegs
	var bronze_platelegs := TrainingMethodData.new()
	bronze_platelegs.id = "bronze_platelegs"
	bronze_platelegs.name = "Bronze Platelegs"
	bronze_platelegs.description = "Smith bronze platelegs."
	bronze_platelegs.level_required = 16
	bronze_platelegs.xp_per_action = 37.5
	bronze_platelegs.action_time = 4.0
	bronze_platelegs.consumed_items = {"bronze_bar": 3}
	bronze_platelegs.produced_items = {"bronze_platelegs": 1}
	methods.append(bronze_platelegs)
	
	# Level 18: Bronze Platebody
	var bronze_platebody := TrainingMethodData.new()
	bronze_platebody.id = "bronze_platebody"
	bronze_platebody.name = "Bronze Platebody"
	bronze_platebody.description = "Smith a bronze platebody."
	bronze_platebody.level_required = 18
	bronze_platebody.xp_per_action = 62.5
	bronze_platebody.action_time = 5.0
	bronze_platebody.consumed_items = {"bronze_bar": 5}
	bronze_platebody.produced_items = {"bronze_platebody": 1}
	methods.append(bronze_platebody)
	
	# IRON ITEMS (Level 15+)
	# Level 15: Iron Arrowheads (15 per bar)
	var iron_arrowheads := TrainingMethodData.new()
	iron_arrowheads.id = "iron_arrowheads"
	iron_arrowheads.name = "Iron Arrowheads"
	iron_arrowheads.description = "Smith iron arrowheads from an iron bar."
	iron_arrowheads.level_required = 15
	iron_arrowheads.xp_per_action = 25.0
	iron_arrowheads.action_time = 2.0
	iron_arrowheads.consumed_items = {"iron_bar": 1}
	iron_arrowheads.produced_items = {"iron_arrowhead": 15}
	methods.append(iron_arrowheads)
	
	# Level 15: Iron Dagger
	var iron_dagger := TrainingMethodData.new()
	iron_dagger.id = "iron_dagger"
	iron_dagger.name = "Iron Dagger"
	iron_dagger.description = "Smith an iron dagger."
	iron_dagger.level_required = 15
	iron_dagger.xp_per_action = 25.0
	iron_dagger.action_time = 2.5
	iron_dagger.consumed_items = {"iron_bar": 1}
	iron_dagger.produced_items = {"iron_dagger": 1}
	methods.append(iron_dagger)
	
	# Level 17: Iron Full Helm
	var iron_full_helm := TrainingMethodData.new()
	iron_full_helm.id = "iron_full_helm"
	iron_full_helm.name = "Iron Full Helm"
	iron_full_helm.description = "Smith an iron full helmet."
	iron_full_helm.level_required = 17
	iron_full_helm.xp_per_action = 50.0
	iron_full_helm.action_time = 3.0
	iron_full_helm.consumed_items = {"iron_bar": 2}
	iron_full_helm.produced_items = {"iron_full_helm": 1}
	methods.append(iron_full_helm)
	
	# Level 19: Iron Sword
	var iron_sword := TrainingMethodData.new()
	iron_sword.id = "iron_sword"
	iron_sword.name = "Iron Sword"
	iron_sword.description = "Smith an iron sword."
	iron_sword.level_required = 19
	iron_sword.xp_per_action = 25.0
	iron_sword.action_time = 2.5
	iron_sword.consumed_items = {"iron_bar": 1}
	iron_sword.produced_items = {"iron_sword": 1}
	methods.append(iron_sword)
	
	# Level 20: Iron Scimitar
	var iron_scimitar := TrainingMethodData.new()
	iron_scimitar.id = "iron_scimitar"
	iron_scimitar.name = "Iron Scimitar"
	iron_scimitar.description = "Smith an iron scimitar."
	iron_scimitar.level_required = 20
	iron_scimitar.xp_per_action = 50.0
	iron_scimitar.action_time = 3.0
	iron_scimitar.consumed_items = {"iron_bar": 2}
	iron_scimitar.produced_items = {"iron_scimitar": 1}
	methods.append(iron_scimitar)
	
	# Level 21: Iron Platelegs
	var iron_platelegs := TrainingMethodData.new()
	iron_platelegs.id = "iron_platelegs"
	iron_platelegs.name = "Iron Platelegs"
	iron_platelegs.description = "Smith iron platelegs."
	iron_platelegs.level_required = 21
	iron_platelegs.xp_per_action = 75.0
	iron_platelegs.action_time = 4.0
	iron_platelegs.consumed_items = {"iron_bar": 3}
	iron_platelegs.produced_items = {"iron_platelegs": 1}
	methods.append(iron_platelegs)
	
	# Level 23: Iron Platebody
	var iron_platebody := TrainingMethodData.new()
	iron_platebody.id = "iron_platebody"
	iron_platebody.name = "Iron Platebody"
	iron_platebody.description = "Smith an iron platebody."
	iron_platebody.level_required = 23
	iron_platebody.xp_per_action = 125.0
	iron_platebody.action_time = 5.0
	iron_platebody.consumed_items = {"iron_bar": 5}
	iron_platebody.produced_items = {"iron_platebody": 1}
	methods.append(iron_platebody)
	
	# STEEL ITEMS (Level 30+)
	# Level 30: Steel Arrowheads (15 per bar)
	var steel_arrowheads := TrainingMethodData.new()
	steel_arrowheads.id = "steel_arrowheads"
	steel_arrowheads.name = "Steel Arrowheads"
	steel_arrowheads.description = "Smith steel arrowheads from a steel bar."
	steel_arrowheads.level_required = 30
	steel_arrowheads.xp_per_action = 37.5
	steel_arrowheads.action_time = 2.0
	steel_arrowheads.consumed_items = {"steel_bar": 1}
	steel_arrowheads.produced_items = {"steel_arrowhead": 15}
	methods.append(steel_arrowheads)
	
	# Level 30: Steel Dagger
	var steel_dagger := TrainingMethodData.new()
	steel_dagger.id = "steel_dagger"
	steel_dagger.name = "Steel Dagger"
	steel_dagger.description = "Smith a steel dagger."
	steel_dagger.level_required = 30
	steel_dagger.xp_per_action = 37.5
	steel_dagger.action_time = 2.5
	steel_dagger.consumed_items = {"steel_bar": 1}
	steel_dagger.produced_items = {"steel_dagger": 1}
	methods.append(steel_dagger)
	
	# Level 32: Steel Full Helm
	var steel_full_helm := TrainingMethodData.new()
	steel_full_helm.id = "steel_full_helm"
	steel_full_helm.name = "Steel Full Helm"
	steel_full_helm.description = "Smith a steel full helmet."
	steel_full_helm.level_required = 32
	steel_full_helm.xp_per_action = 75.0
	steel_full_helm.action_time = 3.0
	steel_full_helm.consumed_items = {"steel_bar": 2}
	steel_full_helm.produced_items = {"steel_full_helm": 1}
	methods.append(steel_full_helm)
	
	# Level 34: Steel Sword
	var steel_sword := TrainingMethodData.new()
	steel_sword.id = "steel_sword"
	steel_sword.name = "Steel Sword"
	steel_sword.description = "Smith a steel sword."
	steel_sword.level_required = 34
	steel_sword.xp_per_action = 37.5
	steel_sword.action_time = 2.5
	steel_sword.consumed_items = {"steel_bar": 1}
	steel_sword.produced_items = {"steel_sword": 1}
	methods.append(steel_sword)
	
	# Level 35: Steel Scimitar
	var steel_scimitar := TrainingMethodData.new()
	steel_scimitar.id = "steel_scimitar"
	steel_scimitar.name = "Steel Scimitar"
	steel_scimitar.description = "Smith a steel scimitar."
	steel_scimitar.level_required = 35
	steel_scimitar.xp_per_action = 75.0
	steel_scimitar.action_time = 3.0
	steel_scimitar.consumed_items = {"steel_bar": 2}
	steel_scimitar.produced_items = {"steel_scimitar": 1}
	methods.append(steel_scimitar)
	
	# Level 36: Steel Platelegs
	var steel_platelegs := TrainingMethodData.new()
	steel_platelegs.id = "steel_platelegs"
	steel_platelegs.name = "Steel Platelegs"
	steel_platelegs.description = "Smith steel platelegs."
	steel_platelegs.level_required = 36
	steel_platelegs.xp_per_action = 112.5
	steel_platelegs.action_time = 4.0
	steel_platelegs.consumed_items = {"steel_bar": 3}
	steel_platelegs.produced_items = {"steel_platelegs": 1}
	methods.append(steel_platelegs)
	
	# Level 38: Steel Platebody
	var steel_platebody := TrainingMethodData.new()
	steel_platebody.id = "steel_platebody"
	steel_platebody.name = "Steel Platebody"
	steel_platebody.description = "Smith a steel platebody."
	steel_platebody.level_required = 38
	steel_platebody.xp_per_action = 187.5
	steel_platebody.action_time = 5.0
	steel_platebody.consumed_items = {"steel_bar": 5}
	steel_platebody.produced_items = {"steel_platebody": 1}
	methods.append(steel_platebody)
	
	# MITHRIL ITEMS (Level 50+)
	# Level 50: Mithril Arrowheads (15 per bar)
	var mithril_arrowheads := TrainingMethodData.new()
	mithril_arrowheads.id = "mithril_arrowheads"
	mithril_arrowheads.name = "Mithril Arrowheads"
	mithril_arrowheads.description = "Smith mithril arrowheads from a mithril bar."
	mithril_arrowheads.level_required = 50
	mithril_arrowheads.xp_per_action = 50.0
	mithril_arrowheads.action_time = 2.0
	mithril_arrowheads.consumed_items = {"mithril_bar": 1}
	mithril_arrowheads.produced_items = {"mithril_arrowhead": 15}
	methods.append(mithril_arrowheads)
	
	# Level 50: Mithril Dagger
	var mithril_dagger := TrainingMethodData.new()
	mithril_dagger.id = "mithril_dagger"
	mithril_dagger.name = "Mithril Dagger"
	mithril_dagger.description = "Smith a mithril dagger."
	mithril_dagger.level_required = 50
	mithril_dagger.xp_per_action = 50.0
	mithril_dagger.action_time = 2.5
	mithril_dagger.consumed_items = {"mithril_bar": 1}
	mithril_dagger.produced_items = {"mithril_dagger": 1}
	methods.append(mithril_dagger)
	
	# Level 52: Mithril Full Helm
	var mithril_full_helm := TrainingMethodData.new()
	mithril_full_helm.id = "mithril_full_helm"
	mithril_full_helm.name = "Mithril Full Helm"
	mithril_full_helm.description = "Smith a mithril full helmet."
	mithril_full_helm.level_required = 52
	mithril_full_helm.xp_per_action = 100.0
	mithril_full_helm.action_time = 3.0
	mithril_full_helm.consumed_items = {"mithril_bar": 2}
	mithril_full_helm.produced_items = {"mithril_full_helm": 1}
	methods.append(mithril_full_helm)
	
	# Level 54: Mithril Sword
	var mithril_sword := TrainingMethodData.new()
	mithril_sword.id = "mithril_sword"
	mithril_sword.name = "Mithril Sword"
	mithril_sword.description = "Smith a mithril sword."
	mithril_sword.level_required = 54
	mithril_sword.xp_per_action = 50.0
	mithril_sword.action_time = 2.5
	mithril_sword.consumed_items = {"mithril_bar": 1}
	mithril_sword.produced_items = {"mithril_sword": 1}
	methods.append(mithril_sword)
	
	# Level 55: Mithril Scimitar
	var mithril_scimitar := TrainingMethodData.new()
	mithril_scimitar.id = "mithril_scimitar"
	mithril_scimitar.name = "Mithril Scimitar"
	mithril_scimitar.description = "Smith a mithril scimitar."
	mithril_scimitar.level_required = 55
	mithril_scimitar.xp_per_action = 100.0
	mithril_scimitar.action_time = 3.0
	mithril_scimitar.consumed_items = {"mithril_bar": 2}
	mithril_scimitar.produced_items = {"mithril_scimitar": 1}
	methods.append(mithril_scimitar)
	
	# Level 56: Mithril Platelegs
	var mithril_platelegs := TrainingMethodData.new()
	mithril_platelegs.id = "mithril_platelegs"
	mithril_platelegs.name = "Mithril Platelegs"
	mithril_platelegs.description = "Smith mithril platelegs."
	mithril_platelegs.level_required = 56
	mithril_platelegs.xp_per_action = 150.0
	mithril_platelegs.action_time = 4.0
	mithril_platelegs.consumed_items = {"mithril_bar": 3}
	mithril_platelegs.produced_items = {"mithril_platelegs": 1}
	methods.append(mithril_platelegs)
	
	# Level 58: Mithril Platebody
	var mithril_platebody := TrainingMethodData.new()
	mithril_platebody.id = "mithril_platebody"
	mithril_platebody.name = "Mithril Platebody"
	mithril_platebody.description = "Smith a mithril platebody."
	mithril_platebody.level_required = 58
	mithril_platebody.xp_per_action = 250.0
	mithril_platebody.action_time = 5.0
	mithril_platebody.consumed_items = {"mithril_bar": 5}
	mithril_platebody.produced_items = {"mithril_platebody": 1}
	methods.append(mithril_platebody)
	
	# ADAMANTITE ITEMS (Level 70+)
	# Level 70: Adamantite Arrowheads (15 per bar)
	var adamantite_arrowheads := TrainingMethodData.new()
	adamantite_arrowheads.id = "adamantite_arrowheads"
	adamantite_arrowheads.name = "Adamantite Arrowheads"
	adamantite_arrowheads.description = "Smith adamantite arrowheads from an adamantite bar."
	adamantite_arrowheads.level_required = 70
	adamantite_arrowheads.xp_per_action = 62.5
	adamantite_arrowheads.action_time = 2.0
	adamantite_arrowheads.consumed_items = {"adamantite_bar": 1}
	adamantite_arrowheads.produced_items = {"adamantite_arrowhead": 15}
	methods.append(adamantite_arrowheads)
	
	# Level 70: Adamantite Dagger
	var adamantite_dagger := TrainingMethodData.new()
	adamantite_dagger.id = "adamantite_dagger"
	adamantite_dagger.name = "Adamantite Dagger"
	adamantite_dagger.description = "Smith an adamantite dagger."
	adamantite_dagger.level_required = 70
	adamantite_dagger.xp_per_action = 62.5
	adamantite_dagger.action_time = 2.5
	adamantite_dagger.consumed_items = {"adamantite_bar": 1}
	adamantite_dagger.produced_items = {"adamantite_dagger": 1}
	methods.append(adamantite_dagger)
	
	# Level 72: Adamantite Full Helm
	var adamantite_full_helm := TrainingMethodData.new()
	adamantite_full_helm.id = "adamantite_full_helm"
	adamantite_full_helm.name = "Adamantite Full Helm"
	adamantite_full_helm.description = "Smith an adamantite full helmet."
	adamantite_full_helm.level_required = 72
	adamantite_full_helm.xp_per_action = 125.0
	adamantite_full_helm.action_time = 3.0
	adamantite_full_helm.consumed_items = {"adamantite_bar": 2}
	adamantite_full_helm.produced_items = {"adamantite_full_helm": 1}
	methods.append(adamantite_full_helm)
	
	# Level 74: Adamantite Sword
	var adamantite_sword := TrainingMethodData.new()
	adamantite_sword.id = "adamantite_sword"
	adamantite_sword.name = "Adamantite Sword"
	adamantite_sword.description = "Smith an adamantite sword."
	adamantite_sword.level_required = 74
	adamantite_sword.xp_per_action = 62.5
	adamantite_sword.action_time = 2.5
	adamantite_sword.consumed_items = {"adamantite_bar": 1}
	adamantite_sword.produced_items = {"adamantite_sword": 1}
	methods.append(adamantite_sword)
	
	# Level 75: Adamantite Scimitar
	var adamantite_scimitar := TrainingMethodData.new()
	adamantite_scimitar.id = "adamantite_scimitar"
	adamantite_scimitar.name = "Adamantite Scimitar"
	adamantite_scimitar.description = "Smith an adamantite scimitar."
	adamantite_scimitar.level_required = 75
	adamantite_scimitar.xp_per_action = 125.0
	adamantite_scimitar.action_time = 3.0
	adamantite_scimitar.consumed_items = {"adamantite_bar": 2}
	adamantite_scimitar.produced_items = {"adamantite_scimitar": 1}
	methods.append(adamantite_scimitar)
	
	# Level 76: Adamantite Platelegs
	var adamantite_platelegs := TrainingMethodData.new()
	adamantite_platelegs.id = "adamantite_platelegs"
	adamantite_platelegs.name = "Adamantite Platelegs"
	adamantite_platelegs.description = "Smith adamantite platelegs."
	adamantite_platelegs.level_required = 76
	adamantite_platelegs.xp_per_action = 187.5
	adamantite_platelegs.action_time = 4.0
	adamantite_platelegs.consumed_items = {"adamantite_bar": 3}
	adamantite_platelegs.produced_items = {"adamantite_platelegs": 1}
	methods.append(adamantite_platelegs)
	
	# Level 78: Adamantite Platebody
	var adamantite_platebody := TrainingMethodData.new()
	adamantite_platebody.id = "adamantite_platebody"
	adamantite_platebody.name = "Adamantite Platebody"
	adamantite_platebody.description = "Smith an adamantite platebody."
	adamantite_platebody.level_required = 78
	adamantite_platebody.xp_per_action = 312.5
	adamantite_platebody.action_time = 5.0
	adamantite_platebody.consumed_items = {"adamantite_bar": 5}
	adamantite_platebody.produced_items = {"adamantite_platebody": 1}
	methods.append(adamantite_platebody)
	
	# RUNITE ITEMS (Level 85+)
	# Level 85: Runite Arrowheads (15 per bar)
	var runite_arrowheads := TrainingMethodData.new()
	runite_arrowheads.id = "runite_arrowheads"
	runite_arrowheads.name = "Runite Arrowheads"
	runite_arrowheads.description = "Smith runite arrowheads from a runite bar."
	runite_arrowheads.level_required = 85
	runite_arrowheads.xp_per_action = 75.0
	runite_arrowheads.action_time = 2.0
	runite_arrowheads.consumed_items = {"runite_bar": 1}
	runite_arrowheads.produced_items = {"runite_arrowhead": 15}
	methods.append(runite_arrowheads)
	
	# Level 85: Runite Dagger
	var runite_dagger := TrainingMethodData.new()
	runite_dagger.id = "runite_dagger"
	runite_dagger.name = "Runite Dagger"
	runite_dagger.description = "Smith a runite dagger."
	runite_dagger.level_required = 85
	runite_dagger.xp_per_action = 75.0
	runite_dagger.action_time = 2.5
	runite_dagger.consumed_items = {"runite_bar": 1}
	runite_dagger.produced_items = {"runite_dagger": 1}
	methods.append(runite_dagger)
	
	# Level 87: Runite Full Helm
	var runite_full_helm := TrainingMethodData.new()
	runite_full_helm.id = "runite_full_helm"
	runite_full_helm.name = "Runite Full Helm"
	runite_full_helm.description = "Smith a runite full helmet."
	runite_full_helm.level_required = 87
	runite_full_helm.xp_per_action = 150.0
	runite_full_helm.action_time = 3.0
	runite_full_helm.consumed_items = {"runite_bar": 2}
	runite_full_helm.produced_items = {"runite_full_helm": 1}
	methods.append(runite_full_helm)
	
	# Level 89: Runite Sword
	var runite_sword := TrainingMethodData.new()
	runite_sword.id = "runite_sword"
	runite_sword.name = "Runite Sword"
	runite_sword.description = "Smith a runite sword."
	runite_sword.level_required = 89
	runite_sword.xp_per_action = 75.0
	runite_sword.action_time = 2.5
	runite_sword.consumed_items = {"runite_bar": 1}
	runite_sword.produced_items = {"runite_sword": 1}
	methods.append(runite_sword)
	
	# Level 90: Runite Scimitar
	var runite_scimitar := TrainingMethodData.new()
	runite_scimitar.id = "runite_scimitar"
	runite_scimitar.name = "Runite Scimitar"
	runite_scimitar.description = "Smith a runite scimitar."
	runite_scimitar.level_required = 90
	runite_scimitar.xp_per_action = 150.0
	runite_scimitar.action_time = 3.0
	runite_scimitar.consumed_items = {"runite_bar": 2}
	runite_scimitar.produced_items = {"runite_scimitar": 1}
	methods.append(runite_scimitar)
	
	# Level 91: Runite Platelegs
	var runite_platelegs := TrainingMethodData.new()
	runite_platelegs.id = "runite_platelegs"
	runite_platelegs.name = "Runite Platelegs"
	runite_platelegs.description = "Smith runite platelegs."
	runite_platelegs.level_required = 91
	runite_platelegs.xp_per_action = 225.0
	runite_platelegs.action_time = 4.0
	runite_platelegs.consumed_items = {"runite_bar": 3}
	runite_platelegs.produced_items = {"runite_platelegs": 1}
	methods.append(runite_platelegs)
	
	# Level 93: Runite Platebody
	var runite_platebody := TrainingMethodData.new()
	runite_platebody.id = "runite_platebody"
	runite_platebody.name = "Runite Platebody"
	runite_platebody.description = "Smith a runite platebody."
	runite_platebody.level_required = 93
	runite_platebody.xp_per_action = 375.0
	runite_platebody.action_time = 5.0
	runite_platebody.consumed_items = {"runite_bar": 5}
	runite_platebody.produced_items = {"runite_platebody": 1}
	methods.append(runite_platebody)
	
	return methods
