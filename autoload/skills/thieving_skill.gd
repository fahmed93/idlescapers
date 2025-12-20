## Thieving Skill
## Contains training methods for the Thieving skill
extends Node

## Create and return all thieving training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	var man_woman := TrainingMethodData.new()
	man_woman.id = "man_woman"
	man_woman.name = "Man/Woman"
	man_woman.description = "Pickpocket common citizens for coins."
	man_woman.level_required = 1
	man_woman.xp_per_action = 8.0
	man_woman.action_time = 2.0
	man_woman.produced_items = {"coins": 3}
	man_woman.success_rate = 0.70
	methods.append(man_woman)
	
	var farmer := TrainingMethodData.new()
	farmer.id = "farmer"
	farmer.name = "Farmer"
	farmer.description = "Pickpocket farmers for coins."
	farmer.level_required = 5
	farmer.xp_per_action = 14.5
	farmer.action_time = 2.5
	farmer.produced_items = {"coins": 8}
	farmer.success_rate = 0.65
	methods.append(farmer)
	
	var market_trader := TrainingMethodData.new()
	market_trader.id = "market_trader"
	market_trader.name = "Market Trader"
	market_trader.description = "Pickpocket market traders for moderate coin."
	market_trader.level_required = 10
	market_trader.xp_per_action = 18.0
	market_trader.action_time = 2.8
	market_trader.produced_items = {"coins": 12}
	market_trader.success_rate = 0.62
	methods.append(market_trader)
	
	var bandit := TrainingMethodData.new()
	bandit.id = "bandit"
	bandit.name = "Bandit"
	bandit.description = "Pickpocket bandits for stolen goods."
	bandit.level_required = 15
	bandit.xp_per_action = 22.0
	bandit.action_time = 3.0
	bandit.produced_items = {"coins": 15}
	bandit.success_rate = 0.60
	methods.append(bandit)
	
	var warrior := TrainingMethodData.new()
	warrior.id = "warrior"
	warrior.name = "Warrior"
	warrior.description = "Pickpocket warriors for better loot."
	warrior.level_required = 25
	warrior.xp_per_action = 26.0
	warrior.action_time = 3.0
	warrior.produced_items = {"coins": 18}
	warrior.success_rate = 0.60
	methods.append(warrior)
	
	var guard := TrainingMethodData.new()
	guard.id = "guard"
	guard.name = "Guard"
	guard.description = "Pickpocket guards for valuable coins."
	guard.level_required = 40
	guard.xp_per_action = 46.8
	guard.action_time = 3.5
	guard.produced_items = {"coins": 30}
	guard.success_rate = 0.55
	methods.append(guard)
	
	var knight := TrainingMethodData.new()
	knight.id = "knight"
	knight.name = "Knight"
	knight.description = "Pickpocket knights for substantial rewards."
	knight.level_required = 55
	knight.xp_per_action = 84.3
	knight.action_time = 4.0
	knight.produced_items = {"coins": 50}
	knight.success_rate = 0.50
	methods.append(knight)
	
	var paladin := TrainingMethodData.new()
	paladin.id = "paladin"
	paladin.name = "Paladin"
	paladin.description = "Pickpocket paladins for great wealth."
	paladin.level_required = 70
	paladin.xp_per_action = 151.7
	paladin.action_time = 4.5
	paladin.produced_items = {"coins": 80}
	paladin.success_rate = 0.45
	methods.append(paladin)
	
	var hero := TrainingMethodData.new()
	hero.id = "hero"
	hero.name = "Hero"
	hero.description = "Pickpocket heroes for massive rewards."
	hero.level_required = 82
	hero.xp_per_action = 273.3
	hero.action_time = 5.0
	hero.produced_items = {"coins": 130}
	hero.success_rate = 0.40
	methods.append(hero)
	
	var elf := TrainingMethodData.new()
	elf.id = "elf"
	elf.name = "Elf"
	elf.description = "Pickpocket elves for extraordinary riches."
	elf.level_required = 91
	elf.xp_per_action = 353.3
	elf.action_time = 5.5
	elf.produced_items = {"coins": 200}
	elf.success_rate = 0.35
	methods.append(elf)
	
	return methods
