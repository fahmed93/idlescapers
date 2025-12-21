## Test script to verify all skills have 6-9 upgrades (including level 99 cape)
extends Node

func _ready() -> void:
	print("\n=== UPGRADES COUNT TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Get all skills from GameManager
	var skills := ["fishing", "woodcutting", "cooking", "fletching", "mining", 
		"firemaking", "herblore", "smithing", "thieving", "agility", 
		"astrology", "jewelcrafting", "skinning", "foraging", "crafting"]
	
	print("\nChecking upgrade counts for all skills...")
	print("-" * 50)
	
	var all_passed := true
	for skill_id in skills:
		var upgrades := UpgradeShop.get_upgrades_for_skill(skill_id)
		var count := upgrades.size()
		var status := "✓" if (count >= 6 and count <= 9) else "✗"
		
		var skill_name := skill_id.capitalize().rpad(15)
		print("%s %s: %d upgrades" % [status, skill_name, count])
		
		if count < 6:
			push_error("%s has too few upgrades: %d (minimum is 6)" % [skill_id, count])
			all_passed = false
		elif count > 9:
			push_error("%s has too many upgrades: %d (maximum is 9)" % [skill_id, count])
			all_passed = false
		
		# Verify each upgrade has correct properties
		for upgrade in upgrades:
			assert(upgrade.skill_id == skill_id, "Upgrade %s should be for skill %s" % [upgrade.id, skill_id])
			assert(upgrade.cost > 0, "Upgrade %s should have positive cost" % upgrade.id)
			assert(upgrade.speed_modifier > 0, "Upgrade %s should have positive speed modifier" % upgrade.id)
			assert(upgrade.level_required >= 1, "Upgrade %s should have valid level requirement" % upgrade.id)
		
		# Verify that each skill has exactly one level 99 cape
		var cape_count := 0
		for upgrade in upgrades:
			if upgrade.level_required == 99:
				cape_count += 1
		assert(cape_count == 1, "Skill %s should have exactly one level 99 cape" % skill_id)
	
	print("-" * 50)
	
	if all_passed:
		print("\n✓ ALL SKILLS HAVE 6-9 UPGRADES (INCLUDING LEVEL 99 CAPE)")
		print("=== ALL TESTS PASSED ===\n")
	else:
		push_error("\n✗ SOME SKILLS DO NOT MEET REQUIREMENTS")
		print("=== TESTS FAILED ===\n")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
