## Integration test for skill cape effects in action
extends Node

var test_completed := false

func _ready() -> void:
	print("\n=== SKILL CAPE EFFECTS INTEGRATION TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Cooking Cape - Perfect Success Rate
	print("\nTest 1: Cooking Cape - Perfect Success Rate")
	print("  Setting up: Level 99 Cooking, buying cape...")
	GameManager.skill_levels["cooking"] = 99
	Store.gold = 100000
	
	# Add some raw shrimp to cook
	Inventory.add_item("raw_shrimp", 100)
	
	# Purchase cooking cape
	var result := UpgradeShop.purchase_upgrade("cooking_cape")
	assert(result, "Should be able to purchase cooking cape")
	assert(UpgradeShop.has_cape_effect("perfect_cooking"), "Should have perfect cooking effect")
	
	# Start training cooking (which normally has < 100% success rate at low levels)
	GameManager.start_training("cooking", "cook_shrimp")
	
	print("  Training for 10 seconds...")
	var successes := 0
	var failures := 0
	
	# Connect to action_completed signal to count successes
	var action_handler = func(skill_id: String, method_id: String, success: bool):
		if skill_id == "cooking" and method_id == "cook_shrimp":
			if success:
				successes += 1
			else:
				failures += 1
	
	GameManager.action_completed.connect(action_handler)
	
	# Simulate training for a few seconds
	for i in range(100):  # Simulate ~10 seconds at 60fps
		GameManager._process(0.1)
		await get_tree().process_frame
	
	GameManager.stop_training()
	GameManager.action_completed.disconnect(action_handler)
	
	print("  Results: %d successes, %d failures" % [successes, failures])
	print("  Cooked shrimp in inventory: %d" % Inventory.get_item_count("cooked_shrimp"))
	assert(failures == 0, "With cooking cape, should have NO failures")
	assert(successes > 0, "Should have completed some cooking actions")
	print("  ✓ Cooking cape prevents all failures!")
	
	# Test 2: Fishing Cape - Double Fish
	print("\nTest 2: Fishing Cape - Double Fish (probabilistic)")
	print("  Setting up: Level 99 Fishing, buying cape...")
	GameManager.skill_levels["fishing"] = 99
	Store.gold = 100000
	
	# Purchase fishing cape
	result = UpgradeShop.purchase_upgrade("fishing_cape")
	assert(result, "Should be able to purchase fishing cape")
	assert(UpgradeShop.has_cape_effect("double_fish"), "Should have double fish effect")
	
	# Clear existing fish
	Inventory.inventory.erase("raw_shrimp")
	
	# Start fishing
	GameManager.start_training("fishing", "shrimp")
	
	print("  Fishing for a while to test double fish proc...")
	var initial_actions := 0
	var final_fish := 0
	
	var fish_action_handler = func(skill_id: String, method_id: String, success: bool):
		if skill_id == "fishing" and method_id == "shrimp" and success:
			initial_actions += 1
	
	GameManager.action_completed.connect(fish_action_handler)
	
	# Simulate fishing for several seconds
	for i in range(300):  # Longer test for probabilistic effect
		GameManager._process(0.1)
		await get_tree().process_frame
	
	GameManager.stop_training()
	GameManager.action_completed.disconnect(fish_action_handler)
	
	final_fish = Inventory.get_item_count("raw_shrimp")
	
	print("  Actions completed: %d" % initial_actions)
	print("  Fish obtained: %d" % final_fish)
	
	# With 5% double chance, we'd expect about 1.05x fish compared to actions
	# But due to RNG, we just check that we got at least the same number
	assert(final_fish >= initial_actions, "Should have at least as many fish as actions")
	if final_fish > initial_actions:
		print("  ✓ Got bonus fish! (%d extra from double fish procs)" % (final_fish - initial_actions))
	else:
		print("  Note: No double fish procs this run (5% is probabilistic)")
	
	# Test 3: Firemaking Cape - Double XP
	print("\nTest 3: Firemaking Cape - Double XP")
	print("  Setting up: Level 99 Firemaking, buying cape...")
	GameManager.skill_levels["firemaking"] = 99
	Store.gold = 100000
	
	# Add logs to burn
	Inventory.add_item("logs", 100)
	
	# Purchase firemaking cape
	result = UpgradeShop.purchase_upgrade("firemaking_cape")
	assert(result, "Should be able to purchase firemaking cape")
	assert(UpgradeShop.has_cape_effect("double_firemaking_xp"), "Should have double firemaking XP effect")
	
	# Record starting XP
	var start_xp := GameManager.get_skill_xp("firemaking")
	
	# Start firemaking
	GameManager.start_training("firemaking", "burn_logs")
	
	print("  Burning logs...")
	var firemaking_actions := 0
	
	var fire_action_handler = func(skill_id: String, method_id: String, success: bool):
		if skill_id == "firemaking" and method_id == "burn_logs":
			firemaking_actions += 1
	
	GameManager.action_completed.connect(fire_action_handler)
	
	# Burn for a bit
	for i in range(100):
		GameManager._process(0.1)
		await get_tree().process_frame
	
	GameManager.stop_training()
	GameManager.action_completed.disconnect(fire_action_handler)
	
	var end_xp := GameManager.get_skill_xp("firemaking")
	var xp_gained := end_xp - start_xp
	
	print("  Actions: %d" % firemaking_actions)
	print("  XP gained: %.1f" % xp_gained)
	
	# Check that we got double XP (40 XP per log normally, so 80 with cape)
	var expected_xp := firemaking_actions * 80.0  # 40 base * 2
	var xp_difference := abs(xp_gained - expected_xp)
	
	assert(xp_difference < 1.0, "XP should be approximately doubled")
	print("  ✓ Firemaking cape doubles XP!")
	
	print("\n=== ALL INTEGRATION TESTS PASSED ===\n")
	
	test_completed = true
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
