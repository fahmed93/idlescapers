## Fishing Skill
## Contains training methods for the Fishing skill
extends Node

## Create and return all fishing training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	# Level 1
	var shrimp := TrainingMethodData.new()
	shrimp.id = "shrimp"
	shrimp.name = "Shrimp"
	shrimp.description = "Small shrimp found in shallow waters."
	shrimp.level_required = 1
	shrimp.xp_per_action = 10.0
	shrimp.action_time = 3.0
	shrimp.produced_items = {"raw_shrimp": 1}
	methods.append(shrimp)
	
	# Level 3
	var anchovy := TrainingMethodData.new()
	anchovy.id = "anchovy"
	anchovy.name = "Anchovy"
	anchovy.description = "Tiny fish that swim in large schools."
	anchovy.level_required = 3
	anchovy.xp_per_action = 15.0
	anchovy.action_time = 2.5
	anchovy.produced_items = {"raw_anchovy": 1}
	methods.append(anchovy)
	
	# Level 5
	var sardine := TrainingMethodData.new()
	sardine.id = "sardine"
	sardine.name = "Sardine"
	sardine.description = "A small oily fish."
	sardine.level_required = 5
	sardine.xp_per_action = 20.0
	sardine.action_time = 3.5
	sardine.produced_items = {"raw_sardine": 1}
	methods.append(sardine)
	
	# Level 8
	var mackerel := TrainingMethodData.new()
	mackerel.id = "mackerel"
	mackerel.name = "Mackerel"
	mackerel.description = "A fast-swimming fish with striped patterns."
	mackerel.level_required = 8
	mackerel.xp_per_action = 25.0
	mackerel.action_time = 3.2
	mackerel.produced_items = {"raw_mackerel": 1}
	methods.append(mackerel)
	
	# Level 10
	var herring := TrainingMethodData.new()
	herring.id = "herring"
	herring.name = "Herring"
	herring.description = "A silver fish found in open waters."
	herring.level_required = 10
	herring.xp_per_action = 30.0
	herring.action_time = 4.0
	herring.produced_items = {"raw_herring": 1}
	methods.append(herring)
	
	# Level 13
	var cod := TrainingMethodData.new()
	cod.id = "cod"
	cod.name = "Cod"
	cod.description = "A popular white fish found in cold waters."
	cod.level_required = 13
	cod.xp_per_action = 35.0
	cod.action_time = 4.2
	cod.produced_items = {"raw_cod": 1}
	methods.append(cod)
	
	# Level 18
	var pike := TrainingMethodData.new()
	pike.id = "pike"
	pike.name = "Pike"
	pike.description = "An aggressive freshwater predator."
	pike.level_required = 18
	pike.xp_per_action = 45.0
	pike.action_time = 4.8
	pike.produced_items = {"raw_pike": 1}
	methods.append(pike)
	
	# Level 20
	var trout := TrainingMethodData.new()
	trout.id = "trout"
	trout.name = "Trout"
	trout.description = "A freshwater fish caught with a fly fishing rod."
	trout.level_required = 20
	trout.xp_per_action = 50.0
	trout.action_time = 4.5
	trout.produced_items = {"raw_trout": 1}
	methods.append(trout)
	
	# Level 25
	var bass := TrainingMethodData.new()
	bass.id = "bass"
	bass.name = "Bass"
	bass.description = "A prized sport fish with firm flesh."
	bass.level_required = 25
	bass.xp_per_action = 60.0
	bass.action_time = 5.2
	bass.produced_items = {"raw_bass": 1}
	methods.append(bass)
	
	# Level 30
	var salmon := TrainingMethodData.new()
	salmon.id = "salmon"
	salmon.name = "Salmon"
	salmon.description = "A large pink fish from rivers."
	salmon.level_required = 30
	salmon.xp_per_action = 70.0
	salmon.action_time = 5.0
	salmon.produced_items = {"raw_salmon": 1}
	methods.append(salmon)
	
	# Level 35
	var tuna := TrainingMethodData.new()
	tuna.id = "tuna"
	tuna.name = "Tuna"
	tuna.description = "A powerful ocean fish that swims at high speeds."
	tuna.level_required = 35
	tuna.xp_per_action = 80.0
	tuna.action_time = 5.8
	tuna.produced_items = {"raw_tuna": 1}
	methods.append(tuna)
	
	# Level 40
	var lobster := TrainingMethodData.new()
	lobster.id = "lobster"
	lobster.name = "Lobster"
	lobster.description = "A valuable crustacean."
	lobster.level_required = 40
	lobster.xp_per_action = 90.0
	lobster.action_time = 5.5
	lobster.produced_items = {"raw_lobster": 1}
	methods.append(lobster)
	
	# Level 50
	var swordfish := TrainingMethodData.new()
	swordfish.id = "swordfish"
	swordfish.name = "Swordfish"
	swordfish.description = "A large fish with a distinctive bill."
	swordfish.level_required = 50
	swordfish.xp_per_action = 100.0
	swordfish.action_time = 6.0
	swordfish.produced_items = {"raw_swordfish": 1}
	methods.append(swordfish)
	
	# Level 55
	var manta_ray := TrainingMethodData.new()
	manta_ray.id = "manta_ray"
	manta_ray.name = "Manta Ray"
	manta_ray.description = "A graceful giant that glides through the water."
	manta_ray.level_required = 55
	manta_ray.xp_per_action = 115.0
	manta_ray.action_time = 6.5
	manta_ray.produced_items = {"raw_manta_ray": 1}
	methods.append(manta_ray)
	
	# Level 62
	var monkfish := TrainingMethodData.new()
	monkfish.id = "monkfish"
	monkfish.name = "Monkfish"
	monkfish.description = "A strange looking but nutritious fish."
	monkfish.level_required = 62
	monkfish.xp_per_action = 120.0
	monkfish.action_time = 5.0
	monkfish.produced_items = {"raw_monkfish": 1}
	methods.append(monkfish)
	
	# Level 68
	var sea_turtle := TrainingMethodData.new()
	sea_turtle.id = "sea_turtle"
	sea_turtle.name = "Sea Turtle"
	sea_turtle.description = "An ancient marine reptile with valuable shells."
	sea_turtle.level_required = 68
	sea_turtle.xp_per_action = 135.0
	sea_turtle.action_time = 7.5
	sea_turtle.produced_items = {"raw_sea_turtle": 1}
	methods.append(sea_turtle)
	
	# Level 76
	var shark := TrainingMethodData.new()
	shark.id = "shark"
	shark.name = "Shark"
	shark.description = "A dangerous apex predator of the sea."
	shark.level_required = 76
	shark.xp_per_action = 110.0
	shark.action_time = 6.0
	shark.produced_items = {"raw_shark": 1}
	methods.append(shark)
	
	# Level 82
	var anglerfish := TrainingMethodData.new()
	anglerfish.id = "anglerfish"
	anglerfish.name = "Anglerfish"
	anglerfish.description = "A deep sea fish with incredible healing properties."
	anglerfish.level_required = 82
	anglerfish.xp_per_action = 120.0
	anglerfish.action_time = 7.0
	anglerfish.produced_items = {"raw_anglerfish": 1}
	methods.append(anglerfish)
	
	# Level 85
	var sailfish := TrainingMethodData.new()
	sailfish.id = "sailfish"
	sailfish.name = "Sailfish"
	sailfish.description = "The fastest fish in the ocean with a spectacular dorsal fin."
	sailfish.level_required = 85
	sailfish.xp_per_action = 165.0
	sailfish.action_time = 8.0
	sailfish.produced_items = {"raw_sailfish": 1}
	methods.append(sailfish)
	
	# Level 92
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
