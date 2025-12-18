## Test script to verify jewelcrafting skill functionality
extends Node

func _ready() -> void:
	print("\n=== JEWELCRAFTING SKILL TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that jewelcrafting skill is loaded
	print("\nTest 1: Checking jewelcrafting skill loaded...")
	assert(GameManager.skills.has("jewelcrafting"), "Jewelcrafting skill should be loaded")
	var jewelcrafting_skill: SkillData = GameManager.skills["jewelcrafting"]
	print("  ✓ Jewelcrafting skill name: %s" % jewelcrafting_skill.name)
	print("  ✓ Jewelcrafting skill description: %s" % jewelcrafting_skill.description)
	print("  ✓ Training methods count: %d" % jewelcrafting_skill.training_methods.size())
	assert(jewelcrafting_skill.training_methods.size() == 18, "Should have 18 training methods (6 prospecting + 12 crafting)")
	
	# Test 2: Check initial skill level
	print("\nTest 2: Checking initial skill level...")
	var level := GameManager.get_skill_level("jewelcrafting")
	print("  ✓ Initial jewelcrafting level: %d" % level)
	assert(level == 1, "Initial jewelcrafting level should be 1")
	
	# Test 3: Check prospecting methods
	print("\nTest 3: Checking prospecting methods...")
	var prospecting_methods := [
		{"id": "prospect_copper", "level": 1, "gem": "sapphire"},
		{"id": "prospect_iron", "level": 20, "gem": "emerald"},
		{"id": "prospect_gold", "level": 40, "gem": "ruby"},
		{"id": "prospect_mithril", "level": 55, "gem": "diamond"},
		{"id": "prospect_adamantite", "level": 70, "gem": "dragonstone"},
		{"id": "prospect_runite", "level": 85, "gem": "onyx"}
	]
	
	for i in range(prospecting_methods.size()):
		var method: TrainingMethodData = jewelcrafting_skill.training_methods[i]
		var expected: Dictionary = prospecting_methods[i]
		print("  ✓ Method %d: %s (Level %d, produces %s)" % [i+1, method.name, method.level_required, expected["gem"]])
		assert(method.id == expected["id"], "Method ID should match")
		assert(method.level_required == expected["level"], "Level requirement should match")
		assert(expected["gem"] in method.produced_items, "Should produce expected gem")
	
	# Test 4: Check jewelry crafting methods
	print("\nTest 4: Checking jewelry crafting methods...")
	var jewelry_count := 0
	for method in jewelcrafting_skill.training_methods:
		if "ring" in method.id or "necklace" in method.id:
			jewelry_count += 1
			print("  ✓ %s (Level %d)" % [method.name, method.level_required])
	assert(jewelry_count == 12, "Should have 12 jewelry crafting methods")
	
	# Test 5: Check gem items are in inventory
	print("\nTest 5: Checking gem items...")
	var gem_items := ["sapphire", "emerald", "ruby", "diamond", "dragonstone", "onyx"]
	for gem_id in gem_items:
		var item_data := Inventory.get_item_data(gem_id)
		assert(item_data != null, "Gem item %s should exist" % gem_id)
		print("  ✓ %s: %s (value: %d)" % [gem_id, item_data.name, item_data.value])
	
	# Test 6: Check jewelry items are in inventory
	print("\nTest 6: Checking jewelry items...")
	var jewelry_items := ["sapphire_ring", "emerald_ring", "ruby_ring", "diamond_ring", "dragonstone_ring", "onyx_ring",
						  "sapphire_necklace", "emerald_necklace", "ruby_necklace", "diamond_necklace", "dragonstone_necklace", "onyx_necklace"]
	for jewelry_id in jewelry_items:
		var item_data := Inventory.get_item_data(jewelry_id)
		assert(item_data != null, "Jewelry item %s should exist" % jewelry_id)
		print("  ✓ %s: %s (value: %d)" % [jewelry_id, item_data.name, item_data.value])
	
	# Test 7: Test prospecting copper for sapphires
	print("\nTest 7: Testing prospecting copper/tin for sapphires...")
	Inventory.add_item("copper_ore", 10)
	Inventory.add_item("tin_ore", 10)
	print("  Added 10 copper ore and 10 tin ore")
	
	var start_success := GameManager.start_training("jewelcrafting", "prospect_copper")
	assert(start_success, "Should be able to start prospecting copper")
	print("  ✓ Started prospecting copper/tin")
	
	# Simulate one complete action
	var prospect_method: TrainingMethodData = jewelcrafting_skill.training_methods[0]
	print("  Simulating %.1f seconds of training..." % prospect_method.action_time)
	
	# Fast-forward time
	for i in range(int(prospect_method.action_time * 60)):  # Simulate at 60 FPS
		GameManager._process(1.0 / 60.0)
	
	# Check if we got XP and a sapphire
	var jewelcrafting_xp := GameManager.get_skill_xp("jewelcrafting")
	print("  ✓ Jewelcrafting XP gained: %.2f" % jewelcrafting_xp)
	assert(jewelcrafting_xp > 0, "Should have gained XP")
	
	var sapphires := Inventory.get_item_count("sapphire")
	print("  ✓ Sapphires produced: %d" % sapphires)
	assert(sapphires > 0, "Should have produced at least one sapphire")
	
	GameManager.stop_training()
	
	# Test 8: Test crafting a sapphire ring
	print("\nTest 8: Testing crafting sapphire ring...")
	GameManager.skill_levels["jewelcrafting"] = 5  # Set level to 5
	Inventory.add_item("gold_bar", 5)
	Inventory.add_item("sapphire", 5)
	print("  Set jewelcrafting level to 5 and added 5 gold bars and 5 sapphires")
	
	var initial_gold := Inventory.get_item_count("gold_bar")
	var initial_sapphires := Inventory.get_item_count("sapphire")
	
	GameManager.start_training("jewelcrafting", "sapphire_ring")
	print("  ✓ Started crafting sapphire ring")
	
	# Simulate one complete action
	var craft_method: TrainingMethodData = null
	for method in jewelcrafting_skill.training_methods:
		if method.id == "sapphire_ring":
			craft_method = method
			break
	
	for i in range(int(craft_method.action_time * 60)):
		GameManager._process(1.0 / 60.0)
	
	var sapphire_rings := Inventory.get_item_count("sapphire_ring")
	print("  ✓ Sapphire rings produced: %d" % sapphire_rings)
	assert(sapphire_rings > 0, "Should have produced at least one sapphire ring")
	
	var gold_consumed := initial_gold - Inventory.get_item_count("gold_bar")
	var sapphires_consumed := initial_sapphires - Inventory.get_item_count("sapphire")
	print("  ✓ Gold bars consumed: %d" % gold_consumed)
	print("  ✓ Sapphires consumed: %d" % sapphires_consumed)
	assert(gold_consumed > 0, "Should have consumed gold bars")
	assert(sapphires_consumed > 0, "Should have consumed sapphires")
	
	GameManager.stop_training()
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
