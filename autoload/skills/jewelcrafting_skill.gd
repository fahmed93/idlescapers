## Jewelcrafting Skill
## Contains training methods for the Jewelcrafting skill
extends Node

## Create and return all jewelcrafting training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	# PROSPECTING - Find gems from ores
	# Level 1: Prospect Copper/Tin for Sapphires
	var prospect_copper := TrainingMethodData.new()
	prospect_copper.id = "prospect_copper"
	prospect_copper.name = "Prospect Bronze Ore"
	prospect_copper.description = "Prospect copper and tin ore together to find sapphires."
	prospect_copper.level_required = 1
	prospect_copper.xp_per_action = 10.0
	prospect_copper.action_time = 3.0
	prospect_copper.consumed_items = {"copper_ore": 1, "tin_ore": 1}
	prospect_copper.produced_items = {"sapphire": 1}
	methods.append(prospect_copper)
	
	# Level 20: Prospect Iron for Emeralds
	var prospect_iron := TrainingMethodData.new()
	prospect_iron.id = "prospect_iron"
	prospect_iron.name = "Prospect Iron"
	prospect_iron.description = "Prospect iron ore to find emeralds."
	prospect_iron.level_required = 20
	prospect_iron.xp_per_action = 20.0
	prospect_iron.action_time = 3.5
	prospect_iron.consumed_items = {"iron_ore": 2}
	prospect_iron.produced_items = {"emerald": 1}
	methods.append(prospect_iron)
	
	# Level 40: Prospect Gold for Rubies
	var prospect_gold := TrainingMethodData.new()
	prospect_gold.id = "prospect_gold"
	prospect_gold.name = "Prospect Gold"
	prospect_gold.description = "Prospect gold ore to find rubies."
	prospect_gold.level_required = 40
	prospect_gold.xp_per_action = 35.0
	prospect_gold.action_time = 4.0
	prospect_gold.consumed_items = {"gold_ore": 2}
	prospect_gold.produced_items = {"ruby": 1}
	methods.append(prospect_gold)
	
	# Level 55: Prospect Mithril for Diamonds
	var prospect_mithril := TrainingMethodData.new()
	prospect_mithril.id = "prospect_mithril"
	prospect_mithril.name = "Prospect Mithril"
	prospect_mithril.description = "Prospect mithril ore to find diamonds."
	prospect_mithril.level_required = 55
	prospect_mithril.xp_per_action = 50.0
	prospect_mithril.action_time = 4.5
	prospect_mithril.consumed_items = {"mithril_ore": 2}
	prospect_mithril.produced_items = {"diamond": 1}
	methods.append(prospect_mithril)
	
	# Level 70: Prospect Adamantite for Dragonstones
	var prospect_adamantite := TrainingMethodData.new()
	prospect_adamantite.id = "prospect_adamantite"
	prospect_adamantite.name = "Prospect Adamantite"
	prospect_adamantite.description = "Prospect adamantite ore to find dragonstones."
	prospect_adamantite.level_required = 70
	prospect_adamantite.xp_per_action = 70.0
	prospect_adamantite.action_time = 5.0
	prospect_adamantite.consumed_items = {"adamantite_ore": 3}
	prospect_adamantite.produced_items = {"dragonstone": 1}
	methods.append(prospect_adamantite)
	
	# Level 85: Prospect Runite for Onyx
	var prospect_runite := TrainingMethodData.new()
	prospect_runite.id = "prospect_runite"
	prospect_runite.name = "Prospect Runite"
	prospect_runite.description = "Prospect runite ore to find onyx gems."
	prospect_runite.level_required = 85
	prospect_runite.xp_per_action = 100.0
	prospect_runite.action_time = 6.0
	prospect_runite.consumed_items = {"runite_ore": 3}
	prospect_runite.produced_items = {"onyx": 1}
	methods.append(prospect_runite)
	
	# JEWELRY CRAFTING - Rings
	# Level 5: Sapphire Ring
	var sapphire_ring := TrainingMethodData.new()
	sapphire_ring.id = "sapphire_ring"
	sapphire_ring.name = "Sapphire Ring"
	sapphire_ring.description = "Craft a sapphire ring from a gold bar and sapphire."
	sapphire_ring.level_required = 5
	sapphire_ring.xp_per_action = 40.0
	sapphire_ring.action_time = 2.5
	sapphire_ring.consumed_items = {"gold_bar": 1, "sapphire": 1}
	sapphire_ring.produced_items = {"sapphire_ring": 1}
	methods.append(sapphire_ring)
	
	# Level 27: Emerald Ring
	var emerald_ring := TrainingMethodData.new()
	emerald_ring.id = "emerald_ring"
	emerald_ring.name = "Emerald Ring"
	emerald_ring.description = "Craft an emerald ring from a gold bar and emerald."
	emerald_ring.level_required = 27
	emerald_ring.xp_per_action = 55.0
	emerald_ring.action_time = 2.5
	emerald_ring.consumed_items = {"gold_bar": 1, "emerald": 1}
	emerald_ring.produced_items = {"emerald_ring": 1}
	methods.append(emerald_ring)
	
	# Level 42: Ruby Ring
	var ruby_ring := TrainingMethodData.new()
	ruby_ring.id = "ruby_ring"
	ruby_ring.name = "Ruby Ring"
	ruby_ring.description = "Craft a ruby ring from a gold bar and ruby."
	ruby_ring.level_required = 42
	ruby_ring.xp_per_action = 70.0
	ruby_ring.action_time = 2.5
	ruby_ring.consumed_items = {"gold_bar": 1, "ruby": 1}
	ruby_ring.produced_items = {"ruby_ring": 1}
	methods.append(ruby_ring)
	
	# Level 56: Diamond Ring
	var diamond_ring := TrainingMethodData.new()
	diamond_ring.id = "diamond_ring"
	diamond_ring.name = "Diamond Ring"
	diamond_ring.description = "Craft a diamond ring from a gold bar and diamond."
	diamond_ring.level_required = 56
	diamond_ring.xp_per_action = 85.0
	diamond_ring.action_time = 2.5
	diamond_ring.consumed_items = {"gold_bar": 1, "diamond": 1}
	diamond_ring.produced_items = {"diamond_ring": 1}
	methods.append(diamond_ring)
	
	# Level 72: Dragonstone Ring
	var dragonstone_ring := TrainingMethodData.new()
	dragonstone_ring.id = "dragonstone_ring"
	dragonstone_ring.name = "Dragonstone Ring"
	dragonstone_ring.description = "Craft a dragonstone ring from a gold bar and dragonstone."
	dragonstone_ring.level_required = 72
	dragonstone_ring.xp_per_action = 100.0
	dragonstone_ring.action_time = 3.0
	dragonstone_ring.consumed_items = {"gold_bar": 1, "dragonstone": 1}
	dragonstone_ring.produced_items = {"dragonstone_ring": 1}
	methods.append(dragonstone_ring)
	
	# Level 87: Onyx Ring
	var onyx_ring := TrainingMethodData.new()
	onyx_ring.id = "onyx_ring"
	onyx_ring.name = "Onyx Ring"
	onyx_ring.description = "Craft an onyx ring from a gold bar and onyx."
	onyx_ring.level_required = 87
	onyx_ring.xp_per_action = 115.0
	onyx_ring.action_time = 3.0
	onyx_ring.consumed_items = {"gold_bar": 1, "onyx": 1}
	onyx_ring.produced_items = {"onyx_ring": 1}
	methods.append(onyx_ring)
	
	# JEWELRY CRAFTING - Necklaces
	# Level 8: Sapphire Necklace
	var sapphire_necklace := TrainingMethodData.new()
	sapphire_necklace.id = "sapphire_necklace"
	sapphire_necklace.name = "Sapphire Necklace"
	sapphire_necklace.description = "Craft a sapphire necklace from a gold bar and sapphire."
	sapphire_necklace.level_required = 8
	sapphire_necklace.xp_per_action = 45.0
	sapphire_necklace.action_time = 2.5
	sapphire_necklace.consumed_items = {"gold_bar": 1, "sapphire": 1}
	sapphire_necklace.produced_items = {"sapphire_necklace": 1}
	methods.append(sapphire_necklace)
	
	# Level 29: Emerald Necklace
	var emerald_necklace := TrainingMethodData.new()
	emerald_necklace.id = "emerald_necklace"
	emerald_necklace.name = "Emerald Necklace"
	emerald_necklace.description = "Craft an emerald necklace from a gold bar and emerald."
	emerald_necklace.level_required = 29
	emerald_necklace.xp_per_action = 60.0
	emerald_necklace.action_time = 2.5
	emerald_necklace.consumed_items = {"gold_bar": 1, "emerald": 1}
	emerald_necklace.produced_items = {"emerald_necklace": 1}
	methods.append(emerald_necklace)
	
	# Level 43: Ruby Necklace
	var ruby_necklace := TrainingMethodData.new()
	ruby_necklace.id = "ruby_necklace"
	ruby_necklace.name = "Ruby Necklace"
	ruby_necklace.description = "Craft a ruby necklace from a gold bar and ruby."
	ruby_necklace.level_required = 43
	ruby_necklace.xp_per_action = 75.0
	ruby_necklace.action_time = 2.5
	ruby_necklace.consumed_items = {"gold_bar": 1, "ruby": 1}
	ruby_necklace.produced_items = {"ruby_necklace": 1}
	methods.append(ruby_necklace)
	
	# Level 58: Diamond Necklace
	var diamond_necklace := TrainingMethodData.new()
	diamond_necklace.id = "diamond_necklace"
	diamond_necklace.name = "Diamond Necklace"
	diamond_necklace.description = "Craft a diamond necklace from a gold bar and diamond."
	diamond_necklace.level_required = 58
	diamond_necklace.xp_per_action = 90.0
	diamond_necklace.action_time = 2.5
	diamond_necklace.consumed_items = {"gold_bar": 1, "diamond": 1}
	diamond_necklace.produced_items = {"diamond_necklace": 1}
	methods.append(diamond_necklace)
	
	# Level 74: Dragonstone Necklace
	var dragonstone_necklace := TrainingMethodData.new()
	dragonstone_necklace.id = "dragonstone_necklace"
	dragonstone_necklace.name = "Dragonstone Necklace"
	dragonstone_necklace.description = "Craft a dragonstone necklace from a gold bar and dragonstone."
	dragonstone_necklace.level_required = 74
	dragonstone_necklace.xp_per_action = 105.0
	dragonstone_necklace.action_time = 3.0
	dragonstone_necklace.consumed_items = {"gold_bar": 1, "dragonstone": 1}
	dragonstone_necklace.produced_items = {"dragonstone_necklace": 1}
	methods.append(dragonstone_necklace)
	
	# Level 90: Onyx Necklace
	var onyx_necklace := TrainingMethodData.new()
	onyx_necklace.id = "onyx_necklace"
	onyx_necklace.name = "Onyx Necklace"
	onyx_necklace.description = "Craft an onyx necklace from a gold bar and onyx."
	onyx_necklace.level_required = 90
	onyx_necklace.xp_per_action = 120.0
	onyx_necklace.action_time = 3.0
	onyx_necklace.consumed_items = {"gold_bar": 1, "onyx": 1}
	onyx_necklace.produced_items = {"onyx_necklace": 1}
	methods.append(onyx_necklace)
	
	return methods
