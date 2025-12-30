## Test script for character slot management without account system
extends Node

func _ready() -> void:
	print("\n=== Testing Character Slot Management (No Accounts) ===\n")
	
	# Clean up any existing test data
	_cleanup_test_files()
	
	# Wait for autoloads to initialize
	await get_tree().process_frame
	
	# Reload character manager to start fresh
	CharacterManager.load_characters()
	
	# Test 1: Create character in slot 0
	print("Test 1: Creating character in slot 0...")
	var char0_created := CharacterManager.create_character(0, "Hero One")
	assert(char0_created, "Should create character in slot 0")
	print("  ✓ Character created in slot 0")
	
	# Test 2: Verify character exists
	print("\nTest 2: Verifying character exists...")
	var char0_data := CharacterManager.get_character(0)
	assert(not char0_data.is_empty(), "Should retrieve character data")
	assert(char0_data["name"] == "Hero One", "Character name should match")
	print("  ✓ Character data retrieved successfully")
	
	# Test 3: Create character in slot 1
	print("\nTest 3: Creating character in slot 1...")
	var char1_created := CharacterManager.create_character(1, "Hero Two")
	assert(char1_created, "Should create character in slot 1")
	print("  ✓ Character created in slot 1")
	
	# Test 4: Create character in slot 2
	print("\nTest 4: Creating character in slot 2...")
	var char2_created := CharacterManager.create_character(2, "Hero Three")
	assert(char2_created, "Should create character in slot 2")
	print("  ✓ Character created in slot 2")
	
	# Test 5: Verify all characters exist
	print("\nTest 5: Verifying all characters exist...")
	var all_chars := CharacterManager.get_all_characters()
	assert(all_chars.size() == 3, "Should have 3 characters")
	assert(all_chars.has("0"), "Should have character in slot 0")
	assert(all_chars.has("1"), "Should have character in slot 1")
	assert(all_chars.has("2"), "Should have character in slot 2")
	print("  ✓ All 3 characters exist")
	
	# Test 6: Try to create character in occupied slot (should fail)
	print("\nTest 6: Trying to create character in occupied slot (should fail)...")
	var duplicate_created := CharacterManager.create_character(0, "Duplicate")
	assert(not duplicate_created, "Should not create character in occupied slot")
	print("  ✓ Duplicate prevention works")
	
	# Test 7: Select and play character
	print("\nTest 7: Selecting character from slot 1...")
	var selected := CharacterManager.select_character(1)
	assert(selected, "Should select character")
	assert(CharacterManager.current_slot == 1, "Current slot should be 1")
	print("  ✓ Character selection works")
	
	# Test 8: Delete character
	print("\nTest 8: Deleting character from slot 0...")
	var deleted := CharacterManager.delete_character(0)
	assert(deleted, "Should delete character")
	var char0_after_delete := CharacterManager.get_character(0)
	assert(char0_after_delete.is_empty(), "Slot 0 should be empty after deletion")
	print("  ✓ Character deletion works")
	
	# Test 9: Verify other characters still exist
	print("\nTest 9: Verifying other characters still exist...")
	var char1_still_exists := CharacterManager.get_character(1)
	var char2_still_exists := CharacterManager.get_character(2)
	assert(not char1_still_exists.is_empty(), "Character in slot 1 should still exist")
	assert(not char2_still_exists.is_empty(), "Character in slot 2 should still exist")
	print("  ✓ Other characters unaffected by deletion")
	
	# Test 10: Create new character in now-empty slot 0
	print("\nTest 10: Creating new character in now-empty slot 0...")
	var new_char0_created := CharacterManager.create_character(0, "New Hero")
	assert(new_char0_created, "Should create character in empty slot 0")
	var new_char0_data := CharacterManager.get_character(0)
	assert(new_char0_data["name"] == "New Hero", "New character name should match")
	print("  ✓ Slot reuse works")
	
	print("\n=== All Tests Passed! ===\n")
	
	# Clean up
	print("Cleaning up test data...")
	_cleanup_test_files()
	print("Cleanup complete.\n")
	
	# Quit after tests
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _cleanup_test_files() -> void:
	if FileAccess.file_exists("user://skillforge_characters.json"):
		DirAccess.remove_absolute("user://skillforge_characters.json")
	# Clean up character save files
	for slot in range(3):
		var save_file := "user://skillforge_save_slot_%d.json" % slot
		if FileAccess.file_exists(save_file):
			DirAccess.remove_absolute(save_file)
