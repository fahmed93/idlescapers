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
	# Expected: 8 bars + 36 craftables (6 each of: arrowheads, daggers, swords, helms, platelegs, platebodies)
	var expected_method_count := 44
	assert(smithing_skill.training_methods.size() == expected_method_count, "Should have %d smithing methods (8 bars + 36 craftables)" % expected_method_count)
	print("  ✓ Smithing skill loaded with correct method count")
	
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
	print("  ✓ All bar items exist")
	
	# Test 4.5: Check craftable items are in inventory
	print("\nTest 4.5: Checking craftable items...")
	var arrowhead_items := ["bronze_arrowhead", "iron_arrowhead", "steel_arrowhead", "mithril_arrowhead", "adamantite_arrowhead", "runite_arrowhead"]
	var dagger_items := ["bronze_dagger", "iron_dagger", "steel_dagger", "mithril_dagger", "adamantite_dagger", "runite_dagger"]
	var sword_items := ["bronze_sword", "iron_sword", "steel_sword", "mithril_sword", "adamantite_sword", "runite_sword"]
	var helm_items := ["bronze_full_helm", "iron_full_helm", "steel_full_helm", "mithril_full_helm", "adamantite_full_helm", "runite_full_helm"]
	var platebody_items := ["bronze_platebody", "iron_platebody", "steel_platebody", "mithril_platebody", "adamantite_platebody", "runite_platebody"]
	var platelegs_items := ["bronze_platelegs", "iron_platelegs", "steel_platelegs", "mithril_platelegs", "adamantite_platelegs", "runite_platelegs"]
	
	var all_craftable_items := arrowhead_items + dagger_items + sword_items + helm_items + platebody_items + platelegs_items
	for item_id in all_craftable_items:
		var item_data := Inventory.get_item_data(item_id)
		assert(item_data != null, "Craftable item %s should exist" % item_id)
	print("  ✓ All %d craftable items exist" % all_craftable_items.size())
	
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
	
	# Test 6.5: Test bronze arrowhead smithing
	print("\nTest 6.5: Testing bronze arrowhead smithing...")
	GameManager.skill_levels["smithing"] = 1  # Reset to level 1
	Inventory.add_item("bronze_bar", 5)
	print("  Set smithing level to 1 and added 5 bronze bars")
	
	var start_bronze_arrowheads := GameManager.start_training("smithing", "bronze_arrowheads")
	assert(start_bronze_arrowheads, "Should be able to start bronze arrowhead smithing")
	print("  Started bronze arrowhead smithing")
	
	# Simulate one complete action
	var arrowheads_method: TrainingMethodData = null
	for method in smithing_skill.training_methods:
		if method.id == "bronze_arrowheads":
			arrowheads_method = method
			break
	
	assert(arrowheads_method != null, "Should find bronze arrowheads method")
	print("  Simulating %.1f seconds of training..." % arrowheads_method.action_time)
	
	# Fast-forward time
	for i in range(int(arrowheads_method.action_time * 60)):
		GameManager._process(1.0 / 60.0)
	
	var bronze_arrowheads_count := Inventory.get_item_count("bronze_arrowhead")
	print("  Bronze arrowheads produced: %d" % bronze_arrowheads_count)
	assert(bronze_arrowheads_count == 15, "Should have produced 15 bronze arrowheads from 1 bar")
	print("  ✓ Bronze arrowhead smithing works correctly (15 per bar)")
	
	GameManager.stop_training()
	
	# Test 7: Test bronze dagger smithing
	print("\nTest 7: Testing bronze dagger smithing...")
	Inventory.add_item("bronze_bar", 10)
	print("  Added 10 bronze bars")
	
	var start_dagger := GameManager.start_training("smithing", "bronze_dagger")
	assert(start_dagger, "Should be able to start bronze dagger smithing")
	print("  Started bronze dagger smithing")
	
	# Simulate one complete action
	var dagger_method: TrainingMethodData = null
	for method in smithing_skill.training_methods:
		if method.id == "bronze_dagger":
			dagger_method = method
			break
	
	assert(dagger_method != null, "Should find bronze dagger method")
	print("  Simulating %.1f seconds of training..." % dagger_method.action_time)
	
	# Fast-forward time
	for i in range(int(dagger_method.action_time * 60)):
		GameManager._process(1.0 / 60.0)
	
	var bronze_daggers_count := Inventory.get_item_count("bronze_dagger")
	print("  Bronze daggers produced: %d" % bronze_daggers_count)
	assert(bronze_daggers_count == 1, "Should have produced 1 bronze dagger from 1 bar")
	print("  ✓ Bronze dagger smithing works correctly")
	
	GameManager.stop_training()
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
