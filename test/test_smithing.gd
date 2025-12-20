## Test script to verify smithing skill functionality
extends Node

func _ready() -> void:
	print("\n=== SMITHING SKILL TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that smithing skill is loaded
	print("\nTest 1: Checking smithing skill loaded...")
	assert(GameManager.skills.has("smithing"), "Smithing skill should be loaded")
	var smithing_skill: SkillData = GameManager.skills["smithing"]
	print("  Smithing skill name: %s" % smithing_skill.name)
	print("  Smithing skill description: %s" % smithing_skill.description)
	print("  Training methods count: %d" % smithing_skill.training_methods.size())
	assert(smithing_skill.training_methods.size() == 50, "Should have 50 smithing methods (8 bars + 42 craftable items)")
	
	# Test 2: Check initial skill level
	print("\nTest 2: Checking initial skill level...")
	var level := GameManager.get_skill_level("smithing")
	print("  Initial smithing level: %d" % level)
	assert(level == 1, "Initial smithing level should be 1")
	
	# Test 3: Check all training methods
	print("\nTest 3: Checking all training methods...")
	var expected_methods := [
		{"id": "bronze_bar", "level": 1, "xp": 6.25},
		{"id": "iron_bar", "level": 15, "xp": 12.5},
		{"id": "silver_bar", "level": 20, "xp": 13.75},
		{"id": "steel_bar", "level": 30, "xp": 17.5},
		{"id": "gold_bar", "level": 40, "xp": 22.5},
		{"id": "mithril_bar", "level": 50, "xp": 30.0},
		{"id": "adamantite_bar", "level": 70, "xp": 37.5},
		{"id": "runite_bar", "level": 85, "xp": 50.0}
	]
	
	for i in range(expected_methods.size()):
		var method: TrainingMethodData = smithing_skill.training_methods[i]
		var expected: Dictionary = expected_methods[i]
		print("  Method %d: %s (Level %d, XP %.2f)" % [i+1, method.name, method.level_required, method.xp_per_action])
		assert(method.id == expected["id"], "Method ID should match")
		assert(method.level_required == expected["level"], "Level requirement should match")
		assert(method.xp_per_action == expected["xp"], "XP should match")
	
	# Test 4: Check bar items are in inventory
	print("\nTest 4: Checking bar items...")
	var bar_items := ["bronze_bar", "iron_bar", "silver_bar", "steel_bar", "gold_bar", "mithril_bar", "adamantite_bar", "runite_bar"]
	for bar_id in bar_items:
		var item_data := Inventory.get_item_data(bar_id)
		assert(item_data != null, "Bar item %s should exist" % bar_id)
		print("  %s: %s (value: %d)" % [bar_id, item_data.name, item_data.value])
	
	# Test 5: Test bronze bar smelting with materials
	print("\nTest 5: Testing bronze bar smelting...")
	Inventory.add_item("copper_ore", 10)
	Inventory.add_item("tin_ore", 10)
	print("  Added 10 copper ore and 10 tin ore")
	
	var start_success := GameManager.start_training("smithing", "bronze_bar")
	assert(start_success, "Should be able to start bronze bar smelting")
	print("  Started bronze bar smelting")
	
	# Simulate one complete action
	var bronze_method: TrainingMethodData = smithing_skill.training_methods[0]
	print("  Simulating %.1f seconds of training..." % bronze_method.action_time)
	
	# Fast-forward time
	for i in range(int(bronze_method.action_time * 60)):  # Simulate at 60 FPS
		GameManager._process(1.0 / 60.0)
	
	# Check if we got XP and a bronze bar
	var smithing_xp := GameManager.get_skill_xp("smithing")
	print("  Smithing XP gained: %.2f" % smithing_xp)
	assert(smithing_xp > 0, "Should have gained XP")
	
	var bronze_bars := Inventory.get_item_count("bronze_bar")
	print("  Bronze bars produced: %d" % bronze_bars)
	assert(bronze_bars > 0, "Should have produced at least one bronze bar")
	
	GameManager.stop_training()
	
	# Test 6: Test iron bar with 50% success rate
	print("\nTest 6: Testing iron bar with 50% success rate...")
	GameManager.skill_levels["smithing"] = 15  # Set level to 15
	Inventory.add_item("iron_ore", 100)
	print("  Set smithing level to 15 and added 100 iron ore")
	
	GameManager.start_training("smithing", "iron_bar")
	print("  Started iron bar smelting")
	
	# Simulate 10 complete actions
	var iron_method: TrainingMethodData = smithing_skill.training_methods[1]
	var initial_iron := Inventory.get_item_count("iron_ore")
	for action in range(10):
		for i in range(int(iron_method.action_time * 60)):
			GameManager._process(1.0 / 60.0)
	
	var iron_consumed := initial_iron - Inventory.get_item_count("iron_ore")
	var iron_bars := Inventory.get_item_count("iron_bar")
	print("  Iron ore consumed: %d" % iron_consumed)
	print("  Iron bars produced: %d" % iron_bars)
	print("  Success rate: %.1f%%" % ((float(iron_bars) / iron_consumed) * 100))
	assert(iron_bars < iron_consumed, "Should have produced fewer bars than ore consumed due to 50% success rate")
	
	GameManager.stop_training()
	
	# Test 7: Test crafting bronze items from bars
	print("\nTest 7: Testing bronze item crafting...")
	GameManager.skill_levels["smithing"] = 1  # Reset to level 1
	Inventory.add_item("bronze_bar", 20)
	print("  Set smithing level to 1 and added 20 bronze bars")
	
	# Test bronze dagger crafting
	GameManager.start_training("smithing", "bronze_dagger")
	print("  Started bronze dagger crafting")
	
	var dagger_method: TrainingMethodData = null
	for method in smithing_skill.training_methods:
		if method.id == "bronze_dagger":
			dagger_method = method
			break
	
	assert(dagger_method != null, "Bronze dagger method should exist")
	
	# Complete one dagger
	for i in range(int(dagger_method.action_time * 60)):
		GameManager._process(1.0 / 60.0)
	
	var daggers := Inventory.get_item_count("bronze_dagger")
	print("  Bronze daggers produced: %d" % daggers)
	assert(daggers > 0, "Should have produced at least one bronze dagger")
	
	GameManager.stop_training()
	
	# Test bronze arrowheads (15 per bar)
	print("\n  Testing bronze arrowheads...")
	GameManager.start_training("smithing", "bronze_arrowheads")
	
	var arrowhead_method: TrainingMethodData = null
	for method in smithing_skill.training_methods:
		if method.id == "bronze_arrowheads":
			arrowhead_method = method
			break
	
	assert(arrowhead_method != null, "Bronze arrowheads method should exist")
	
	# Complete one batch
	for i in range(int(arrowhead_method.action_time * 60)):
		GameManager._process(1.0 / 60.0)
	
	var arrowheads := Inventory.get_item_count("bronze_arrowhead")
	print("  Bronze arrowheads produced: %d" % arrowheads)
	assert(arrowheads >= 15, "Should have produced at least 15 bronze arrowheads per bar")
	
	GameManager.stop_training()
	
	# Test 8: Verify all methods have categories assigned
	print("\nTest 8: Checking category assignments...")
	var categories: Dictionary = {}  # category_name -> count
	
	for method in smithing_skill.training_methods:
		var category := method.category if method.category != "" else "General"
		categories[category] = categories.get(category, 0) + 1
	
	print("  Categories found: %s" % ", ".join(categories.keys()))
	assert(categories.size() == 7, "Should have exactly 7 categories")
	assert(categories.has("Bars"), "Should have Bars category")
	assert(categories.has("Bronze"), "Should have Bronze category")
	assert(categories.has("Iron"), "Should have Iron category")
	assert(categories.has("Steel"), "Should have Steel category")
	assert(categories.has("Mithril"), "Should have Mithril category")
	assert(categories.has("Adamantite"), "Should have Adamantite category")
	assert(categories.has("Runite"), "Should have Runite category")
	
	# Verify counts
	assert(categories["Bars"] == 8, "Bars should have 8 methods")
	assert(categories["Bronze"] == 7, "Bronze should have 7 methods")
	assert(categories["Iron"] == 7, "Iron should have 7 methods")
	assert(categories["Steel"] == 7, "Steel should have 7 methods")
	assert(categories["Mithril"] == 7, "Mithril should have 7 methods")
	assert(categories["Adamantite"] == 7, "Adamantite should have 7 methods")
	assert(categories["Runite"] == 7, "Runite should have 7 methods")
	
	print("  ✓ Bars: %d methods" % categories["Bars"])
	print("  ✓ Bronze: %d methods" % categories["Bronze"])
	print("  ✓ Iron: %d methods" % categories["Iron"])
	print("  ✓ Steel: %d methods" % categories["Steel"])
	print("  ✓ Mithril: %d methods" % categories["Mithril"])
	print("  ✓ Adamantite: %d methods" % categories["Adamantite"])
	print("  ✓ Runite: %d methods" % categories["Runite"])
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
