## Test script to verify all skills have 5-8 upgrades
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
		var status := "✓" if (count >= 5 and count <= 8) else "✗"
		
		print("%s %s: %d upgrades" % [status, skill_id.capitalize().pad_to_width(15), count])
		
		if count < 5:
			push_error("%s has too few upgrades: %d (minimum is 5)" % [skill_id, count])
			all_passed = false
		elif count > 8:
			push_error("%s has too many upgrades: %d (maximum is 8)" % [skill_id, count])
			all_passed = false
		
		# Verify each upgrade has correct properties
		for upgrade in upgrades:
			assert(upgrade.skill_id == skill_id, "Upgrade %s should be for skill %s" % [upgrade.id, skill_id])
			assert(upgrade.cost > 0, "Upgrade %s should have positive cost" % upgrade.id)
			assert(upgrade.speed_modifier > 0, "Upgrade %s should have positive speed modifier" % upgrade.id)
			assert(upgrade.level_required >= 1, "Upgrade %s should have valid level requirement" % upgrade.id)
	
	print("-" * 50)
	
	if all_passed:
		print("\n✓ ALL SKILLS HAVE 5-8 UPGRADES")
		print("=== ALL TESTS PASSED ===\n")
	else:
		push_error("\n✗ SOME SKILLS DO NOT MEET REQUIREMENTS")
		print("=== TESTS FAILED ===\n")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
