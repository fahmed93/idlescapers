## Test script to verify Agility skill functionality
extends Node

func _ready() -> void:
	print("\n=== AGILITY SKILL TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that Agility skill is registered
	print("\nTest 1: Checking Agility skill is registered...")
	var agility_skill = GameManager.skills.get("agility")
	assert(agility_skill != null, "Agility skill should be registered")
	print("  ✓ Agility skill found: %s" % agility_skill.name)
	print("    Description: %s" % agility_skill.description)
	print("    Color: %s" % agility_skill.color)
	
	# Test 2: Check training methods are loaded
	print("\nTest 2: Checking Agility training methods...")
	var training_methods = agility_skill.training_methods
	print("  Training methods count: %d" % training_methods.size())
	assert(training_methods.size() == 10, "Agility should have 10 obstacle courses")
	
	# List all methods
	for method in training_methods:
		print("    - Lv %d: %s (%.1f XP, %.1fs)" % [method.level_required, method.name, method.xp_per_action, method.action_time])
	
	# Test 3: Check specific courses
	print("\nTest 3: Verifying specific courses...")
	var gnome_stronghold = null
	var seers = null
	var ardougne = null
	
	for method in training_methods:
		if method.id == "gnome_stronghold":
			gnome_stronghold = method
		elif method.id == "seers":
			seers = method
		elif method.id == "ardougne":
			ardougne = method
	
	assert(gnome_stronghold != null, "Gnome Stronghold course should exist")
	assert(gnome_stronghold.level_required == 1, "Gnome Stronghold should require level 1")
	print("  ✓ Gnome Stronghold: Level %d, %.1f XP" % [gnome_stronghold.level_required, gnome_stronghold.xp_per_action])
	
	assert(seers != null, "Seers' Village course should exist")
	assert(seers.level_required == 60, "Seers' Village should require level 60")
	print("  ✓ Seers' Village: Level %d, %.1f XP" % [seers.level_required, seers.xp_per_action])
	
	assert(ardougne != null, "Ardougne course should exist")
	assert(ardougne.level_required == 90, "Ardougne should require level 90")
	print("  ✓ Ardougne: Level %d, %.1f XP" % [ardougne.level_required, ardougne.xp_per_action])
	
	# Test 4: Check marks of grace item
	print("\nTest 4: Checking marks of grace item...")
	var marks_item = Inventory.get_item_data("marks_of_grace")
	assert(marks_item != null, "Marks of Grace should be registered")
	assert(marks_item.type == ItemData.ItemType.PROCESSED, "Marks of Grace should be PROCESSED type")
	print("  ✓ Marks of Grace: %s (value: %d)" % [marks_item.description, marks_item.value])
	
	# Test 5: Test course completion simulation
	print("\nTest 5: Testing course completion simulation...")
	
	var initial_level = GameManager.get_skill_level("agility")
	print("  Initial Agility level: %d" % initial_level)
	print("  Starting training: Gnome Stronghold Course")
	
	var start_result = GameManager.start_training("agility", "gnome_stronghold")
	assert(start_result, "Should be able to start Gnome Stronghold course")
	print("  ✓ Training started successfully")
	
	# Wait for one action to complete (35 seconds in-game, but we'll wait shorter)
	await get_tree().create_timer(36.0).timeout
	
	var marks_count = Inventory.get_item_count("marks_of_grace")
	print("  Marks of Grace obtained: %d" % marks_count)
	print("  (Note: Marks have 15%% success rate, so 0 is possible)")
	
	var current_xp = GameManager.get_skill_xp("agility")
	print("  Current Agility XP: %.1f" % current_xp)
	assert(current_xp > 0, "Should have gained some XP")
	print("  ✓ XP gained successfully")
	
	GameManager.stop_training()
	print("  ✓ Training stopped")
	
	# Test 6: Verify level requirements
	print("\nTest 6: Testing level requirements...")
	var current_level = GameManager.get_skill_level("agility")
	print("  Current level: %d" % current_level)
	
	# Try to start a high-level course (should fail)
	var high_level_result = GameManager.start_training("agility", "ardougne")
	if current_level < 90:
		assert(not high_level_result, "Should not be able to start Ardougne course at low level")
		print("  ✓ Level requirement check working (cannot start Ardougne at level %d)" % current_level)
	else:
		print("  (Skipped - player is already level 90+)")
	
	# Test 7: Check all courses have proper data
	print("\nTest 7: Validating all course data...")
	for method in training_methods:
		assert(method.id != "", "Course should have an ID")
		assert(method.name != "", "Course should have a name")
		assert(method.xp_per_action > 0, "Course should give XP")
		assert(method.action_time > 0, "Course should have action time")
		assert(method.produced_items.has("marks_of_grace"), "Course should produce marks of grace")
		assert(method.success_rate > 0 and method.success_rate <= 1.0, "Course should have valid success rate")
	print("  ✓ All %d courses have valid data" % training_methods.size())
	
	print("\n=== ALL TESTS PASSED ===")
	print("Agility skill implementation is working correctly!\n")
	
	# Only quit if running in headless mode (automated tests)
	if DisplayServer.get_name() == "headless":
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
