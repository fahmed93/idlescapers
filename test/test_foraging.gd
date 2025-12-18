## Test script to verify Foraging skill functionality
extends Node

func _ready() -> void:
	print("\n=== FORAGING SKILL TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that Foraging skill is registered
	print("\nTest 1: Checking Foraging skill is registered...")
	var foraging_skill = GameManager.skills.get("foraging")
	assert(foraging_skill != null, "Foraging skill should be registered")
	print("  ✓ Foraging skill found: %s" % foraging_skill.name)
	print("    Description: %s" % foraging_skill.description)
	print("    Color: %s" % foraging_skill.color)
	
	# Test 2: Check training methods are loaded
	print("\nTest 2: Checking Foraging training methods...")
	var training_methods = foraging_skill.training_methods
	print("  Training methods count: %d" % training_methods.size())
	assert(training_methods.size() > 0, "Foraging should have training methods")
	assert(training_methods.size() == 14, "Foraging should have 14 training methods (all herbs)")
	
	# List all methods
	for method in training_methods:
		print("    - Lv %d: %s (%.1f XP, %.1fs)" % [method.level_required, method.name, method.xp_per_action, method.action_time])
	
	# Test 3: Check specific foraging methods
	print("\nTest 3: Verifying specific foraging methods...")
	var dirty_guam = null
	var dirty_ranarr = null
	var dirty_torstol = null
	
	for method in training_methods:
		if method.id == "dirty_guam":
			dirty_guam = method
		elif method.id == "dirty_ranarr":
			dirty_ranarr = method
		elif method.id == "dirty_torstol":
			dirty_torstol = method
	
	assert(dirty_guam != null, "Dirty Guam foraging should exist")
	assert(dirty_guam.level_required == 1, "Dirty Guam should require level 1")
	print("  ✓ Dirty Guam: Level %d, %.1f XP" % [dirty_guam.level_required, dirty_guam.xp_per_action])
	
	assert(dirty_ranarr != null, "Dirty Ranarr foraging should exist")
	assert(dirty_ranarr.level_required == 25, "Dirty Ranarr should require level 25")
	print("  ✓ Dirty Ranarr: Level %d, %.1f XP" % [dirty_ranarr.level_required, dirty_ranarr.xp_per_action])
	
	assert(dirty_torstol != null, "Dirty Torstol foraging should exist")
	assert(dirty_torstol.level_required == 75, "Dirty Torstol should require level 75")
	print("  ✓ Dirty Torstol: Level %d, %.1f XP" % [dirty_torstol.level_required, dirty_torstol.xp_per_action])
	
	# Test 4: Check dirty herb items
	print("\nTest 4: Checking dirty herb items...")
	var dirty_guam_item = Inventory.get_item_data("dirty_guam_leaf")
	var dirty_ranarr_item = Inventory.get_item_data("dirty_ranarr_weed")
	var dirty_torstol_item = Inventory.get_item_data("dirty_torstol")
	
	assert(dirty_guam_item != null, "Dirty Guam Leaf should be registered")
	print("  ✓ Dirty Guam Leaf: %s" % dirty_guam_item.description)
	
	assert(dirty_ranarr_item != null, "Dirty Ranarr Weed should be registered")
	print("  ✓ Dirty Ranarr Weed: %s" % dirty_ranarr_item.description)
	
	assert(dirty_torstol_item != null, "Dirty Torstol should be registered")
	print("  ✓ Dirty Torstol: %s" % dirty_torstol_item.description)
	
	# Test 5: Verify all 14 dirty herbs are registered
	print("\nTest 5: Verifying all dirty herb items...")
	var dirty_herbs = [
		"dirty_guam_leaf",
		"dirty_marrentill",
		"dirty_tarromin",
		"dirty_harralander",
		"dirty_ranarr_weed",
		"dirty_toadflax",
		"dirty_irit_leaf",
		"dirty_avantoe",
		"dirty_kwuarm",
		"dirty_snapdragon",
		"dirty_cadantine",
		"dirty_lantadyme",
		"dirty_dwarf_weed",
		"dirty_torstol"
	]
	
	for herb_id in dirty_herbs:
		var item = Inventory.get_item_data(herb_id)
		assert(item != null, "Item %s should be registered" % herb_id)
		assert(item.type == ItemData.ItemType.RAW_MATERIAL, "Item %s should be RAW_MATERIAL" % herb_id)
	print("  ✓ All 14 dirty herb items registered correctly")
	
	# Test 6: Test foraging simulation (with items)
	print("\nTest 6: Testing foraging simulation...")
	
	var initial_level = GameManager.get_skill_level("foraging")
	print("  Initial Foraging level: %d" % initial_level)
	print("  Starting training: Dirty Guam Leaf")
	
	var start_result = GameManager.start_training("foraging", "dirty_guam")
	assert(start_result, "Should be able to start foraging Dirty Guam")
	print("  ✓ Training started successfully")
	
	# Wait for one action to complete
	await get_tree().create_timer(3.0).timeout
	
	var herb_count = Inventory.get_item_count("dirty_guam_leaf")
	print("  Dirty Guam Leaves gathered: %d" % herb_count)
	assert(herb_count > 0, "Should have gathered at least one Dirty Guam Leaf")
	
	var current_xp = GameManager.get_skill_xp("foraging")
	print("  Current Foraging XP: %.1f" % current_xp)
	assert(current_xp > 0, "Should have gained some XP")
	
	GameManager.stop_training()
	print("  ✓ Training stopped")
	
	# Test 7: Verify foraging methods produce correct items
	print("\nTest 7: Verifying produced items...")
	for method in training_methods:
		assert(method.produced_items.size() == 1, "Each foraging method should produce exactly 1 item")
		var produced_item_id = method.produced_items.keys()[0]
		assert(produced_item_id.begins_with("dirty_"), "Produced items should be dirty herbs")
		print("  ✓ %s produces %s" % [method.name, produced_item_id])
	
	print("\n=== ALL TESTS PASSED ===")
	print("Foraging skill implementation is working correctly!\n")
	
	# Only quit if running in headless mode (automated tests)
	if DisplayServer.get_name() == "headless":
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
