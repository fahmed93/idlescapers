extends Node

## Test that skill icons are loaded correctly

func _ready() -> void:
	print("\n=== SKILL ICONS TEST ===\n")
	
	# Wait for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check all skills have icons loaded
	print("Test 1: Checking all skills have icons loaded...")
	var all_skills_have_icons := true
	for skill_id in GameManager.skills:
		var skill: SkillData = GameManager.skills[skill_id]
		if skill.icon == null:
			print("  ✗ %s missing icon!" % skill.name)
			all_skills_have_icons = false
		else:
			print("  ✓ %s has icon (size: %dx%d)" % [skill.name, skill.icon.get_width(), skill.icon.get_height()])
	
	assert(all_skills_have_icons, "All skills should have icons loaded")
	
	# Test 2: Verify icon properties for all skills
	print("\nTest 2: Verifying icon dimensions for all skills...")
	for skill_id in GameManager.skills:
		var skill: SkillData = GameManager.skills[skill_id]
		assert(skill.icon != null, "%s should have an icon" % skill.name)
		assert(skill.icon.get_width() == 64, "%s icon width should be 64px" % skill.name)
		assert(skill.icon.get_height() == 64, "%s icon height should be 64px" % skill.name)
	print("  ✓ All skill icon dimensions are correct (64x64)")
	
	# Test 3: Check icon files exist for all skills
	print("\nTest 3: Checking icon files exist...")
	var expected_skills := ["fishing", "woodcutting", "cooking", "fletching", "mining", 
							"firemaking", "herblore", "smithing", "thieving", "agility",
							"astrology", "jewelcrafting", "skinning", "foraging", "crafting"]
	
	for skill_id in expected_skills:
		var skill: SkillData = GameManager.skills.get(skill_id)
		assert(skill != null, "Skill %s should exist" % skill_id)
		assert(skill.icon != null, "Skill %s should have an icon" % skill_id)
		print("  ✓ %s icon verified" % skill_id)
	
	print("\n=== ALL TESTS PASSED ===")
	print("All 15 skills have icons loaded correctly!\n")
	
	get_tree().quit()
