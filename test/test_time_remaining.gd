## Test script to verify time remaining calculation for item consumption
extends Node

func _ready() -> void:
	print("\n=== TIME REMAINING CALCULATION TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Format time remaining function
	print("\nTest 1: Testing time formatting...")
	var time_30s := TrainingMethodData.format_time_remaining(30.0)
	assert(time_30s == "30s left", "30 seconds should format as '30s left'")
	print("  ✓ 30s formats as: %s" % time_30s)
	
	var time_90s := TrainingMethodData.format_time_remaining(90.0)
	assert(time_90s == "1m 30s left", "90 seconds should format as '1m 30s left'")
	print("  ✓ 90s formats as: %s" % time_90s)
	
	var time_3700s := TrainingMethodData.format_time_remaining(3700.0)
	assert(time_3700s == "1h 1m left", "3700 seconds should format as '1h 1m left'")
	print("  ✓ 3700s formats as: %s" % time_3700s)
	
	var time_neg := TrainingMethodData.format_time_remaining(-1.0)
	assert(time_neg == "", "Negative time should return empty string")
	print("  ✓ Negative time returns empty string")
	
	# Test 2: Calculate time until out of items
	print("\nTest 2: Testing time calculation with cooking...")
	var cooking_skill = GameManager.skills.get("cooking")
	assert(cooking_skill != null, "Cooking skill should exist")
	
	# Find cook_shrimp method
	var cook_shrimp = null
	for method in cooking_skill.training_methods:
		if method.id == "cook_shrimp":
			cook_shrimp = method
			break
	
	assert(cook_shrimp != null, "Cook shrimp method should exist")
	print("  Found method: %s" % cook_shrimp.name)
	print("    Consumes: %s" % cook_shrimp.consumed_items)
	print("    Action time: %.1fs" % cook_shrimp.action_time)
	
	# Clear inventory and add test items
	Inventory.clear_inventory()
	Inventory.add_item("raw_shrimp", 100)
	
	var available := Inventory.get_item_count("raw_shrimp")
	print("    Available raw shrimp: %d" % available)
	
	# Calculate time with no speed modifier
	var time_no_speed := cook_shrimp.calculate_time_until_out_of_items(0.0)
	print("  ✓ Time with no speed modifier: %.1fs (%.1f minutes)" % [time_no_speed, time_no_speed / 60.0])
	
	# Expected: 100 shrimp * 2.0 seconds per action = 200 seconds
	assert(abs(time_no_speed - 200.0) < 0.1, "Should be 200 seconds for 100 shrimp at 2s per action")
	
	# Calculate time with 50% speed bonus
	var time_with_speed := cook_shrimp.calculate_time_until_out_of_items(0.5)
	print("  ✓ Time with 50%% speed bonus: %.1fs (%.1f minutes)" % [time_with_speed, time_with_speed / 60.0])
	
	# Expected: 100 shrimp * (2.0 / 1.5) seconds per action ≈ 133.3 seconds
	var expected_with_speed := 200.0 / 1.5
	assert(abs(time_with_speed - expected_with_speed) < 0.1, "Should be ~133.3 seconds with 50%% speed bonus")
	
	# Test 3: Test with zero items
	print("\nTest 3: Testing with zero items...")
	Inventory.clear_inventory()
	var time_zero := cook_shrimp.calculate_time_until_out_of_items(0.0)
	print("  ✓ Time with 0 items: %.1fs" % time_zero)
	assert(time_zero == 0.0, "Should return 0 when no items available")
	
	# Test 4: Test with method that doesn't consume items
	print("\nTest 4: Testing method without consumed items...")
	var fishing_skill = GameManager.skills.get("fishing")
	var catch_shrimp = null
	for method in fishing_skill.training_methods:
		if method.id == "catch_shrimp":
			catch_shrimp = method
			break
	
	assert(catch_shrimp != null, "Catch shrimp method should exist")
	var time_no_consume := catch_shrimp.calculate_time_until_out_of_items(0.0)
	print("  ✓ Time for non-consuming method: %.1f" % time_no_consume)
	assert(time_no_consume == -1.0, "Should return -1 for methods that don't consume items")
	
	# Test 5: Test with multiple consumed items (herblore)
	print("\nTest 5: Testing method with multiple consumed items...")
	var herblore_skill = GameManager.skills.get("herblore")
	if herblore_skill:
		var attack_potion = null
		for method in herblore_skill.training_methods:
			if method.id == "attack_potion":
				attack_potion = method
				break
		
		if attack_potion:
			print("  Found method: %s" % attack_potion.name)
			print("    Consumes: %s" % attack_potion.consumed_items)
			
			# Clear inventory and add ingredients
			Inventory.clear_inventory()
			Inventory.add_item("guam_leaf", 50)
			Inventory.add_item("eye_of_newt", 100)
			
			var time_multi := attack_potion.calculate_time_until_out_of_items(0.0)
			print("  ✓ Time with multiple items (50 guam, 100 eye_of_newt): %.1fs" % time_multi)
			print("    Formatted: %s" % TrainingMethodData.format_time_remaining(time_multi))
			
			# The bottleneck should be guam_leaf (50 actions possible)
			# Expected: 50 * action_time
			var expected_multi := 50.0 * attack_potion.action_time
			assert(abs(time_multi - expected_multi) < 0.1, "Should use the bottleneck item (guam_leaf)")
	
	print("\n=== ALL TESTS PASSED ===")
	print("\nPress ESC or close window to exit")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
