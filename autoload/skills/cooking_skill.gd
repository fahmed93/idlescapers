## Cooking Skill
## Contains training methods for the Cooking skill
extends Node

## Create and return all cooking training methods
static func create_methods() -> Array[TrainingMethodData]:
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
