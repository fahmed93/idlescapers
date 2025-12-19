## Test script for time to level calculation
extends Node

func _ready() -> void:
	print("=== Time to Level Calculation Tests ===")
	
	# Wait for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Verify GameManager has the function
	print("\n[Test 1] Verify get_time_to_next_level() function exists")
	assert(GameManager.has_method("get_time_to_next_level"), "GameManager should have get_time_to_next_level() method")
	print("  ✓ Function exists")
	
	# Test 2: Returns -1 when not training
	print("\n[Test 2] Returns -1 when not training")
	var time_not_training := GameManager.get_time_to_next_level()
	assert(time_not_training == -1.0, "Should return -1 when not training")
	print("  ✓ Returns -1 when not training: ", time_not_training)
	
	# Test 3: Start training and check calculation
	print("\n[Test 3] Calculate time to level while training")
	
	# Reset fishing skill to level 1 with 0 XP
	GameManager.skill_xp["fishing"] = 0.0
	GameManager.skill_levels["fishing"] = 1
	
	# Start training fishing with shrimp (10 XP per action, 3s per action)
	var started := GameManager.start_training("fishing", "catch_shrimp")
	assert(started, "Should successfully start training")
	print("  ✓ Started training fishing")
	
	# Get time to level 2
	var time_to_level := GameManager.get_time_to_next_level()
	
	# At level 1, need 83 XP to reach level 2
	# Shrimp gives 10 XP per action, takes 3 seconds
	# Expected: ceil(83 / 10) = 9 actions * 3s = 27s
	# But with success rate, it's exactly: 83 / 10 * 3 = 24.9s
	var expected_time := 24.9  # (83 XP needed / 10 XP per action) * 3s per action
	
	print("  Time to level 2: %.1fs (expected ~%.1fs)" % [time_to_level, expected_time])
	assert(abs(time_to_level - expected_time) < 1.0, "Time calculation should be approximately correct")
	print("  ✓ Time to level calculated correctly")
	
	# Test 4: Time to level at higher level
	print("\n[Test 4] Calculate time to level at higher level")
	
	# Set fishing to level 30 (need 13,363 XP)
	# Put player at 13,363 XP (exactly level 30)
	GameManager.skill_xp["fishing"] = 13363.0
	GameManager.skill_levels["fishing"] = 30
	
	# Stop and restart training to update
	GameManager.stop_training()
	await get_tree().process_frame
	GameManager.start_training("fishing", "catch_salmon")  # 70 XP, 5s
	
	var time_to_31 := GameManager.get_time_to_next_level()
	
	# From level 30 to 31: need 368 XP (13,731 - 13,363)
	# Salmon gives 70 XP per action, takes 5 seconds
	# Expected: 368 / 70 * 5 = 26.29s
	var expected_time_31 := 26.28571  # (368 XP / 70 XP per action) * 5s
	
	print("  Time to level 31: %.1fs (expected ~%.1fs)" % [time_to_31, expected_time_31])
	assert(abs(time_to_31 - expected_time_31) < 1.0, "Time calculation at level 30 should be correct")
	print("  ✓ Time to level at higher level calculated correctly")
	
	# Test 5: Max level returns -1
	print("\n[Test 5] Max level returns -1")
	GameManager.skill_xp["fishing"] = 13034431.0  # Level 99
	GameManager.skill_levels["fishing"] = 99
	
	GameManager.stop_training()
	await get_tree().process_frame
	GameManager.start_training("fishing", "catch_shrimp")
	
	var time_at_max := GameManager.get_time_to_next_level()
	assert(time_at_max == -1.0, "Should return -1 at max level")
	print("  ✓ Returns -1 at max level: ", time_at_max)
	
	# Clean up
	GameManager.stop_training()
	GameManager.skill_xp["fishing"] = 0.0
	GameManager.skill_levels["fishing"] = 1
	
	print("\n=== All Time to Level Tests Passed ===")
	
	# Exit after a short delay
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
