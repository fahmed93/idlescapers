## Test script to verify action times update with upgrades
extends Node

func _ready() -> void:
	print("\n=== ACTION TIME UPGRADES TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check base action time without upgrades
	print("\nTest 1: Checking base action time...")
	var fishing_skill: SkillData = GameManager.skills.get("fishing")
	assert(fishing_skill != null, "Fishing skill should exist")
	
	var shrimp_method: TrainingMethodData = null
	for method in fishing_skill.training_methods:
		if method.id == "shrimp":
			shrimp_method = method
			break
	
	assert(shrimp_method != null, "Shrimp catching method should exist")
	var base_time := shrimp_method.action_time
	print("  Base action time: %.1fs" % base_time)
	
	# Get effective time without upgrades
	var effective_time_no_upgrade := shrimp_method.get_effective_action_time("fishing")
	print("  Effective time (no upgrades): %.1fs" % effective_time_no_upgrade)
	assert(abs(effective_time_no_upgrade - base_time) < 0.01, "Should match base time without upgrades")
	
	# Test 2: Purchase an upgrade and check modified time
	print("\nTest 2: Testing action time with upgrade...")
	Store.gold = 1000
	var purchase_result := UpgradeShop.purchase_upgrade("basic_fishing_rod")
	assert(purchase_result, "Should successfully purchase basic fishing rod")
	
	var speed_modifier := UpgradeShop.get_skill_speed_modifier("fishing")
	print("  Speed modifier: %.1f%%" % (speed_modifier * 100))
	assert(speed_modifier == 0.10, "Should have 10% speed bonus")
	
	var effective_time_with_upgrade := shrimp_method.get_effective_action_time("fishing")
	print("  Effective time (with upgrade): %.1fs" % effective_time_with_upgrade)
	
	var expected_time := base_time / (1.0 + speed_modifier)
	print("  Expected time: %.1fs" % expected_time)
	assert(abs(effective_time_with_upgrade - expected_time) < 0.01, "Should match expected reduced time")
	
	# Test 3: Check stats text includes modified time
	print("\nTest 3: Testing stats text with upgrade...")
	var stats_text := shrimp_method.get_stats_text("fishing")
	print("  Stats text: %s" % stats_text)
	assert(stats_text.contains(str(snapped(effective_time_with_upgrade, 0.1))), "Stats should show modified time")
	
	# Test 4: Purchase another upgrade and verify cumulative effect
	print("\nTest 4: Testing cumulative upgrades...")
	# Level up fishing to 20 to be able to purchase steel fishing rod
	GameManager.skill_levels["fishing"] = 20
	Store.gold = 5000
	var second_purchase := UpgradeShop.purchase_upgrade("steel_fishing_rod")
	assert(second_purchase, "Should successfully purchase steel fishing rod")
	
	speed_modifier = UpgradeShop.get_skill_speed_modifier("fishing")
	print("  Speed modifier (2 upgrades): %.1f%%" % (speed_modifier * 100))
	# 0.10 (basic rod) + 0.20 (steel rod) = 0.30 total
	var expected_modifier := 0.10 + 0.20
	assert(abs(speed_modifier - expected_modifier) < 0.001, "Should have 30% speed bonus from two upgrades")
	
	effective_time_with_upgrade = shrimp_method.get_effective_action_time("fishing")
	print("  Effective time (2 upgrades): %.1fs" % effective_time_with_upgrade)
	
	expected_time = base_time / (1.0 + speed_modifier)
	print("  Expected time: %.1fs" % expected_time)
	assert(abs(effective_time_with_upgrade - expected_time) < 0.01, "Should match expected reduced time with 2 upgrades")
	
	# Test 5: Verify XP per hour calculation uses effective time
	print("\nTest 5: Testing XP per hour calculation...")
	var base_xp_per_hour := (shrimp_method.xp_per_action * 3600.0) / base_time
	var effective_xp_per_hour := shrimp_method.get_xp_per_hour("fishing")
	print("  Base XP/hr: %.1f" % base_xp_per_hour)
	print("  Effective XP/hr: %.1f" % effective_xp_per_hour)
	
	var expected_xp_per_hour := (shrimp_method.xp_per_action * 3600.0) / effective_time_with_upgrade
	print("  Expected XP/hr: %.1f" % expected_xp_per_hour)
	assert(abs(effective_xp_per_hour - expected_xp_per_hour) < 0.1, "XP per hour should use effective time")
	
	# Test 6: Verify other skills are not affected
	print("\nTest 6: Testing skill isolation...")
	var woodcutting_skill: SkillData = GameManager.skills.get("woodcutting")
	assert(woodcutting_skill != null, "Woodcutting skill should exist")
	
	var logs_method: TrainingMethodData = null
	for method in woodcutting_skill.training_methods:
		if method.id == "normal_tree":
			logs_method = method
			break
	
	if logs_method:
		var wc_effective_time := logs_method.get_effective_action_time("woodcutting")
		var wc_base_time := logs_method.action_time
		print("  Woodcutting base time: %.1fs" % wc_base_time)
		print("  Woodcutting effective time: %.1fs" % wc_effective_time)
		assert(abs(wc_effective_time - wc_base_time) < 0.01, "Woodcutting should not be affected by fishing upgrades")
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Clean up
	UpgradeShop.clear_purchased()
	Store.gold = 0
	
	# Clean up save file
	if FileAccess.file_exists("user://skillforge_save.json"):
		DirAccess.remove_absolute("user://skillforge_save.json")
		print("Cleaned up test save file")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
