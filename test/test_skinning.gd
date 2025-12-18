## Test script to verify skinning skill functionality
extends Node

func _ready() -> void:
	print("\n=== SKINNING SKILL TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that skinning skill is loaded
	print("\nTest 1: Checking skinning skill loaded...")
	assert(GameManager.skills.has("skinning"), "Skinning skill should be loaded")
	var skinning_skill: SkillData = GameManager.skills["skinning"]
	print("  ✓ Skinning skill name: %s" % skinning_skill.name)
	print("  ✓ Skinning skill description: %s" % skinning_skill.description)
	print("  ✓ Training methods count: %d" % skinning_skill.training_methods.size())
	assert(skinning_skill.training_methods.size() == 20, "Should have 20 skinning methods")
	
	# Test 2: Check initial skill level
	print("\nTest 2: Checking initial skill level...")
	var level := GameManager.get_skill_level("skinning")
	print("  ✓ Initial skinning level: %d" % level)
	assert(level == 1, "Initial skinning level should be 1")
	
	# Test 3: Check training methods are properly defined
	print("\nTest 3: Checking training methods...")
	var expected_methods := [
		{"id": "rabbit", "level": 1, "xp": 10.0, "item": "rabbit_hide"},
		{"id": "chicken", "level": 3, "xp": 15.0, "item": "chicken_hide"},
		{"id": "cow", "level": 5, "xp": 20.0, "item": "cowhide"},
		{"id": "bear", "level": 10, "xp": 30.0, "item": "bear_hide"},
		{"id": "blue_dragon", "level": 55, "xp": 120.0, "item": "blue_dragonhide"},
		{"id": "phoenix", "level": 90, "xp": 225.0, "item": "phoenix_feather"}
	]
	
	for expected in expected_methods:
		var method: TrainingMethodData = null
		for m in skinning_skill.training_methods:
			if m.id == expected["id"]:
				method = m
				break
		assert(method != null, "Method %s should exist" % expected["id"])
		print("  ✓ %s: Level %d, XP %.1f, produces %s" % [method.name, method.level_required, method.xp_per_action, expected["item"]])
		assert(method.level_required == expected["level"], "Level requirement should match")
		assert(method.xp_per_action == expected["xp"], "XP should match")
		assert(method.produced_items.has(expected["item"]), "Should produce correct hide item")
	
	# Test 4: Check hide items exist in inventory
	print("\nTest 4: Checking hide items...")
	var hide_items := ["rabbit_hide", "cowhide", "blue_dragonhide", "phoenix_feather"]
	for hide_id in hide_items:
		var item_data := Inventory.get_item_data(hide_id)
		assert(item_data != null, "Hide item %s should exist" % hide_id)
		print("  ✓ %s: %s (value: %d)" % [hide_id, item_data.name, item_data.value])
	
	# Test 5: Test starting rabbit skinning
	print("\nTest 5: Testing rabbit skinning...")
	var start_success := GameManager.start_training("skinning", "rabbit")
	assert(start_success, "Should be able to start rabbit skinning")
	print("  ✓ Started rabbit skinning")
	
	# Simulate one complete action
	var rabbit_method: TrainingMethodData = skinning_skill.training_methods[0]
	print("  ✓ Simulating %.1f seconds of training..." % rabbit_method.action_time)
	
	# Fast-forward time
	for i in range(int(rabbit_method.action_time * 60)):  # Simulate at 60 FPS
		GameManager._process(1.0 / 60.0)
	
	# Check if we got XP and a rabbit hide
	var skinning_xp := GameManager.get_skill_xp("skinning")
	print("  ✓ Skinning XP gained: %.2f" % skinning_xp)
	assert(skinning_xp > 0, "Should have gained XP")
	
	var rabbit_hides := Inventory.get_item_count("rabbit_hide")
	print("  ✓ Rabbit hides collected: %d" % rabbit_hides)
	assert(rabbit_hides > 0, "Should have collected at least one rabbit hide")
	
	GameManager.stop_training()
	
	# Test 6: Test higher level method (cow)
	print("\nTest 6: Testing cow skinning...")
	GameManager.skill_levels["skinning"] = 5  # Set level to 5
	print("  ✓ Set skinning level to 5")
	
	GameManager.start_training("skinning", "cow")
	print("  ✓ Started cow skinning")
	
	# Simulate 3 complete actions
	var cow_method: TrainingMethodData = null
	for m in skinning_skill.training_methods:
		if m.id == "cow":
			cow_method = m
			break
	
	var initial_xp := GameManager.get_skill_xp("skinning")
	for action in range(3):
		for i in range(int(cow_method.action_time * 60)):
			GameManager._process(1.0 / 60.0)
	
	var cowhides := Inventory.get_item_count("cowhide")
	var xp_gained := GameManager.get_skill_xp("skinning") - initial_xp
	print("  ✓ Cowhides collected: %d" % cowhides)
	print("  ✓ Total XP gained: %.2f" % xp_gained)
	assert(cowhides >= 3, "Should have collected at least 3 cowhides")
	assert(xp_gained >= 60.0, "Should have gained at least 60 XP (3 x 20)")
	
	GameManager.stop_training()
	
	# Test 7: Verify no consumed items (skinning doesn't consume items)
	print("\nTest 7: Verifying skinning has no consumed items...")
	for method in skinning_skill.training_methods:
		assert(method.consumed_items.is_empty(), "Skinning methods should not consume items")
	print("  ✓ All skinning methods have no consumed items")
	
	# Test 8: Verify all methods produce exactly one hide/skin/feather
	print("\nTest 8: Verifying all methods produce exactly one item...")
	for method in skinning_skill.training_methods:
		assert(method.produced_items.size() == 1, "Should produce exactly 1 type of item")
		var produced_count := 0
		for item in method.produced_items.values():
			produced_count += item
		assert(produced_count == 1, "Should produce exactly 1 item per action")
	print("  ✓ All skinning methods produce exactly one item per action")
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
