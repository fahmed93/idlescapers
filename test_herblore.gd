## Test script to verify Herblore skill functionality
extends Node

func _ready() -> void:
	print("\n=== HERBLORE SKILL TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that Herblore skill is registered
	print("\nTest 1: Checking Herblore skill is registered...")
	var herblore_skill = GameManager.skills.get("herblore")
	assert(herblore_skill != null, "Herblore skill should be registered")
	print("  ✓ Herblore skill found: %s" % herblore_skill.name)
	print("    Description: %s" % herblore_skill.description)
	print("    Color: %s" % herblore_skill.color)
	
	# Test 2: Check training methods are loaded
	print("\nTest 2: Checking Herblore training methods...")
	var training_methods = herblore_skill.training_methods
	print("  Training methods count: %d" % training_methods.size())
	assert(training_methods.size() > 0, "Herblore should have training methods")
	
	# List all methods
	for method in training_methods:
		print("    - Lv %d: %s (%.1f XP, %.1fs)" % [method.level_required, method.name, method.xp_per_action, method.action_time])
	
	# Test 3: Check specific potions
	print("\nTest 3: Verifying specific potions...")
	var attack_potion = null
	var prayer_potion = null
	var overload = null
	
	for method in training_methods:
		if method.id == "attack_potion":
			attack_potion = method
		elif method.id == "prayer_potion":
			prayer_potion = method
		elif method.id == "overload":
			overload = method
	
	assert(attack_potion != null, "Attack Potion should exist")
	assert(attack_potion.level_required == 1, "Attack Potion should require level 1")
	print("  ✓ Attack Potion: Level %d, %.1f XP" % [attack_potion.level_required, attack_potion.xp_per_action])
	
	assert(prayer_potion != null, "Prayer Potion should exist")
	assert(prayer_potion.level_required == 38, "Prayer Potion should require level 38")
	print("  ✓ Prayer Potion: Level %d, %.1f XP" % [prayer_potion.level_required, prayer_potion.xp_per_action])
	
	assert(overload != null, "Overload should exist")
	assert(overload.level_required == 90, "Overload should require level 90")
	print("  ✓ Overload: Level %d, %.1f XP" % [overload.level_required, overload.xp_per_action])
	
	# Test 4: Check herb items
	print("\nTest 4: Checking herb items...")
	var guam_leaf = Inventory.get_item_data("guam_leaf")
	var ranarr_weed = Inventory.get_item_data("ranarr_weed")
	var torstol = Inventory.get_item_data("torstol")
	
	assert(guam_leaf != null, "Guam Leaf should be registered")
	print("  ✓ Guam Leaf: %s" % guam_leaf.description)
	
	assert(ranarr_weed != null, "Ranarr Weed should be registered")
	print("  ✓ Ranarr Weed: %s" % ranarr_weed.description)
	
	assert(torstol != null, "Torstol should be registered")
	print("  ✓ Torstol: %s" % torstol.description)
	
	# Test 5: Check secondary ingredients
	print("\nTest 5: Checking secondary ingredients...")
	var eye_of_newt = Inventory.get_item_data("eye_of_newt")
	var dragon_scale_dust = Inventory.get_item_data("dragon_scale_dust")
	
	assert(eye_of_newt != null, "Eye of Newt should be registered")
	print("  ✓ Eye of Newt: %s" % eye_of_newt.description)
	
	assert(dragon_scale_dust != null, "Dragon Scale Dust should be registered")
	print("  ✓ Dragon Scale Dust: %s" % dragon_scale_dust.description)
	
	# Test 6: Check finished potion items
	print("\nTest 6: Checking potion items...")
	var attack_pot_item = Inventory.get_item_data("attack_potion")
	var prayer_pot_item = Inventory.get_item_data("prayer_potion")
	var overload_item = Inventory.get_item_data("overload")
	
	assert(attack_pot_item != null, "Attack Potion item should be registered")
	assert(attack_pot_item.type == ItemData.ItemType.CONSUMABLE, "Attack Potion should be consumable")
	print("  ✓ Attack Potion: %s (value: %d)" % [attack_pot_item.description, attack_pot_item.value])
	
	assert(prayer_pot_item != null, "Prayer Potion item should be registered")
	print("  ✓ Prayer Potion: %s (value: %d)" % [prayer_pot_item.description, prayer_pot_item.value])
	
	assert(overload_item != null, "Overload item should be registered")
	print("  ✓ Overload: %s (value: %d)" % [overload_item.description, overload_item.value])
	
	# Test 7: Test brewing simulation (with items)
	print("\nTest 7: Testing brewing simulation...")
	Inventory.add_item("guam_leaf", 10)
	Inventory.add_item("eye_of_newt", 10)
	
	var initial_level = GameManager.get_skill_level("herblore")
	print("  Initial Herblore level: %d" % initial_level)
	print("  Starting training: Attack Potion")
	
	var start_result = GameManager.start_training("herblore", "attack_potion")
	assert(start_result, "Should be able to start brewing Attack Potion")
	print("  ✓ Training started successfully")
	
	# Wait for one action to complete
	await get_tree().create_timer(2.5).timeout
	
	var potion_count = Inventory.get_item_count("attack_potion")
	print("  Attack Potions created: %d" % potion_count)
	assert(potion_count > 0, "Should have created at least one Attack Potion")
	
	var current_xp = GameManager.get_skill_xp("herblore")
	print("  Current Herblore XP: %.1f" % current_xp)
	assert(current_xp > 0, "Should have gained some XP")
	
	GameManager.stop_training()
	print("  ✓ Training stopped")
	
	print("\n=== ALL TESTS PASSED ===")
	print("Herblore skill implementation is working correctly!\n")
	
	# Quit after tests
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
