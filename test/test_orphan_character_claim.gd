## Test for orphaned character claiming
## Verifies that migrated characters are automatically linked to the first account created
extends Node

func _ready() -> void:
	print("\n=== Testing Orphaned Character Claiming ===\n")
	
	# Clean up any existing test data
	_cleanup_test_files()
	
	# Wait for autoloads to initialize
	await get_tree().process_frame
	
	# Reload managers to start fresh
	AccountManager.load_accounts()
	CharacterManager.load_characters()
	
	# Test 1: Simulate a migrated character (orphaned)
	print("Test 1: Creating an orphaned character (simulating migration)...")
	var char_created := CharacterManager.create_character(0, "Migrated Hero")
	assert(char_created, "Should create character successfully")
	print("  ✓ Orphaned character created in slot 0")
	
	# Test 2: Verify no accounts exist yet
	print("\nTest 2: Verifying no accounts exist...")
	assert(AccountManager.accounts.size() == 0, "Should have no accounts")
	print("  ✓ No accounts exist")
	
	# Test 3: Create first account
	print("\nTest 3: Creating first account...")
	var account_created := AccountManager.create_account("firstuser", "password123")
	assert(account_created, "Should create account successfully")
	print("  ✓ First account created")
	
	# Test 4: Verify the orphaned character was claimed
	print("\nTest 4: Verifying orphaned character was claimed...")
	var account_data := AccountManager.get_current_account()
	# Note: Need to login first
	var login_success := AccountManager.login("firstuser", "password123")
	assert(login_success, "Should login successfully")
	
	var slots: Array = AccountManager.get_character_slots()
	assert(slots.has(0), "First account should have claimed slot 0")
	print("  ✓ Orphaned character claimed by first account")
	
	# Test 5: Verify character is accessible
	print("\nTest 5: Verifying character is accessible...")
	var character_data := CharacterManager.get_character(0)
	assert(not character_data.is_empty(), "Should be able to access character")
	assert(character_data["name"] == "Migrated Hero", "Character name should match")
	print("  ✓ Character accessible")
	
	# Test 6: Create second account and verify it doesn't get the character
	print("\nTest 6: Creating second account...")
	AccountManager.logout()
	var account2_created := AccountManager.create_account("seconduser", "password456")
	assert(account2_created, "Should create second account")
	var login2_success := AccountManager.login("seconduser", "password456")
	assert(login2_success, "Should login as seconduser")
	print("  ✓ Second account created and logged in")
	
	# Test 7: Verify second account doesn't have slot 0
	print("\nTest 7: Verifying character isolation...")
	var slots2: Array = AccountManager.get_character_slots()
	assert(not slots2.has(0), "Second account should not have slot 0")
	print("  ✓ Second account doesn't have the migrated character")
	
	# Test 8: Second account should be able to create in slots 1 and 2
	print("\nTest 8: Creating character in slot 1 for second account...")
	var char2_created := CharacterManager.create_character(1, "Hero 2")
	assert(char2_created, "Should create character in slot 1")
	AccountManager.add_character_slot(1)
	slots2 = AccountManager.get_character_slots()
	assert(slots2.has(1), "Second account should have slot 1")
	assert(not slots2.has(0), "Second account should still not have slot 0")
	print("  ✓ Second account can create characters in other slots")
	
	print("\n=== All Tests Passed! ===\n")
	
	# Clean up
	print("Cleaning up test data...")
	_cleanup_test_files()
	print("Cleanup complete.\n")
	
	# Quit after tests
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _cleanup_test_files() -> void:
	AccountManager.logout()
	if FileAccess.file_exists("user://idlescapers_accounts.json"):
		DirAccess.remove_absolute("user://idlescapers_accounts.json")
	if FileAccess.file_exists("user://idlescapers_characters.json"):
		DirAccess.remove_absolute("user://idlescapers_characters.json")
	# Clean up character save files
	for slot in range(3):
		var save_file := "user://idlescapers_save_slot_%d.json" % slot
		if FileAccess.file_exists(save_file):
			DirAccess.remove_absolute(save_file)
