## Foraging Skill
## Contains training methods for the Foraging skill
extends Node

## Create and return all foraging training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	# Level 1: Dirty Guam Leaf
	var guam := TrainingMethodData.new()
	guam.id = "dirty_guam"
	guam.name = "Dirty Guam Leaf"
	guam.description = "Forage for grimy guam leaves in the wild."
	guam.level_required = 1
	guam.xp_per_action = 8.0
	guam.action_time = 2.5
	guam.produced_items = {"dirty_guam_leaf": 1}
	methods.append(guam)
	
	# Level 5: Dirty Marrentill
	var marrentill := TrainingMethodData.new()
	marrentill.id = "dirty_marrentill"
	marrentill.name = "Dirty Marrentill"
	marrentill.description = "Forage for grimy marrentill in the wild."
	marrentill.level_required = 5
	marrentill.xp_per_action = 10.0
	marrentill.action_time = 2.8
	marrentill.produced_items = {"dirty_marrentill": 1}
	methods.append(marrentill)
	
	# Level 11: Dirty Tarromin
	var tarromin := TrainingMethodData.new()
	tarromin.id = "dirty_tarromin"
	tarromin.name = "Dirty Tarromin"
	tarromin.description = "Forage for grimy tarromin in the wild."
	tarromin.level_required = 11
	tarromin.xp_per_action = 12.0
	tarromin.action_time = 3.0
	tarromin.produced_items = {"dirty_tarromin": 1}
	methods.append(tarromin)
	
	# Level 20: Dirty Harralander
	var harralander := TrainingMethodData.new()
	harralander.id = "dirty_harralander"
	harralander.name = "Dirty Harralander"
	harralander.description = "Forage for grimy harralander in the wild."
	harralander.level_required = 20
	harralander.xp_per_action = 15.0
	harralander.action_time = 3.2
	harralander.produced_items = {"dirty_harralander": 1}
	methods.append(harralander)
	
	# Level 25: Dirty Ranarr Weed
	var ranarr := TrainingMethodData.new()
	ranarr.id = "dirty_ranarr"
	ranarr.name = "Dirty Ranarr Weed"
	ranarr.description = "Forage for grimy ranarr weed in the wild."
	ranarr.level_required = 25
	ranarr.xp_per_action = 20.0
	ranarr.action_time = 3.5
	ranarr.produced_items = {"dirty_ranarr_weed": 1}
	methods.append(ranarr)
	
	# Level 30: Dirty Toadflax
	var toadflax := TrainingMethodData.new()
	toadflax.id = "dirty_toadflax"
	toadflax.name = "Dirty Toadflax"
	toadflax.description = "Forage for grimy toadflax in the wild."
	toadflax.level_required = 30
	toadflax.xp_per_action = 25.0
	toadflax.action_time = 3.8
	toadflax.produced_items = {"dirty_toadflax": 1}
	methods.append(toadflax)
	
	# Level 40: Dirty Irit Leaf
	var irit := TrainingMethodData.new()
	irit.id = "dirty_irit"
	irit.name = "Dirty Irit Leaf"
	irit.description = "Forage for grimy irit leaves in the wild."
	irit.level_required = 40
	irit.xp_per_action = 35.0
	irit.action_time = 4.0
	irit.produced_items = {"dirty_irit_leaf": 1}
	methods.append(irit)
	
	# Level 48: Dirty Avantoe
	var avantoe := TrainingMethodData.new()
	avantoe.id = "dirty_avantoe"
	avantoe.name = "Dirty Avantoe"
	avantoe.description = "Forage for grimy avantoe in the wild."
	avantoe.level_required = 48
	avantoe.xp_per_action = 45.0
	avantoe.action_time = 4.2
	avantoe.produced_items = {"dirty_avantoe": 1}
	methods.append(avantoe)
	
	# Level 54: Dirty Kwuarm
	var kwuarm := TrainingMethodData.new()
	kwuarm.id = "dirty_kwuarm"
	kwuarm.name = "Dirty Kwuarm"
	kwuarm.description = "Forage for grimy kwuarm in the wild."
	kwuarm.level_required = 54
	kwuarm.xp_per_action = 55.0
	kwuarm.action_time = 4.5
	kwuarm.produced_items = {"dirty_kwuarm": 1}
	methods.append(kwuarm)
	
	# Level 59: Dirty Snapdragon
	var snapdragon := TrainingMethodData.new()
	snapdragon.id = "dirty_snapdragon"
	snapdragon.name = "Dirty Snapdragon"
	snapdragon.description = "Forage for grimy snapdragon in the wild."
	snapdragon.level_required = 59
	snapdragon.xp_per_action = 70.0
	snapdragon.action_time = 4.8
	snapdragon.produced_items = {"dirty_snapdragon": 1}
	methods.append(snapdragon)
	
	# Level 65: Dirty Cadantine
	var cadantine := TrainingMethodData.new()
	cadantine.id = "dirty_cadantine"
	cadantine.name = "Dirty Cadantine"
	cadantine.description = "Forage for grimy cadantine in the wild."
	cadantine.level_required = 65
	cadantine.xp_per_action = 85.0
	cadantine.action_time = 5.0
	cadantine.produced_items = {"dirty_cadantine": 1}
	methods.append(cadantine)
	
	# Level 67: Dirty Lantadyme
	var lantadyme := TrainingMethodData.new()
	lantadyme.id = "dirty_lantadyme"
	lantadyme.name = "Dirty Lantadyme"
	lantadyme.description = "Forage for grimy lantadyme in the wild."
	lantadyme.level_required = 67
	lantadyme.xp_per_action = 95.0
	lantadyme.action_time = 5.2
	lantadyme.produced_items = {"dirty_lantadyme": 1}
	methods.append(lantadyme)
	
	# Level 70: Dirty Dwarf Weed
	var dwarf_weed := TrainingMethodData.new()
	dwarf_weed.id = "dirty_dwarf_weed"
	dwarf_weed.name = "Dirty Dwarf Weed"
	dwarf_weed.description = "Forage for grimy dwarf weed in the wild."
	dwarf_weed.level_required = 70
	dwarf_weed.xp_per_action = 110.0
	dwarf_weed.action_time = 5.5
	dwarf_weed.produced_items = {"dirty_dwarf_weed": 1}
	methods.append(dwarf_weed)
	
	# Level 75: Dirty Torstol
	var torstol := TrainingMethodData.new()
	torstol.id = "dirty_torstol"
	torstol.name = "Dirty Torstol"
	torstol.description = "Forage for grimy torstol, the most powerful herb."
	torstol.level_required = 75
	torstol.xp_per_action = 150.0
	torstol.action_time = 6.0
	torstol.produced_items = {"dirty_torstol": 1}
	methods.append(torstol)
	
	return methods
