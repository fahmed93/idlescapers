## Test script to verify crafting skill functionality
extends Node

func _ready() -> void:
	print("\n=== CRAFTING SKILL TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that crafting skill is loaded
	print("\nTest 1: Checking crafting skill loaded...")
	assert(GameManager.skills.has("crafting"), "Crafting skill should be loaded")
	var crafting_skill: SkillData = GameManager.skills["crafting"]
	print("  ✓ Crafting skill name: %s" % crafting_skill.name)
	print("  ✓ Crafting skill description: %s" % crafting_skill.description)
	print("  ✓ Training methods count: %d" % crafting_skill.training_methods.size())
	assert(crafting_skill.training_methods.size() == 30, "Should have 30 crafting methods")
	
	# Test 2: Check initial skill level
	print("\nTest 2: Checking initial skill level...")
	var level := GameManager.get_skill_level("crafting")
	print("  ✓ Initial crafting level: %d" % level)
	assert(level == 1, "Initial crafting level should be 1")
	
	# Test 3: Check leather armor training methods are properly defined
	print("\nTest 3: Checking leather armor training methods...")
	var expected_leather_methods := [
		{"id": "leather_gloves", "level": 1, "xp": 13.8, "consumes": "rabbit_hide", "produces": "leather_gloves"},
		{"id": "leather_boots", "level": 3, "xp": 16.25, "consumes": "rabbit_hide", "produces": "leather_boots"},
		{"id": "leather_body", "level": 11, "xp": 25.0, "consumes": "cowhide", "produces": "leather_body"},
		{"id": "hard_leather_body", "level": 18, "xp": 35.0, "consumes": "bear_hide", "produces": "hard_leather_body"},
		{"id": "studded_body", "level": 22, "xp": 40.0, "consumes": "wolf_hide", "produces": "studded_body"}
	]
	
	for expected in expected_leather_methods:
		var method: TrainingMethodData = null
		for m in crafting_skill.training_methods:
			if m.id == expected["id"]:
				method = m
				break
		assert(method != null, "Method %s should exist" % expected["id"])
		print("  ✓ %s: Level %d, XP %.2f" % [method.name, method.level_required, method.xp_per_action])
		assert(method.level_required == expected["level"], "Level requirement should match")
		assert(method.xp_per_action == expected["xp"], "XP should match")
		assert(method.consumed_items.has(expected["consumes"]), "Should consume correct hide")
		assert(method.produced_items.has(expected["produces"]), "Should produce correct item")
	
	# Test 4: Check dragonhide armor training methods
	print("\nTest 4: Checking dragonhide armor training methods...")
	var expected_dragonhide_methods := [
		{"id": "green_dhide_vambraces", "level": 40, "xp": 62.0, "consumes": "green_dragonhide", "amount": 1},
		{"id": "green_dhide_body", "level": 45, "xp": 186.0, "consumes": "green_dragonhide", "amount": 3},
		{"id": "blue_dhide_vambraces", "level": 52, "xp": 70.0, "consumes": "blue_dragonhide", "amount": 1},
		{"id": "red_dhide_body", "level": 65, "xp": 234.0, "consumes": "red_dragonhide", "amount": 3},
		{"id": "black_dhide_body", "level": 75, "xp": 258.0, "consumes": "black_dragonhide", "amount": 3}
	]
	
	for expected in expected_dragonhide_methods:
		var method: TrainingMethodData = null
		for m in crafting_skill.training_methods:
			if m.id == expected["id"]:
				method = m
				break
		assert(method != null, "Method %s should exist" % expected["id"])
		print("  ✓ %s: Level %d, XP %.1f, requires %d x %s" % [
			method.name, 
			method.level_required, 
			method.xp_per_action,
			expected["amount"],
			expected["consumes"]
		])
		assert(method.level_required == expected["level"], "Level requirement should match")
		assert(method.xp_per_action == expected["xp"], "XP should match")
		assert(method.consumed_items.has(expected["consumes"]), "Should consume dragonhide")
		assert(method.consumed_items[expected["consumes"]] == expected["amount"], "Should consume correct amount")
	
	# Test 5: Check crafted items exist in inventory
	print("\nTest 5: Checking crafted items...")
	var crafted_items := [
		"leather_gloves", "leather_boots", "leather_body", "hard_leather_body",
		"green_dhide_body", "blue_dhide_chaps", "red_dhide_vambraces", "black_dhide_body"
	]
	for item_id in crafted_items:
		var item_data := Inventory.get_item_data(item_id)
		assert(item_data != null, "Crafted item %s should exist" % item_id)
		print("  ✓ %s: %s (value: %d)" % [item_id, item_data.name, item_data.value])
	
	# Test 6: Test crafting leather gloves (requires rabbit hide)
	print("\nTest 6: Testing leather gloves crafting...")
	
	# Add rabbit hide to inventory
	Inventory.add_item("rabbit_hide", 5)
	var rabbit_hides_before := Inventory.get_item_count("rabbit_hide")
	print("  ✓ Added rabbit hides to inventory: %d" % rabbit_hides_before)
	
	var start_success := GameManager.start_training("crafting", "leather_gloves")
	assert(start_success, "Should be able to start crafting leather gloves")
	print("  ✓ Started crafting leather gloves")
	
	# Simulate one complete action
	var gloves_method: TrainingMethodData = null
	for m in crafting_skill.training_methods:
		if m.id == "leather_gloves":
			gloves_method = m
			break
	
	print("  ✓ Simulating %.1f seconds of training..." % gloves_method.action_time)
	
	# Fast-forward time
	for i in range(int(gloves_method.action_time * 60)):  # Simulate at 60 FPS
		GameManager._process(1.0 / 60.0)
	
	# Check if we got XP and leather gloves
	var crafting_xp := GameManager.get_skill_xp("crafting")
	print("  ✓ Crafting XP gained: %.2f" % crafting_xp)
	assert(crafting_xp > 0, "Should have gained XP")
	
	var leather_gloves_count := Inventory.get_item_count("leather_gloves")
	print("  ✓ Leather gloves crafted: %d" % leather_gloves_count)
	assert(leather_gloves_count > 0, "Should have crafted at least one pair of leather gloves")
	
	var rabbit_hides_after := Inventory.get_item_count("rabbit_hide")
	print("  ✓ Rabbit hides remaining: %d" % rabbit_hides_after)
	assert(rabbit_hides_after < rabbit_hides_before, "Should have consumed rabbit hide")
	
	GameManager.stop_training()
	
	# Test 7: Test crafting green dragonhide body (requires 3 green dragonhides)
	print("\nTest 7: Testing green dragonhide body crafting...")
	GameManager.skill_levels["crafting"] = 45  # Set level to 45
	print("  ✓ Set crafting level to 45")
	
	# Add green dragonhides to inventory
	Inventory.add_item("green_dragonhide", 10)
	var green_dhides_before := Inventory.get_item_count("green_dragonhide")
	print("  ✓ Added green dragonhides to inventory: %d" % green_dhides_before)
	
	GameManager.start_training("crafting", "green_dhide_body")
	print("  ✓ Started crafting green dragonhide body")
	
	# Simulate 2 complete actions
	var green_body_method: TrainingMethodData = null
	for m in crafting_skill.training_methods:
		if m.id == "green_dhide_body":
			green_body_method = m
			break
	
	var initial_xp := GameManager.get_skill_xp("crafting")
	for action in range(2):
		for i in range(int(green_body_method.action_time * 60)):
			GameManager._process(1.0 / 60.0)
	
	var green_bodies := Inventory.get_item_count("green_dhide_body")
	var xp_gained := GameManager.get_skill_xp("crafting") - initial_xp
	var green_dhides_after := Inventory.get_item_count("green_dragonhide")
	
	print("  ✓ Green dragonhide bodies crafted: %d" % green_bodies)
	print("  ✓ Total XP gained: %.2f" % xp_gained)
	print("  ✓ Green dragonhides consumed: %d" % (green_dhides_before - green_dhides_after))
	
	assert(green_bodies >= 2, "Should have crafted at least 2 green dragonhide bodies")
	assert(xp_gained >= 372.0, "Should have gained at least 372 XP (2 x 186)")
	assert(green_dhides_after == green_dhides_before - 6, "Should have consumed 6 green dragonhides (2 bodies x 3)")
	
	GameManager.stop_training()
	
	# Test 8: Verify all methods consume hides (crafting requires materials)
	print("\nTest 8: Verifying crafting methods consume hides...")
	for method in crafting_skill.training_methods:
		assert(not method.consumed_items.is_empty(), "Crafting methods should consume items")
	print("  ✓ All crafting methods have consumed items")
	
	# Test 9: Verify all methods produce exactly one armor piece
	print("\nTest 9: Verifying all methods produce exactly one armor piece...")
	for method in crafting_skill.training_methods:
		assert(method.produced_items.size() == 1, "Should produce exactly 1 type of item")
		var produced_count := 0
		for item in method.produced_items.values():
			produced_count += item
		assert(produced_count == 1, "Should produce exactly 1 armor piece per action")
	print("  ✓ All crafting methods produce exactly one armor piece per action")
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
