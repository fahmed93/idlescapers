## Skinning Skill
## Contains training methods for the Skinning skill
extends Node

## Create and return all skinning training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var rabbit := TrainingMethodData.new()
	rabbit.id = "rabbit"
	rabbit.name = "Rabbit"
	rabbit.description = "Small furry creatures with soft hide."
	rabbit.level_required = 1
	rabbit.xp_per_action = 10.0
	rabbit.action_time = 3.0
	rabbit.produced_items = {"rabbit_hide": 1}
	methods.append(rabbit)
	
	var chicken := TrainingMethodData.new()
	chicken.id = "chicken"
	chicken.name = "Chicken"
	chicken.description = "Common birds that provide hide."
	chicken.level_required = 3
	chicken.xp_per_action = 15.0
	chicken.action_time = 2.5
	chicken.produced_items = {"chicken_hide": 1}
	methods.append(chicken)
	
	var cow := TrainingMethodData.new()
	cow.id = "cow"
	cow.name = "Cow"
	cow.description = "Large livestock providing tough cowhide."
	cow.level_required = 5
	cow.xp_per_action = 20.0
	cow.action_time = 3.5
	cow.produced_items = {"cowhide": 1}
	methods.append(cow)
	
	var bear := TrainingMethodData.new()
	bear.id = "bear"
	bear.name = "Bear"
	bear.description = "Fierce predators with thick warm fur."
	bear.level_required = 10
	bear.xp_per_action = 30.0
	bear.action_time = 4.0
	bear.produced_items = {"bear_hide": 1}
	methods.append(bear)
	
	var wolf := TrainingMethodData.new()
	wolf.id = "wolf"
	wolf.name = "Wolf"
	wolf.description = "Wild canines with durable pelts."
	wolf.level_required = 15
	wolf.xp_per_action = 40.0
	wolf.action_time = 4.2
	wolf.produced_items = {"wolf_hide": 1}
	methods.append(wolf)
	
	var snake := TrainingMethodData.new()
	snake.id = "snake"
	snake.name = "Snake"
	snake.description = "Serpents with valuable scaled skin."
	snake.level_required = 20
	snake.xp_per_action = 50.0
	snake.action_time = 4.5
	snake.produced_items = {"snake_skin": 1}
	methods.append(snake)
	
	var crocodile := TrainingMethodData.new()
	crocodile.id = "crocodile"
	crocodile.name = "Crocodile"
	crocodile.description = "Large reptiles with tough scaled hide."
	crocodile.level_required = 25
	crocodile.xp_per_action = 60.0
	crocodile.action_time = 5.0
	crocodile.produced_items = {"crocodile_hide": 1}
	methods.append(crocodile)
	
	var yak := TrainingMethodData.new()
	yak.id = "yak"
	yak.name = "Yak"
	yak.description = "Mountain beasts with thick wooly hide."
	yak.level_required = 30
	yak.xp_per_action = 70.0
	yak.action_time = 5.2
	yak.produced_items = {"yak_hide": 1}
	methods.append(yak)
	
	var polar_bear := TrainingMethodData.new()
	polar_bear.id = "polar_bear"
	polar_bear.name = "Polar Bear"
	polar_bear.description = "Arctic predators with pristine white fur."
	polar_bear.level_required = 35
	polar_bear.xp_per_action = 80.0
	polar_bear.action_time = 5.5
	polar_bear.produced_items = {"polar_bear_hide": 1}
	methods.append(polar_bear)
	
	var lion := TrainingMethodData.new()
	lion.id = "lion"
	lion.name = "Lion"
	lion.description = "Majestic predators with golden pelts."
	lion.level_required = 40
	lion.xp_per_action = 90.0
	lion.action_time = 5.8
	lion.produced_items = {"lion_hide": 1}
	methods.append(lion)
	
	var tiger := TrainingMethodData.new()
	tiger.id = "tiger"
	tiger.name = "Tiger"
	tiger.description = "Striped hunters with exotic fur."
	tiger.level_required = 45
	tiger.xp_per_action = 100.0
	tiger.action_time = 6.0
	tiger.produced_items = {"tiger_hide": 1}
	methods.append(tiger)
	
	var black_bear := TrainingMethodData.new()
	black_bear.id = "black_bear"
	black_bear.name = "Black Bear"
	black_bear.description = "Forest dwellers with sleek dark fur."
	black_bear.level_required = 50
	black_bear.xp_per_action = 110.0
	black_bear.action_time = 6.2
	black_bear.produced_items = {"black_bear_hide": 1}
	methods.append(black_bear)
	
	var blue_dragon := TrainingMethodData.new()
	blue_dragon.id = "blue_dragon"
	blue_dragon.name = "Blue Dragon"
	blue_dragon.description = "Mystical dragons with azure scales."
	blue_dragon.level_required = 55
	blue_dragon.xp_per_action = 120.0
	blue_dragon.action_time = 6.5
	blue_dragon.produced_items = {"blue_dragonhide": 1}
	methods.append(blue_dragon)
	
	var red_dragon := TrainingMethodData.new()
	red_dragon.id = "red_dragon"
	red_dragon.name = "Red Dragon"
	red_dragon.description = "Fearsome dragons with crimson scales."
	red_dragon.level_required = 60
	red_dragon.xp_per_action = 130.0
	red_dragon.action_time = 7.0
	red_dragon.produced_items = {"red_dragonhide": 1}
	methods.append(red_dragon)
	
	var black_dragon := TrainingMethodData.new()
	black_dragon.id = "black_dragon"
	black_dragon.name = "Black Dragon"
	black_dragon.description = "Ancient dragons with obsidian scales."
	black_dragon.level_required = 65
	black_dragon.xp_per_action = 140.0
	black_dragon.action_time = 7.2
	black_dragon.produced_items = {"black_dragonhide": 1}
	methods.append(black_dragon)
	
	var green_dragon := TrainingMethodData.new()
	green_dragon.id = "green_dragon"
	green_dragon.name = "Green Dragon"
	green_dragon.description = "Emerald dragons with venomous scales."
	green_dragon.level_required = 70
	green_dragon.xp_per_action = 150.0
	green_dragon.action_time = 7.5
	green_dragon.produced_items = {"green_dragonhide": 1}
	methods.append(green_dragon)
	
	var frost_dragon := TrainingMethodData.new()
	frost_dragon.id = "frost_dragon"
	frost_dragon.name = "Frost Dragon"
	frost_dragon.description = "Ice dragons with crystalline scales."
	frost_dragon.level_required = 75
	frost_dragon.xp_per_action = 165.0
	frost_dragon.action_time = 8.0
	frost_dragon.produced_items = {"frost_dragonhide": 1}
	methods.append(frost_dragon)
	
	var royal_dragon := TrainingMethodData.new()
	royal_dragon.id = "royal_dragon"
	royal_dragon.name = "Royal Dragon"
	royal_dragon.description = "Legendary dragons with platinum scales."
	royal_dragon.level_required = 80
	royal_dragon.xp_per_action = 180.0
	royal_dragon.action_time = 8.5
	royal_dragon.produced_items = {"royal_dragonhide": 1}
	methods.append(royal_dragon)
	
	var chimera := TrainingMethodData.new()
	chimera.id = "chimera"
	chimera.name = "Chimera"
	chimera.description = "Mythical beasts with multi-textured hides."
	chimera.level_required = 85
	chimera.xp_per_action = 200.0
	chimera.action_time = 9.0
	chimera.produced_items = {"chimera_hide": 1}
	methods.append(chimera)
	
	var phoenix := TrainingMethodData.new()
	phoenix.id = "phoenix"
	phoenix.name = "Phoenix"
	phoenix.description = "Immortal birds with radiant feathers."
	phoenix.level_required = 90
	phoenix.xp_per_action = 225.0
	phoenix.action_time = 9.5
	phoenix.produced_items = {"phoenix_feather": 1}
	methods.append(phoenix)
	
	return methods
