## Woodcutting Skill
## Contains training methods for the Woodcutting skill
extends Node

## Create and return all woodcutting training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var normal_tree := TrainingMethodData.new()
	normal_tree.id = "normal_tree"
	normal_tree.name = "Tree"
	normal_tree.description = "A regular tree found throughout the land."
	normal_tree.level_required = 1
	normal_tree.xp_per_action = 25.0
	normal_tree.action_time = 3.0
	normal_tree.produced_items = {"logs": 1}
	methods.append(normal_tree)
	
	var oak := TrainingMethodData.new()
	oak.id = "oak"
	oak.name = "Oak Tree"
	oak.description = "A sturdy oak tree."
	oak.level_required = 15
	oak.xp_per_action = 37.5
	oak.action_time = 4.0
	oak.produced_items = {"oak_logs": 1}
	methods.append(oak)
	
	var willow := TrainingMethodData.new()
	willow.id = "willow"
	willow.name = "Willow Tree"
	willow.description = "A weeping willow tree near water."
	willow.level_required = 30
	willow.xp_per_action = 67.5
	willow.action_time = 4.5
	willow.produced_items = {"willow_logs": 1}
	methods.append(willow)
	
	var maple := TrainingMethodData.new()
	maple.id = "maple"
	maple.name = "Maple Tree"
	maple.description = "A tree with distinctive leaves."
	maple.level_required = 45
	maple.xp_per_action = 100.0
	maple.action_time = 5.0
	maple.produced_items = {"maple_logs": 1}
	methods.append(maple)
	
	var yew := TrainingMethodData.new()
	yew.id = "yew"
	yew.name = "Yew Tree"
	yew.description = "An ancient and valuable tree."
	yew.level_required = 60
	yew.xp_per_action = 175.0
	yew.action_time = 6.0
	yew.produced_items = {"yew_logs": 1}
	methods.append(yew)
	
	var magic := TrainingMethodData.new()
	magic.id = "magic"
	magic.name = "Magic Tree"
	magic.description = "A tree imbued with magical essence."
	magic.level_required = 75
	magic.xp_per_action = 250.0
	magic.action_time = 8.0
	magic.produced_items = {"magic_logs": 1}
	methods.append(magic)
	
	var redwood := TrainingMethodData.new()
	redwood.id = "redwood"
	redwood.name = "Redwood Tree"
	redwood.description = "A massive ancient tree."
	redwood.level_required = 90
	redwood.xp_per_action = 380.0
	redwood.action_time = 10.0
	redwood.produced_items = {"redwood_logs": 1}
	methods.append(redwood)
	
	# Additional training methods
	var achey := TrainingMethodData.new()
	achey.id = "achey"
	achey.name = "Achey Tree"
	achey.description = "A thin, flexible tree good for crafting."
	achey.level_required = 5
	achey.xp_per_action = 30.0
	achey.action_time = 3.5
	achey.produced_items = {"achey_logs": 1}
	methods.append(achey)
	
	var teak := TrainingMethodData.new()
	teak.id = "teak"
	teak.name = "Teak Tree"
	teak.description = "A durable tropical hardwood tree."
	teak.level_required = 35
	teak.xp_per_action = 85.0
	teak.action_time = 6.0
	teak.produced_items = {"teak_logs": 1}
	methods.append(teak)
	
	var mahogany := TrainingMethodData.new()
	mahogany.id = "mahogany"
	mahogany.name = "Mahogany Tree"
	mahogany.description = "A rich, reddish-brown wood highly valued for furniture."
	mahogany.level_required = 50
	mahogany.xp_per_action = 125.0
	mahogany.action_time = 7.0
	mahogany.produced_items = {"mahogany_logs": 1}
	methods.append(mahogany)
	
	var arctic_pine := TrainingMethodData.new()
	arctic_pine.id = "arctic_pine"
	arctic_pine.name = "Arctic Pine"
	arctic_pine.description = "A hardy pine from frozen regions."
	arctic_pine.level_required = 55
	arctic_pine.xp_per_action = 140.0
	arctic_pine.action_time = 6.5
	arctic_pine.produced_items = {"arctic_pine_logs": 1}
	methods.append(arctic_pine)
	
	var eucalyptus := TrainingMethodData.new()
	eucalyptus.id = "eucalyptus"
	eucalyptus.name = "Eucalyptus Tree"
	eucalyptus.description = "A fragrant tree with medicinal properties."
	eucalyptus.level_required = 58
	eucalyptus.xp_per_action = 165.0
	eucalyptus.action_time = 7.5
	eucalyptus.produced_items = {"eucalyptus_logs": 1}
	methods.append(eucalyptus)
	
	var elder := TrainingMethodData.new()
	elder.id = "elder"
	elder.name = "Elder Tree"
	elder.description = "A mystical tree with spiritual significance."
	elder.level_required = 65
	elder.xp_per_action = 190.0
	elder.action_time = 7.0
	elder.produced_items = {"elder_logs": 1}
	methods.append(elder)
	
	var blisterwood := TrainingMethodData.new()
	blisterwood.id = "blisterwood"
	blisterwood.name = "Blisterwood Tree"
	blisterwood.description = "A cursed tree with dark power."
	blisterwood.level_required = 70
	blisterwood.xp_per_action = 220.0
	blisterwood.action_time = 8.5
	blisterwood.produced_items = {"blisterwood_logs": 1}
	methods.append(blisterwood)
	
	var bloodwood := TrainingMethodData.new()
	bloodwood.id = "bloodwood"
	bloodwood.name = "Bloodwood Tree"
	bloodwood.description = "A rare tree that oozes crimson sap."
	bloodwood.level_required = 78
	bloodwood.xp_per_action = 280.0
	bloodwood.action_time = 9.0
	bloodwood.produced_items = {"bloodwood_logs": 1}
	methods.append(bloodwood)
	
	var crystal := TrainingMethodData.new()
	crystal.id = "crystal"
	crystal.name = "Crystal Tree"
	crystal.description = "A shimmering tree formed from pure crystal."
	crystal.level_required = 82
	crystal.xp_per_action = 320.0
	crystal.action_time = 9.5
	crystal.produced_items = {"crystal_logs": 1}
	methods.append(crystal)
	
	var spirit := TrainingMethodData.new()
	spirit.id = "spirit"
	spirit.name = "Spirit Tree"
	spirit.description = "An ancient, sentient tree connected to nature's essence."
	spirit.level_required = 85
	spirit.xp_per_action = 350.0
	spirit.action_time = 11.0
	spirit.produced_items = {"spirit_logs": 1}
	methods.append(spirit)
	
	return methods
