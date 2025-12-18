## Test to verify fishing training methods are in ascending level order
extends Node

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads to initialize
	
	print("Testing fishing skill training methods order...")
	
	var skill = GameManager.skills.get("fishing")
	assert(skill != null, "Fishing skill should be registered")
	
	var methods = skill.training_methods
	assert(methods.size() == 20, "Fishing should have 20 training methods")
	
	# Check that methods are in ascending level order
	var previous_level := 0
	for i in range(methods.size()):
		var method = methods[i]
		print("  %d. %s (Level %d)" % [i + 1, method.name, method.level_required])
		
		assert(method.level_required > previous_level, 
			"Method '%s' (level %d) should have a higher level requirement than previous method (level %d)" % 
			[method.name, method.level_required, previous_level])
		
		previous_level = method.level_required
	
	# Verify expected order
	var expected_levels := [1, 3, 5, 8, 10, 13, 18, 20, 25, 30, 35, 40, 50, 55, 62, 68, 76, 82, 85, 92]
	for i in range(methods.size()):
		assert(methods[i].level_required == expected_levels[i],
			"Method at index %d should have level %d, but has level %d" % 
			[i, expected_levels[i], methods[i].level_required])
	
	print("  ✓ All fishing training methods are in correct ascending level order!")
	print("  ✓ Test passed successfully!")
	
	get_tree().quit()
