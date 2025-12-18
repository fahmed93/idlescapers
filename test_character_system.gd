## Test script for character management system
extends Node

func _ready() -> void:
	print("\n=== Testing Character Management System ===\n")
	
	# Test 1: Create characters
	print("Test 1: Creating characters...")
	var success1 := CharacterManager.create_character(0, "Hero One")
	var success2 := CharacterManager.create_character(1, "Hero Two")
	var success3 := CharacterManager.create_character(2, "Hero Three")
	
	print("Created 3 characters: %s, %s, %s" % [success1, success2, success3])
	assert(success1 and success2 and success3, "All character creations should succeed")
	
	# Test 2: Try to create 4th character (should fail)
	print("\nTest 2: Trying to create 4th character (should fail)...")
	var success4 := CharacterManager.create_character(0, "Hero Four")
	print("Creating 4th character in occupied slot: %s (expected: false)" % success4)
	assert(not success4, "Should not be able to create character in occupied slot")
	
	# Test 3: Get character count
	print("\nTest 3: Checking character count...")
	var count := CharacterManager.get_character_count()
	print("Character count: %d (expected: 3)" % count)
	assert(count == 3, "Should have 3 characters")
	
	# Test 4: Select and load character
	print("\nTest 4: Selecting character 1...")
	var select_success := CharacterManager.select_character(1)
	print("Selected character 1: %s" % select_success)
	assert(select_success, "Should be able to select character 1")
	
	var current_slot := CharacterManager.current_slot
	print("Current slot: %d (expected: 1)" % current_slot)
	assert(current_slot == 1, "Current slot should be 1")
	
	# Test 5: Get save file path
	print("\nTest 5: Getting save file path...")
	var save_path := CharacterManager.get_current_save_file()
	print("Save file path: %s" % save_path)
	assert(save_path.contains("slot_1"), "Save file should contain slot number")
	
	# Test 6: Delete character
	print("\nTest 6: Deleting character from slot 2...")
	var delete_success := CharacterManager.delete_character(2)
	print("Deleted character: %s" % delete_success)
	assert(delete_success, "Should be able to delete character")
	
	var new_count := CharacterManager.get_character_count()
	print("Character count after deletion: %d (expected: 2)" % new_count)
	assert(new_count == 2, "Should have 2 characters after deletion")
	
	# Test 7: Create new character in deleted slot
	print("\nTest 7: Creating new character in slot 2...")
	var new_char := CharacterManager.create_character(2, "New Hero")
	print("Created new character: %s" % new_char)
	assert(new_char, "Should be able to create character in freed slot")
	
	print("\n=== All Tests Passed! ===\n")
	
	# Clean up - delete all test characters
	print("Cleaning up test data...")
	for slot in range(3):
		if CharacterManager.is_slot_occupied(slot):
			CharacterManager.delete_character(slot)
	print("Cleanup complete.\n")
	
	# Quit after tests
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
