## Firemaking Skill
## Contains training methods for the Firemaking skill
extends Node

## Create and return all firemaking training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var normal_logs := TrainingMethodData.new()
	normal_logs.id = "burn_logs"
	normal_logs.name = "Burn Logs"
	normal_logs.description = "Light a basic fire with common logs."
	normal_logs.level_required = 1
	normal_logs.xp_per_action = 40.0
	normal_logs.action_time = 2.5
	normal_logs.consumed_items = {"logs": 1}
	normal_logs.produced_items = {"ashes": 1}
	methods.append(normal_logs)
	
	var achey_logs := TrainingMethodData.new()
	achey_logs.id = "burn_achey_logs"
	achey_logs.name = "Burn Achey Logs"
	achey_logs.description = "Burn flexible achey logs for a quick fire."
	achey_logs.level_required = 5
	achey_logs.xp_per_action = 45.0
	achey_logs.action_time = 2.8
	achey_logs.consumed_items = {"achey_logs": 1}
	achey_logs.produced_items = {"ashes": 1}
	methods.append(achey_logs)
	
	var oak_logs := TrainingMethodData.new()
	oak_logs.id = "burn_oak_logs"
	oak_logs.name = "Burn Oak Logs"
	oak_logs.description = "Burn sturdy oak logs for a steady flame."
	oak_logs.level_required = 15
	oak_logs.xp_per_action = 60.0
	oak_logs.action_time = 3.0
	oak_logs.consumed_items = {"oak_logs": 1}
	oak_logs.produced_items = {"ashes": 1}
	methods.append(oak_logs)
	
	var willow_logs := TrainingMethodData.new()
	willow_logs.id = "burn_willow_logs"
	willow_logs.name = "Burn Willow Logs"
	willow_logs.description = "Burn flexible willow logs for a crackling fire."
	willow_logs.level_required = 30
	willow_logs.xp_per_action = 90.0
	willow_logs.action_time = 3.5
	willow_logs.consumed_items = {"willow_logs": 1}
	willow_logs.produced_items = {"ashes": 1}
	methods.append(willow_logs)
	
	var teak_logs := TrainingMethodData.new()
	teak_logs.id = "burn_teak_logs"
	teak_logs.name = "Burn Teak Logs"
	teak_logs.description = "Burn tropical teak logs for a long-lasting fire."
	teak_logs.level_required = 35
	teak_logs.xp_per_action = 105.0
	teak_logs.action_time = 3.8
	teak_logs.consumed_items = {"teak_logs": 1}
	teak_logs.produced_items = {"ashes": 1}
	methods.append(teak_logs)
	
	var maple_logs := TrainingMethodData.new()
	maple_logs.id = "burn_maple_logs"
	maple_logs.name = "Burn Maple Logs"
	maple_logs.description = "Burn quality maple logs for a bright fire."
	maple_logs.level_required = 45
	maple_logs.xp_per_action = 135.0
	maple_logs.action_time = 4.0
	maple_logs.consumed_items = {"maple_logs": 1}
	maple_logs.produced_items = {"ashes": 1}
	methods.append(maple_logs)
	
	var mahogany_logs := TrainingMethodData.new()
	mahogany_logs.id = "burn_mahogany_logs"
	mahogany_logs.name = "Burn Mahogany Logs"
	mahogany_logs.description = "Burn valuable mahogany logs for an excellent fire."
	mahogany_logs.level_required = 50
	mahogany_logs.xp_per_action = 157.5
	mahogany_logs.action_time = 4.3
	mahogany_logs.consumed_items = {"mahogany_logs": 1}
	mahogany_logs.produced_items = {"ashes": 1}
	methods.append(mahogany_logs)
	
	var yew_logs := TrainingMethodData.new()
	yew_logs.id = "burn_yew_logs"
	yew_logs.name = "Burn Yew Logs"
	yew_logs.description = "Burn ancient yew logs for a powerful fire."
	yew_logs.level_required = 60
	yew_logs.xp_per_action = 202.5
	yew_logs.action_time = 4.5
	yew_logs.consumed_items = {"yew_logs": 1}
	yew_logs.produced_items = {"ashes": 1}
	methods.append(yew_logs)
	
	var magic_logs := TrainingMethodData.new()
	magic_logs.id = "burn_magic_logs"
	magic_logs.name = "Burn Magic Logs"
	magic_logs.description = "Burn magical logs for an intense, mystical fire."
	magic_logs.level_required = 75
	magic_logs.xp_per_action = 303.8
	magic_logs.action_time = 5.0
	magic_logs.consumed_items = {"magic_logs": 1}
	magic_logs.produced_items = {"ashes": 1}
	methods.append(magic_logs)
	
	var redwood_logs := TrainingMethodData.new()
	redwood_logs.id = "burn_redwood_logs"
	redwood_logs.name = "Burn Redwood Logs"
	redwood_logs.description = "Burn massive redwood logs for a legendary blaze."
	redwood_logs.level_required = 90
	redwood_logs.xp_per_action = 350.0
	redwood_logs.action_time = 5.5
	redwood_logs.consumed_items = {"redwood_logs": 1}
	redwood_logs.produced_items = {"ashes": 1}
	methods.append(redwood_logs)
	
	return methods
