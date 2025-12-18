## GameManager Autoload
## Handles skill levels, XP calculations, and training progression
extends Node

signal skill_xp_gained(skill_id: String, xp: float)
signal skill_level_up(skill_id: String, new_level: int)
signal training_started(skill_id: String, method_id: String)
signal training_stopped(skill_id: String)
signal action_completed(skill_id: String, method_id: String, success: bool)

## Constants for XP curve (RuneScape-style)
const MAX_LEVEL := 99
const XP_MULTIPLIER := 1.0

## Skill data registry
var skills: Dictionary = {}  # skill_id: SkillData

## Player skill progress
var skill_xp: Dictionary = {}  # skill_id: current_xp
var skill_levels: Dictionary = {}  # skill_id: current_level (cached)

## Current training state
var current_skill_id: String = ""
var current_method_id: String = ""
var training_progress: float = 0.0
var is_training: bool = false

## XP table (pre-calculated for levels 1-99)
var xp_table: Array[float] = []

func _ready() -> void:
	_build_xp_table()
	_load_skills()

## Build the XP table using RuneScape-style formula
func _build_xp_table() -> void:
	xp_table.clear()
	xp_table.append(0.0)  # Level 1 = 0 XP
	
	var total_xp := 0.0
	for level in range(2, MAX_LEVEL + 1):
		# RuneScape XP formula: sum of floor(level + 300 * 2^(level/7)) / 4
		var points: float = floor((level - 1) + 300.0 * pow(2.0, (level - 1) / 7.0))
		total_xp += floor(points / 4.0)
		xp_table.append(total_xp * XP_MULTIPLIER)

## Get XP required for a specific level
func get_xp_for_level(level: int) -> float:
	if level < 1:
		return 0.0
	if level > MAX_LEVEL:
		return xp_table[xp_table.size() - 1]
	return xp_table[level - 1]

## Get level from XP amount
func get_level_from_xp(xp: float) -> int:
	for level in range(MAX_LEVEL, 0, -1):
		if xp >= get_xp_for_level(level):
			return level
	return 1

## Get progress to next level (0.0 to 1.0)
func get_level_progress(skill_id: String) -> float:
	var xp: float = skill_xp.get(skill_id, 0.0)
	var level := get_skill_level(skill_id)
	
	if level >= MAX_LEVEL:
		return 1.0
	
	var current_level_xp := get_xp_for_level(level)
	var next_level_xp := get_xp_for_level(level + 1)
	var xp_in_level := xp - current_level_xp
	var xp_needed := next_level_xp - current_level_xp
	
	return xp_in_level / xp_needed if xp_needed > 0 else 0.0

## Load all skill definitions
func _load_skills() -> void:
	# Create Fishing skill
	var fishing := SkillData.new()
	fishing.id = "fishing"
	fishing.name = "Fishing"
	fishing.description = "Catch fish from waters around the world."
	fishing.color = Color(0.2, 0.6, 0.8)
	fishing.training_methods = _create_fishing_methods()
	skills["fishing"] = fishing
	skill_xp["fishing"] = 0.0
	skill_levels["fishing"] = 1
	
	# Create Woodcutting skill
	var woodcutting := SkillData.new()
	woodcutting.id = "woodcutting"
	woodcutting.name = "Woodcutting"
	woodcutting.description = "Chop down trees for logs and other resources."
	woodcutting.color = Color(0.4, 0.25, 0.1)
	woodcutting.training_methods = _create_woodcutting_methods()
	skills["woodcutting"] = woodcutting
	skill_xp["woodcutting"] = 0.0
	skill_levels["woodcutting"] = 1
	
	# Create Cooking skill
	var cooking := SkillData.new()
	cooking.id = "cooking"
	cooking.name = "Cooking"
	cooking.description = "Cook raw food to create edible meals."
	cooking.color = Color(0.8, 0.4, 0.2)
	cooking.training_methods = _create_cooking_methods()
	skills["cooking"] = cooking
	skill_xp["cooking"] = 0.0
	skill_levels["cooking"] = 1
	
	# Create Fletching skill
	var fletching := SkillData.new()
	fletching.id = "fletching"
	fletching.name = "Fletching"
	fletching.description = "Create bows, arrows, and bolts."
	fletching.color = Color(0.5, 0.7, 0.3)
	fletching.training_methods = _create_fletching_methods()
	skills["fletching"] = fletching
	skill_xp["fletching"] = 0.0
	skill_levels["fletching"] = 1
  
	# Create Mining skill
	var mining := SkillData.new()
	mining.id = "mining"
	mining.name = "Mining"
	mining.description = "Extract ores and gems from rocks."
	mining.color = Color(0.6, 0.5, 0.4)
	mining.training_methods = _create_mining_methods()
	skills["mining"] = mining
	skill_xp["mining"] = 0.0
	skill_levels["mining"] = 1
  
	# Create Firemaking skill
	var firemaking := SkillData.new()
	firemaking.id = "firemaking"
	firemaking.name = "Firemaking"
	firemaking.description = "Burn logs for XP and unlock special fires."
	firemaking.color = Color(0.9, 0.4, 0.1)
	firemaking.training_methods = _create_firemaking_methods()
	skills["firemaking"] = firemaking
	skill_xp["firemaking"] = 0.0
	skill_levels["firemaking"] = 1

func _create_fishing_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var shrimp := TrainingMethodData.new()
	shrimp.id = "shrimp"
	shrimp.name = "Shrimp"
	shrimp.description = "Small shrimp found in shallow waters."
	shrimp.level_required = 1
	shrimp.xp_per_action = 10.0
	shrimp.action_time = 3.0
	shrimp.produced_items = {"raw_shrimp": 1}
	methods.append(shrimp)
	
	var sardine := TrainingMethodData.new()
	sardine.id = "sardine"
	sardine.name = "Sardine"
	sardine.description = "A small oily fish."
	sardine.level_required = 5
	sardine.xp_per_action = 20.0
	sardine.action_time = 3.5
	sardine.produced_items = {"raw_sardine": 1}
	methods.append(sardine)
	
	var herring := TrainingMethodData.new()
	herring.id = "herring"
	herring.name = "Herring"
	herring.description = "A silver fish found in open waters."
	herring.level_required = 10
	herring.xp_per_action = 30.0
	herring.action_time = 4.0
	herring.produced_items = {"raw_herring": 1}
	methods.append(herring)
	
	var trout := TrainingMethodData.new()
	trout.id = "trout"
	trout.name = "Trout"
	trout.description = "A freshwater fish caught with a fly fishing rod."
	trout.level_required = 20
	trout.xp_per_action = 50.0
	trout.action_time = 4.5
	trout.produced_items = {"raw_trout": 1}
	methods.append(trout)
	
	var salmon := TrainingMethodData.new()
	salmon.id = "salmon"
	salmon.name = "Salmon"
	salmon.description = "A large pink fish from rivers."
	salmon.level_required = 30
	salmon.xp_per_action = 70.0
	salmon.action_time = 5.0
	salmon.produced_items = {"raw_salmon": 1}
	methods.append(salmon)
	
	var lobster := TrainingMethodData.new()
	lobster.id = "lobster"
	lobster.name = "Lobster"
	lobster.description = "A valuable crustacean."
	lobster.level_required = 40
	lobster.xp_per_action = 90.0
	lobster.action_time = 5.5
	lobster.produced_items = {"raw_lobster": 1}
	methods.append(lobster)
	
	var swordfish := TrainingMethodData.new()
	swordfish.id = "swordfish"
	swordfish.name = "Swordfish"
	swordfish.description = "A large fish with a distinctive bill."
	swordfish.level_required = 50
	swordfish.xp_per_action = 100.0
	swordfish.action_time = 6.0
	swordfish.produced_items = {"raw_swordfish": 1}
	methods.append(swordfish)
	
	var monkfish := TrainingMethodData.new()
	monkfish.id = "monkfish"
	monkfish.name = "Monkfish"
	monkfish.description = "A strange looking but nutritious fish."
	monkfish.level_required = 62
	monkfish.xp_per_action = 120.0
	monkfish.action_time = 5.0
	monkfish.produced_items = {"raw_monkfish": 1}
	methods.append(monkfish)
	
	var shark := TrainingMethodData.new()
	shark.id = "shark"
	shark.name = "Shark"
	shark.description = "A dangerous apex predator of the sea."
	shark.level_required = 76
	shark.xp_per_action = 110.0
	shark.action_time = 6.0
	shark.produced_items = {"raw_shark": 1}
	methods.append(shark)
	
	var anglerfish := TrainingMethodData.new()
	anglerfish.id = "anglerfish"
	anglerfish.name = "Anglerfish"
	anglerfish.description = "A deep sea fish with incredible healing properties."
	anglerfish.level_required = 82
	anglerfish.xp_per_action = 120.0
	anglerfish.action_time = 7.0
	anglerfish.produced_items = {"raw_anglerfish": 1}
	methods.append(anglerfish)
	
	# Additional training methods
	var anchovy := TrainingMethodData.new()
	anchovy.id = "anchovy"
	anchovy.name = "Anchovy"
	anchovy.description = "Tiny fish that swim in large schools."
	anchovy.level_required = 3
	anchovy.xp_per_action = 15.0
	anchovy.action_time = 2.5
	anchovy.produced_items = {"raw_anchovy": 1}
	methods.append(anchovy)
	
	var mackerel := TrainingMethodData.new()
	mackerel.id = "mackerel"
	mackerel.name = "Mackerel"
	mackerel.description = "A fast-swimming fish with striped patterns."
	mackerel.level_required = 8
	mackerel.xp_per_action = 25.0
	mackerel.action_time = 3.2
	mackerel.produced_items = {"raw_mackerel": 1}
	methods.append(mackerel)
	
	var cod := TrainingMethodData.new()
	cod.id = "cod"
	cod.name = "Cod"
	cod.description = "A popular white fish found in cold waters."
	cod.level_required = 13
	cod.xp_per_action = 35.0
	cod.action_time = 4.2
	cod.produced_items = {"raw_cod": 1}
	methods.append(cod)
	
	var pike := TrainingMethodData.new()
	pike.id = "pike"
	pike.name = "Pike"
	pike.description = "An aggressive freshwater predator."
	pike.level_required = 18
	pike.xp_per_action = 45.0
	pike.action_time = 4.8
	pike.produced_items = {"raw_pike": 1}
	methods.append(pike)
	
	var bass := TrainingMethodData.new()
	bass.id = "bass"
	bass.name = "Bass"
	bass.description = "A prized sport fish with firm flesh."
	bass.level_required = 25
	bass.xp_per_action = 60.0
	bass.action_time = 5.2
	bass.produced_items = {"raw_bass": 1}
	methods.append(bass)
	
	var tuna := TrainingMethodData.new()
	tuna.id = "tuna"
	tuna.name = "Tuna"
	tuna.description = "A powerful ocean fish that swims at high speeds."
	tuna.level_required = 35
	tuna.xp_per_action = 80.0
	tuna.action_time = 5.8
	tuna.produced_items = {"raw_tuna": 1}
	methods.append(tuna)
	
	var manta_ray := TrainingMethodData.new()
	manta_ray.id = "manta_ray"
	manta_ray.name = "Manta Ray"
	manta_ray.description = "A graceful giant that glides through the water."
	manta_ray.level_required = 55
	manta_ray.xp_per_action = 115.0
	manta_ray.action_time = 6.5
	manta_ray.produced_items = {"raw_manta_ray": 1}
	methods.append(manta_ray)
	
	var sea_turtle := TrainingMethodData.new()
	sea_turtle.id = "sea_turtle"
	sea_turtle.name = "Sea Turtle"
	sea_turtle.description = "An ancient marine reptile with valuable shells."
	sea_turtle.level_required = 68
	sea_turtle.xp_per_action = 135.0
	sea_turtle.action_time = 7.5
	sea_turtle.produced_items = {"raw_sea_turtle": 1}
	methods.append(sea_turtle)
	
	var sailfish := TrainingMethodData.new()
	sailfish.id = "sailfish"
	sailfish.name = "Sailfish"
	sailfish.description = "The fastest fish in the ocean with a spectacular dorsal fin."
	sailfish.level_required = 85
	sailfish.xp_per_action = 165.0
	sailfish.action_time = 8.0
	sailfish.produced_items = {"raw_sailfish": 1}
	methods.append(sailfish)
	
	var kraken_tentacle := TrainingMethodData.new()
	kraken_tentacle.id = "kraken_tentacle"
	kraken_tentacle.name = "Kraken Tentacle"
	kraken_tentacle.description = "A rare and dangerous catch from the depths."
	kraken_tentacle.level_required = 92
	kraken_tentacle.xp_per_action = 200.0
	kraken_tentacle.action_time = 9.0
	kraken_tentacle.produced_items = {"kraken_tentacle": 1}
	methods.append(kraken_tentacle)
	
	return methods

func _create_woodcutting_methods() -> Array[TrainingMethodData]:
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

func _create_cooking_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var cook_shrimp := TrainingMethodData.new()
	cook_shrimp.id = "cook_shrimp"
	cook_shrimp.name = "Cook Shrimp"
	cook_shrimp.description = "Cook raw shrimp into a tasty snack."
	cook_shrimp.level_required = 1
	cook_shrimp.xp_per_action = 30.0
	cook_shrimp.action_time = 2.0
	cook_shrimp.consumed_items = {"raw_shrimp": 1}
	cook_shrimp.produced_items = {"cooked_shrimp": 1}
	cook_shrimp.success_rate = 0.7
	methods.append(cook_shrimp)
	
	var cook_sardine := TrainingMethodData.new()
	cook_sardine.id = "cook_sardine"
	cook_sardine.name = "Cook Sardine"
	cook_sardine.description = "Cook raw sardine."
	cook_sardine.level_required = 5
	cook_sardine.xp_per_action = 40.0
	cook_sardine.action_time = 2.0
	cook_sardine.consumed_items = {"raw_sardine": 1}
	cook_sardine.produced_items = {"cooked_sardine": 1}
	cook_sardine.success_rate = 0.7
	methods.append(cook_sardine)
	
	var cook_herring := TrainingMethodData.new()
	cook_herring.id = "cook_herring"
	cook_herring.name = "Cook Herring"
	cook_herring.description = "Cook raw herring."
	cook_herring.level_required = 10
	cook_herring.xp_per_action = 50.0
	cook_herring.action_time = 2.0
	cook_herring.consumed_items = {"raw_herring": 1}
	cook_herring.produced_items = {"cooked_herring": 1}
	cook_herring.success_rate = 0.75
	methods.append(cook_herring)
	
	var cook_trout := TrainingMethodData.new()
	cook_trout.id = "cook_trout"
	cook_trout.name = "Cook Trout"
	cook_trout.description = "Cook raw trout."
	cook_trout.level_required = 20
	cook_trout.xp_per_action = 70.0
	cook_trout.action_time = 2.5
	cook_trout.consumed_items = {"raw_trout": 1}
	cook_trout.produced_items = {"cooked_trout": 1}
	cook_trout.success_rate = 0.8
	methods.append(cook_trout)
	
	var cook_salmon := TrainingMethodData.new()
	cook_salmon.id = "cook_salmon"
	cook_salmon.name = "Cook Salmon"
	cook_salmon.description = "Cook raw salmon."
	cook_salmon.level_required = 30
	cook_salmon.xp_per_action = 90.0
	cook_salmon.action_time = 2.5
	cook_salmon.consumed_items = {"raw_salmon": 1}
	cook_salmon.produced_items = {"cooked_salmon": 1}
	cook_salmon.success_rate = 0.85
	methods.append(cook_salmon)
	
	var cook_lobster := TrainingMethodData.new()
	cook_lobster.id = "cook_lobster"
	cook_lobster.name = "Cook Lobster"
	cook_lobster.description = "Cook raw lobster."
	cook_lobster.level_required = 40
	cook_lobster.xp_per_action = 120.0
	cook_lobster.action_time = 3.0
	cook_lobster.consumed_items = {"raw_lobster": 1}
	cook_lobster.produced_items = {"cooked_lobster": 1}
	cook_lobster.success_rate = 0.85
	methods.append(cook_lobster)
	
	var cook_swordfish := TrainingMethodData.new()
	cook_swordfish.id = "cook_swordfish"
	cook_swordfish.name = "Cook Swordfish"
	cook_swordfish.description = "Cook raw swordfish."
	cook_swordfish.level_required = 50
	cook_swordfish.xp_per_action = 140.0
	cook_swordfish.action_time = 3.0
	cook_swordfish.consumed_items = {"raw_swordfish": 1}
	cook_swordfish.produced_items = {"cooked_swordfish": 1}
	cook_swordfish.success_rate = 0.9
	methods.append(cook_swordfish)
	
	var cook_monkfish := TrainingMethodData.new()
	cook_monkfish.id = "cook_monkfish"
	cook_monkfish.name = "Cook Monkfish"
	cook_monkfish.description = "Cook raw monkfish."
	cook_monkfish.level_required = 62
	cook_monkfish.xp_per_action = 150.0
	cook_monkfish.action_time = 3.0
	cook_monkfish.consumed_items = {"raw_monkfish": 1}
	cook_monkfish.produced_items = {"cooked_monkfish": 1}
	cook_monkfish.success_rate = 0.9
	methods.append(cook_monkfish)
	
	var cook_shark := TrainingMethodData.new()
	cook_shark.id = "cook_shark"
	cook_shark.name = "Cook Shark"
	cook_shark.description = "Cook raw shark."
	cook_shark.level_required = 76
	cook_shark.xp_per_action = 210.0
	cook_shark.action_time = 3.5
	cook_shark.consumed_items = {"raw_shark": 1}
	cook_shark.produced_items = {"cooked_shark": 1}
	cook_shark.success_rate = 0.92
	methods.append(cook_shark)
	
	var cook_anglerfish := TrainingMethodData.new()
	cook_anglerfish.id = "cook_anglerfish"
	cook_anglerfish.name = "Cook Anglerfish"
	cook_anglerfish.description = "Cook raw anglerfish."
	cook_anglerfish.level_required = 82
	cook_anglerfish.xp_per_action = 230.0
	cook_anglerfish.action_time = 3.5
	cook_anglerfish.consumed_items = {"raw_anglerfish": 1}
	cook_anglerfish.produced_items = {"cooked_anglerfish": 1}
	cook_anglerfish.success_rate = 0.95
	methods.append(cook_anglerfish)
	
	# Additional cooking methods
	var cook_anchovy := TrainingMethodData.new()
	cook_anchovy.id = "cook_anchovy"
	cook_anchovy.name = "Cook Anchovy"
	cook_anchovy.description = "Cook tiny anchovies into a salty treat."
	cook_anchovy.level_required = 3
	cook_anchovy.xp_per_action = 35.0
	cook_anchovy.action_time = 1.8
	cook_anchovy.consumed_items = {"raw_anchovy": 1}
	cook_anchovy.produced_items = {"cooked_anchovy": 1}
	cook_anchovy.success_rate = 0.65
	methods.append(cook_anchovy)
	
	var cook_mackerel := TrainingMethodData.new()
	cook_mackerel.id = "cook_mackerel"
	cook_mackerel.name = "Cook Mackerel"
	cook_mackerel.description = "Cook mackerel into a flavorful meal."
	cook_mackerel.level_required = 8
	cook_mackerel.xp_per_action = 45.0
	cook_mackerel.action_time = 2.0
	cook_mackerel.consumed_items = {"raw_mackerel": 1}
	cook_mackerel.produced_items = {"cooked_mackerel": 1}
	cook_mackerel.success_rate = 0.72
	methods.append(cook_mackerel)
	
	var cook_cod := TrainingMethodData.new()
	cook_cod.id = "cook_cod"
	cook_cod.name = "Cook Cod"
	cook_cod.description = "Cook cod into a delicious white fish dish."
	cook_cod.level_required = 13
	cook_cod.xp_per_action = 60.0
	cook_cod.action_time = 2.2
	cook_cod.consumed_items = {"raw_cod": 1}
	cook_cod.produced_items = {"cooked_cod": 1}
	cook_cod.success_rate = 0.78
	methods.append(cook_cod)
	
	var cook_pike := TrainingMethodData.new()
	cook_pike.id = "cook_pike"
	cook_pike.name = "Cook Pike"
	cook_pike.description = "Cook pike into a hearty meal."
	cook_pike.level_required = 18
	cook_pike.xp_per_action = 75.0
	cook_pike.action_time = 2.5
	cook_pike.consumed_items = {"raw_pike": 1}
	cook_pike.produced_items = {"cooked_pike": 1}
	cook_pike.success_rate = 0.82
	methods.append(cook_pike)
	
	var cook_bass := TrainingMethodData.new()
	cook_bass.id = "cook_bass"
	cook_bass.name = "Cook Bass"
	cook_bass.description = "Cook bass into a premium fish dish."
	cook_bass.level_required = 25
	cook_bass.xp_per_action = 95.0
	cook_bass.action_time = 2.8
	cook_bass.consumed_items = {"raw_bass": 1}
	cook_bass.produced_items = {"cooked_bass": 1}
	cook_bass.success_rate = 0.84
	methods.append(cook_bass)
	
	var cook_tuna := TrainingMethodData.new()
	cook_tuna.id = "cook_tuna"
	cook_tuna.name = "Cook Tuna"
	cook_tuna.description = "Cook tuna into a protein-rich meal."
	cook_tuna.level_required = 35
	cook_tuna.xp_per_action = 110.0
	cook_tuna.action_time = 3.0
	cook_tuna.consumed_items = {"raw_tuna": 1}
	cook_tuna.produced_items = {"cooked_tuna": 1}
	cook_tuna.success_rate = 0.86
	methods.append(cook_tuna)
	
	var cook_manta_ray := TrainingMethodData.new()
	cook_manta_ray.id = "cook_manta_ray"
	cook_manta_ray.name = "Cook Manta Ray"
	cook_manta_ray.description = "Cook manta ray into an exotic delicacy."
	cook_manta_ray.level_required = 55
	cook_manta_ray.xp_per_action = 160.0
	cook_manta_ray.action_time = 3.2
	cook_manta_ray.consumed_items = {"raw_manta_ray": 1}
	cook_manta_ray.produced_items = {"cooked_manta_ray": 1}
	cook_manta_ray.success_rate = 0.88
	methods.append(cook_manta_ray)
	
	var cook_sea_turtle := TrainingMethodData.new()
	cook_sea_turtle.id = "cook_sea_turtle"
	cook_sea_turtle.name = "Cook Sea Turtle"
	cook_sea_turtle.description = "Cook sea turtle into a rare delicacy."
	cook_sea_turtle.level_required = 68
	cook_sea_turtle.xp_per_action = 180.0
	cook_sea_turtle.action_time = 3.5
	cook_sea_turtle.consumed_items = {"raw_sea_turtle": 1}
	cook_sea_turtle.produced_items = {"cooked_sea_turtle": 1}
	cook_sea_turtle.success_rate = 0.90
	methods.append(cook_sea_turtle)
	
	var cook_sailfish := TrainingMethodData.new()
	cook_sailfish.id = "cook_sailfish"
	cook_sailfish.name = "Cook Sailfish"
	cook_sailfish.description = "Cook sailfish into a premium oceanic feast."
	cook_sailfish.level_required = 85
	cook_sailfish.xp_per_action = 250.0
	cook_sailfish.action_time = 4.0
	cook_sailfish.consumed_items = {"raw_sailfish": 1}
	cook_sailfish.produced_items = {"cooked_sailfish": 1}
	cook_sailfish.success_rate = 0.93
	methods.append(cook_sailfish)
	
	var cook_kraken_tentacle := TrainingMethodData.new()
	cook_kraken_tentacle.id = "cook_kraken_tentacle"
	cook_kraken_tentacle.name = "Cook Kraken Tentacle"
	cook_kraken_tentacle.description = "Cook a legendary kraken tentacle into an ultimate feast."
	cook_kraken_tentacle.level_required = 92
	cook_kraken_tentacle.xp_per_action = 300.0
	cook_kraken_tentacle.action_time = 5.0
	cook_kraken_tentacle.consumed_items = {"kraken_tentacle": 1}
	cook_kraken_tentacle.produced_items = {"cooked_kraken_tentacle": 1}
	cook_kraken_tentacle.success_rate = 0.96
	methods.append(cook_kraken_tentacle)
	
	return methods

func _create_fletching_methods() -> Array[TrainingMethodData]:
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
  
func _create_mining_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var copper := TrainingMethodData.new()
	copper.id = "copper_ore"
	copper.name = "Copper Ore"
	copper.description = "Mine copper from rocks."
	copper.level_required = 1
	copper.xp_per_action = 17.5
	copper.action_time = 2.5
	copper.produced_items = {"copper_ore": 1}
	methods.append(copper)
	
	var tin := TrainingMethodData.new()
	tin.id = "tin_ore"
	tin.name = "Tin Ore"
	tin.description = "Mine tin from rocks."
	tin.level_required = 1
	tin.xp_per_action = 17.5
	tin.action_time = 2.5
	tin.produced_items = {"tin_ore": 1}
	methods.append(tin)
	
	var iron := TrainingMethodData.new()
	iron.id = "iron_ore"
	iron.name = "Iron Ore"
	iron.description = "Mine iron from rocks."
	iron.level_required = 15
	iron.xp_per_action = 35.0
	iron.action_time = 3.0
	iron.produced_items = {"iron_ore": 1}
	methods.append(iron)
	
	var silver := TrainingMethodData.new()
	silver.id = "silver_ore"
	silver.name = "Silver Ore"
	silver.description = "Mine silver from rocks."
	silver.level_required = 20
	silver.xp_per_action = 40.0
	silver.action_time = 4.0
	silver.produced_items = {"silver_ore": 1}
	methods.append(silver)
	
	var coal_ore := TrainingMethodData.new()
	coal_ore.id = "coal"
	coal_ore.name = "Coal"
	coal_ore.description = "Mine coal for smelting."
	coal_ore.level_required = 30
	coal_ore.xp_per_action = 50.0
	coal_ore.action_time = 3.5
	coal_ore.produced_items = {"coal": 1}
	methods.append(coal_ore)
	
	var gold := TrainingMethodData.new()
	gold.id = "gold_ore"
	gold.name = "Gold Ore"
	gold.description = "Mine gold from rocks."
	gold.level_required = 40
	gold.xp_per_action = 65.0
	gold.action_time = 4.0
	gold.produced_items = {"gold_ore": 1}
	methods.append(gold)
	
	var mithril := TrainingMethodData.new()
	mithril.id = "mithril_ore"
	mithril.name = "Mithril Ore"
	mithril.description = "Mine mithril from rocks."
	mithril.level_required = 55
	mithril.xp_per_action = 80.0
	mithril.action_time = 5.0
	mithril.produced_items = {"mithril_ore": 1}
	methods.append(mithril)
	
	var adamantite := TrainingMethodData.new()
	adamantite.id = "adamantite_ore"
	adamantite.name = "Adamantite Ore"
	adamantite.description = "Mine adamantite from rocks."
	adamantite.level_required = 70
	adamantite.xp_per_action = 95.0
	adamantite.action_time = 6.0
	adamantite.produced_items = {"adamantite_ore": 1}
	methods.append(adamantite)
	
	var runite := TrainingMethodData.new()
	runite.id = "runite_ore"
	runite.name = "Runite Ore"
	runite.description = "Mine runite from rocks."
	runite.level_required = 85
	runite.xp_per_action = 125.0
	runite.action_time = 8.0
	runite.produced_items = {"runite_ore": 1}
	methods.append(runite)
  
func _create_firemaking_methods() -> Array[TrainingMethodData]:
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

## Get current skill level
func get_skill_level(skill_id: String) -> int:
	return skill_levels.get(skill_id, 1)

## Get current skill XP
func get_skill_xp(skill_id: String) -> float:
	return skill_xp.get(skill_id, 0.0)

## Add XP to a skill
func add_xp(skill_id: String, xp: float) -> void:
	if not skills.has(skill_id):
		return
	
	var old_level := get_skill_level(skill_id)
	skill_xp[skill_id] = skill_xp.get(skill_id, 0.0) + xp
	var new_level := get_level_from_xp(skill_xp[skill_id])
	skill_levels[skill_id] = new_level
	
	skill_xp_gained.emit(skill_id, xp)
	
	if new_level > old_level:
		skill_level_up.emit(skill_id, new_level)

## Start training a skill with a specific method
func start_training(skill_id: String, method_id: String) -> bool:
	if not skills.has(skill_id):
		return false
	
	var skill: SkillData = skills[skill_id]
	var method: TrainingMethodData = null
	
	for m in skill.training_methods:
		if m.id == method_id:
			method = m
			break
	
	if method == null:
		return false
	
	# Check if player has required level
	if get_skill_level(skill_id) < method.level_required:
		return false
	
	current_skill_id = skill_id
	current_method_id = method_id
	training_progress = 0.0
	is_training = true
	
	training_started.emit(skill_id, method_id)
	return true

## Stop training
func stop_training() -> void:
	if is_training:
		var old_skill := current_skill_id
		current_skill_id = ""
		current_method_id = ""
		training_progress = 0.0
		is_training = false
		training_stopped.emit(old_skill)

## Get current training method
func get_current_training_method() -> TrainingMethodData:
	if not is_training or current_skill_id.is_empty():
		return null
	
	var skill: SkillData = skills.get(current_skill_id)
	if skill == null:
		return null
	
	for method in skill.training_methods:
		if method.id == current_method_id:
			return method
	
	return null

## Process training tick
func _process(delta: float) -> void:
	if not is_training:
		return
	
	var method := get_current_training_method()
	if method == null:
		stop_training()
		return
	
	# Check if we have required items for consumption
	if not method.consumed_items.is_empty():
		for item_id in method.consumed_items:
			var required: int = method.consumed_items[item_id]
			if Inventory.get_item_count(item_id) < required:
				stop_training()
				return
	
	training_progress += delta
	
	if training_progress >= method.action_time:
		training_progress -= method.action_time
		_complete_action(method)

## Complete a training action
func _complete_action(method: TrainingMethodData) -> void:
	var success := randf() <= method.success_rate
	
	# Consume items
	if not method.consumed_items.is_empty():
		for item_id in method.consumed_items:
			var amount: int = method.consumed_items[item_id]
			if not Inventory.remove_item(item_id, amount):
				stop_training()
				return
	
	# Always give XP
	add_xp(current_skill_id, method.xp_per_action)
	
	# Produce items on success
	if success and not method.produced_items.is_empty():
		for item_id in method.produced_items:
			var amount: int = method.produced_items[item_id]
			Inventory.add_item(item_id, amount)
	
	action_completed.emit(current_skill_id, method.id, success)

## Get total XP across all skills
func get_total_xp() -> float:
	var total := 0.0
	for skill_id in skill_xp:
		total += skill_xp[skill_id]
	return total

## Get total level across all skills
func get_total_level() -> int:
	var total := 0
	for skill_id in skill_levels:
		total += skill_levels[skill_id]
	return total
