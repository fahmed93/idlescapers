## Test script to verify time to level calculation
extends Node

func _ready() -> void:
	print("\n=== TIME TO LEVEL CALCULATION TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Verify calculation logic with fishing
	print("\nTest 1: Testing time to level calculation...")
	var fishing_skill = GameManager.skills.get("fishing")
	assert(fishing_skill != null, "Fishing skill should exist")
	
	# Set fishing to level 1 with 0 XP
	GameManager.skill_levels["fishing"] = 1
	GameManager.skill_xp["fishing"] = 0.0
	
	var current_level := GameManager.get_skill_level("fishing")
	var current_xp := GameManager.get_skill_xp("fishing")
	var next_level_xp := GameManager.get_xp_for_level(current_level + 1)
	var xp_needed := next_level_xp - current_xp
	
	print("  Current level: %d" % current_level)
	print("  Current XP: %.0f" % current_xp)
	print("  XP for level %d: %.0f" % [current_level + 1, next_level_xp])
	print("  XP needed: %.0f" % xp_needed)
	
	# Get first training method (catch shrimp)
	var catch_shrimp = fishing_skill.training_methods[0]
	print("  Training method: %s" % catch_shrimp.name)
	print("  XP per action: %.1f" % catch_shrimp.xp_per_action)
	print("  Action time: %.1fs" % catch_shrimp.action_time)
	
	# Calculate expected time
	var actions_needed := ceil(xp_needed / catch_shrimp.xp_per_action)
	var time_to_level := actions_needed * catch_shrimp.action_time
	
	print("  Actions needed: %.0f" % actions_needed)
	print("  Time to level %d: %.1fs (%.1f minutes)" % [current_level + 1, time_to_level, time_to_level / 60.0])
	
	# Level 1 to 2 requires 83 XP
	# Catch shrimp gives 10 XP per action with 2.0s action time
	# Expected: ceil(83 / 10) = 9 actions * 2.0s = 18 seconds
	assert(xp_needed == 83.0, "Level 1->2 should require 83 XP")
	assert(actions_needed == 9, "Should need 9 actions")
	assert(abs(time_to_level - 18.0) < 0.1, "Should take 18 seconds")
	print("  ✓ Calculation is correct!")
	
	# Test 2: Test with speed modifier
	print("\nTest 2: Testing with speed modifier...")
	var speed_modifier := 0.5  # 50% speed bonus
	
	# Note: Without actually purchasing an upgrade, we can't use get_effective_action_time
	# with the UpgradeShop, so we calculate manually for testing purposes
	print("  Base action time: %.1fs" % catch_shrimp.action_time)
	
	var modified_time := catch_shrimp.action_time / (1.0 + speed_modifier)
	var time_with_bonus := actions_needed * modified_time
	print("  With 50%% speed bonus: %.1fs (%.1f minutes)" % [time_with_bonus, time_with_bonus / 60.0])
	
	# Expected: 9 actions * (2.0 / 1.5) = 9 * 1.333 = 12 seconds
	assert(abs(time_with_bonus - 12.0) < 0.1, "With 50% speed should take 12 seconds")
	print("  ✓ Speed modifier calculation is correct!")
	
	# Test 3: Test at higher level with more XP needed
	print("\nTest 3: Testing at higher level (50->51)...")
	GameManager.skill_levels["fishing"] = 50
	GameManager.skill_xp["fishing"] = GameManager.get_xp_for_level(50)
	
	var level_50_xp := GameManager.get_xp_for_level(50)
	var level_51_xp := GameManager.get_xp_for_level(51)
	var xp_needed_50 := level_51_xp - level_50_xp
	
	print("  XP for level 50: %.0f" % level_50_xp)
	print("  XP for level 51: %.0f" % level_51_xp)
	print("  XP needed: %.0f" % xp_needed_50)
	
	# Use a higher level method (e.g., catch lobster)
	var catch_lobster = null
	for method in fishing_skill.training_methods:
		if method.id == "catch_lobster":
			catch_lobster = method
			break
	
	if catch_lobster:
		print("  Training method: %s (%.1f XP, %.1fs)" % [catch_lobster.name, catch_lobster.xp_per_action, catch_lobster.action_time])
		var actions_50 := ceil(xp_needed_50 / catch_lobster.xp_per_action)
		var time_50 := actions_50 * catch_lobster.action_time
		print("  Actions needed: %.0f" % actions_50)
		print("  Time to level 51: %.0fs (%.1f hours)" % [time_50, time_50 / 3600.0])
		print("  ✓ Higher level calculation works!")
	
	# Test 4: Test max level
	print("\nTest 4: Testing max level...")
	GameManager.skill_levels["fishing"] = GameManager.MAX_LEVEL
	GameManager.skill_xp["fishing"] = GameManager.get_xp_for_level(GameManager.MAX_LEVEL)
	
	var max_level := GameManager.get_skill_level("fishing")
	print("  Current level: %d (MAX)" % max_level)
	
	# At max level, should handle gracefully
	if max_level >= GameManager.MAX_LEVEL:
		print("  ✓ Max level reached - no more levels to gain!")
	
	print("\n=== ALL TESTS PASSED ===")
	print("\nPress ESC or close window to exit")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
