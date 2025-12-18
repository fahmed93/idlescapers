extends Node

## Manual test to verify the change character button exists and is properly configured

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	
	print("\n=== Testing Change Character Button ===\n")
	
	# Load the main scene
	var main_scene := load("res://scenes/main.tscn")
	assert(main_scene != null, "Main scene should load successfully")
	print("  ✓ Main scene loaded successfully")
	
	# Instantiate the scene
	var main_instance := main_scene.instantiate()
	assert(main_instance != null, "Main scene should instantiate")
	print("  ✓ Main scene instantiated")
	
	# Look for the change character button
	var change_character_button := main_instance.get_node_or_null("ChangeCharacterButton")
	assert(change_character_button != null, "ChangeCharacterButton should exist in main scene")
	print("  ✓ ChangeCharacterButton node exists")
	
	# Verify it's a Button
	assert(change_character_button is Button, "ChangeCharacterButton should be a Button")
	print("  ✓ ChangeCharacterButton is a Button")
	
	# Verify button properties
	assert(change_character_button.text == "Change Character", "Button text should be 'Change Character'")
	print("  ✓ Button text is correct: '%s'" % change_character_button.text)
	
	# Verify button positioning (should be anchored to top-right)
	assert(change_character_button.anchor_left == 1.0, "Button should be anchored to right (anchor_left = 1.0)")
	assert(change_character_button.anchor_right == 1.0, "Button should be anchored to right (anchor_right = 1.0)")
	print("  ✓ Button is anchored to top-right corner")
	
	# Verify custom minimum size
	var expected_size := Vector2(120, 40)
	assert(change_character_button.custom_minimum_size == expected_size, "Button size should be 120x40")
	print("  ✓ Button size is correct: %s" % str(change_character_button.custom_minimum_size))
	
	# Clean up
	main_instance.queue_free()
	
	print("\n=== All Change Character Button Tests Passed! ===\n")
	get_tree().quit()
