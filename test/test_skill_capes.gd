extends Node

## Test for level 99 skill capes
## Verifies that all 15 skills have a mastery cape available at level 99

func _ready() -> void:
	print("\n=== Testing Skill Capes ===\n")
	await get_tree().process_frame  # Wait for autoloads to initialize
	
	# Test that all 15 skills have a cape
	var expected_skills := [
		"fishing", "woodcutting", "mining", "cooking", "fletching",
		"firemaking", "smithing", "herblore", "thieving", "agility",
		"astrology", "jewelcrafting", "skinning", "foraging", "crafting"
	]
	
	for skill_id in expected_skills:
		_test_skill_cape(skill_id)
	
	print("\n=== All Skill Cape Tests Passed ✓ ===\n")
	get_tree().quit()

func _test_skill_cape(skill_id: String) -> void:
	print("Testing %s cape..." % skill_id)
	
	# Get all upgrades for this skill
	var skill_upgrades := UpgradeShop.get_upgrades_for_skill(skill_id)
	assert(skill_upgrades.size() > 0, "Skill %s should have at least one upgrade" % skill_id)
	
	# Find the cape (level 99 upgrade)
	var cape: UpgradeData = null
	for upgrade in skill_upgrades:
		if upgrade.level_required == 99:
			cape = upgrade
			break
	
	assert(cape != null, "Skill %s should have a level 99 cape" % skill_id)
	assert(cape.name.contains("Cape of Mastery"), "Cape should be named 'Cape of Mastery'")
	assert(cape.cost == 99000, "Cape should cost 99000 gold")
	assert(cape.speed_modifier == 1.0, "Cape should provide 100% (1.0) speed bonus")
	assert(cape.description.contains("doubling"), "Cape description should mention doubling speed")
	
	print("  ✓ %s has a %s" % [skill_id.capitalize(), cape.name])
	print("    - Level requirement: %d" % cape.level_required)
	print("    - Cost: %d gold" % cape.cost)
	print("    - Speed bonus: +%d%%" % int(cape.speed_modifier * 100))
	print("    - Description: %s" % cape.description)
