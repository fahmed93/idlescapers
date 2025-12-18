## Fletching Skill
## Contains training methods for the Fletching skill
extends Node

## Create and return all fletching training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	# Level 1: Arrow Shafts (15 per log - matches OSRS design)
	var arrow_shafts := TrainingMethodData.new()
	arrow_shafts.id = "arrow_shafts"
	arrow_shafts.name = "Arrow Shafts"
	arrow_shafts.description = "Cut logs into arrow shafts."
	arrow_shafts.level_required = 1
	arrow_shafts.xp_per_action = 5.0
	arrow_shafts.action_time = 2.0
	arrow_shafts.consumed_items = {"logs": 1}
	arrow_shafts.produced_items = {"arrow_shafts": 15}
	methods.append(arrow_shafts)
	
	# Level 1: Headless Arrows (attach feathers to shafts)
	var headless_arrow := TrainingMethodData.new()
	headless_arrow.id = "headless_arrow"
	headless_arrow.name = "Headless Arrow"
	headless_arrow.description = "Attach feathers to arrow shafts."
	headless_arrow.level_required = 1
	headless_arrow.xp_per_action = 2.0
	headless_arrow.action_time = 1.0
	headless_arrow.consumed_items = {"arrow_shafts": 1, "feather": 1}
	headless_arrow.produced_items = {"headless_arrow": 1}
	methods.append(headless_arrow)
	
	# Level 1: Bronze Arrows
	var bronze_arrow := TrainingMethodData.new()
	bronze_arrow.id = "bronze_arrow"
	bronze_arrow.name = "Bronze Arrow"
	bronze_arrow.description = "Attach bronze arrowheads to headless arrows."
	bronze_arrow.level_required = 1
	bronze_arrow.xp_per_action = 4.0
	bronze_arrow.action_time = 1.5
	bronze_arrow.consumed_items = {"headless_arrow": 1, "bronze_arrowhead": 1}
	bronze_arrow.produced_items = {"bronze_arrow": 1}
	methods.append(bronze_arrow)
	
	# Level 5: Shortbow
	var shortbow := TrainingMethodData.new()
	shortbow.id = "shortbow"
	shortbow.name = "Shortbow"
	shortbow.description = "Fletch a basic shortbow."
	shortbow.level_required = 5
	shortbow.xp_per_action = 10.0
	shortbow.action_time = 2.5
	shortbow.consumed_items = {"logs": 1, "bowstring": 1}
	shortbow.produced_items = {"shortbow": 1}
	methods.append(shortbow)
	
	# Level 10: Longbow
	var longbow := TrainingMethodData.new()
	longbow.id = "longbow"
	longbow.name = "Longbow"
	longbow.description = "Fletch a basic longbow."
	longbow.level_required = 10
	longbow.xp_per_action = 20.0
	longbow.action_time = 3.0
	longbow.consumed_items = {"logs": 1, "bowstring": 1}
	longbow.produced_items = {"longbow": 1}
	methods.append(longbow)
	
	# Level 20: Oak Shortbow
	var oak_shortbow := TrainingMethodData.new()
	oak_shortbow.id = "oak_shortbow"
	oak_shortbow.name = "Oak Shortbow"
	oak_shortbow.description = "Fletch an oak shortbow."
	oak_shortbow.level_required = 20
	oak_shortbow.xp_per_action = 33.0
	oak_shortbow.action_time = 2.5
	oak_shortbow.consumed_items = {"oak_logs": 1, "bowstring": 1}
	oak_shortbow.produced_items = {"oak_shortbow": 1}
	methods.append(oak_shortbow)
	
	# Level 25: Oak Longbow
	var oak_longbow := TrainingMethodData.new()
	oak_longbow.id = "oak_longbow"
	oak_longbow.name = "Oak Longbow"
	oak_longbow.description = "Fletch an oak longbow."
	oak_longbow.level_required = 25
	oak_longbow.xp_per_action = 50.0
	oak_longbow.action_time = 3.0
	oak_longbow.consumed_items = {"oak_logs": 1, "bowstring": 1}
	oak_longbow.produced_items = {"oak_longbow": 1}
	methods.append(oak_longbow)
	
	# Level 35: Willow Shortbow
	var willow_shortbow := TrainingMethodData.new()
	willow_shortbow.id = "willow_shortbow"
	willow_shortbow.name = "Willow Shortbow"
	willow_shortbow.description = "Fletch a willow shortbow."
	willow_shortbow.level_required = 35
	willow_shortbow.xp_per_action = 66.5
	willow_shortbow.action_time = 2.5
	willow_shortbow.consumed_items = {"willow_logs": 1, "bowstring": 1}
	willow_shortbow.produced_items = {"willow_shortbow": 1}
	methods.append(willow_shortbow)
	
	# Level 40: Willow Longbow
	var willow_longbow := TrainingMethodData.new()
	willow_longbow.id = "willow_longbow"
	willow_longbow.name = "Willow Longbow"
	willow_longbow.description = "Fletch a willow longbow."
	willow_longbow.level_required = 40
	willow_longbow.xp_per_action = 83.0
	willow_longbow.action_time = 3.0
	willow_longbow.consumed_items = {"willow_logs": 1, "bowstring": 1}
	willow_longbow.produced_items = {"willow_longbow": 1}
	methods.append(willow_longbow)
	
	# Level 50: Maple Shortbow
	var maple_shortbow := TrainingMethodData.new()
	maple_shortbow.id = "maple_shortbow"
	maple_shortbow.name = "Maple Shortbow"
	maple_shortbow.description = "Fletch a maple shortbow."
	maple_shortbow.level_required = 50
	maple_shortbow.xp_per_action = 100.0
	maple_shortbow.action_time = 2.5
	maple_shortbow.consumed_items = {"maple_logs": 1, "bowstring": 1}
	maple_shortbow.produced_items = {"maple_shortbow": 1}
	methods.append(maple_shortbow)
	
	# Level 55: Maple Longbow
	var maple_longbow := TrainingMethodData.new()
	maple_longbow.id = "maple_longbow"
	maple_longbow.name = "Maple Longbow"
	maple_longbow.description = "Fletch a maple longbow."
	maple_longbow.level_required = 55
	maple_longbow.xp_per_action = 116.5
	maple_longbow.action_time = 3.0
	maple_longbow.consumed_items = {"maple_logs": 1, "bowstring": 1}
	maple_longbow.produced_items = {"maple_longbow": 1}
	methods.append(maple_longbow)
	
	# Level 65: Yew Shortbow
	var yew_shortbow := TrainingMethodData.new()
	yew_shortbow.id = "yew_shortbow"
	yew_shortbow.name = "Yew Shortbow"
	yew_shortbow.description = "Fletch a yew shortbow."
	yew_shortbow.level_required = 65
	yew_shortbow.xp_per_action = 135.0
	yew_shortbow.action_time = 2.5
	yew_shortbow.consumed_items = {"yew_logs": 1, "bowstring": 1}
	yew_shortbow.produced_items = {"yew_shortbow": 1}
	methods.append(yew_shortbow)
	
	# Level 70: Yew Longbow
	var yew_longbow := TrainingMethodData.new()
	yew_longbow.id = "yew_longbow"
	yew_longbow.name = "Yew Longbow"
	yew_longbow.description = "Fletch a yew longbow."
	yew_longbow.level_required = 70
	yew_longbow.xp_per_action = 150.0
	yew_longbow.action_time = 3.0
	yew_longbow.consumed_items = {"yew_logs": 1, "bowstring": 1}
	yew_longbow.produced_items = {"yew_longbow": 1}
	methods.append(yew_longbow)
	
	# Level 80: Magic Shortbow
	var magic_shortbow := TrainingMethodData.new()
	magic_shortbow.id = "magic_shortbow"
	magic_shortbow.name = "Magic Shortbow"
	magic_shortbow.description = "Fletch a magic shortbow."
	magic_shortbow.level_required = 80
	magic_shortbow.xp_per_action = 166.5
	magic_shortbow.action_time = 2.5
	magic_shortbow.consumed_items = {"magic_logs": 1, "bowstring": 1}
	magic_shortbow.produced_items = {"magic_shortbow": 1}
	methods.append(magic_shortbow)
	
	# Level 85: Magic Longbow
	var magic_longbow := TrainingMethodData.new()
	magic_longbow.id = "magic_longbow"
	magic_longbow.name = "Magic Longbow"
	magic_longbow.description = "Fletch a magic longbow."
	magic_longbow.level_required = 85
	magic_longbow.xp_per_action = 183.0
	magic_longbow.action_time = 3.0
	magic_longbow.consumed_items = {"magic_logs": 1, "bowstring": 1}
	magic_longbow.produced_items = {"magic_longbow": 1}
	methods.append(magic_longbow)
	
	return methods
