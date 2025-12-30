## Integration test for login to character selection flow
extends Node

func _ready() -> void:
	print("\n=== Testing Login to Character Selection Integration ===\n")
	
	# Clean up any existing test data
	if FileAccess.file_exists("user://skillforge_accounts.json"):
		DirAccess.remove_absolute("user://skillforge_accounts.json")
	if FileAccess.file_exists("user://skillforge_characters.json"):
		DirAccess.remove_absolute("user://skillforge_characters.json")
	
	# Wait for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Create an account
	print("Test 1: Creating test account...")
	var account_created := AccountManager.create_account("testuser", "testpass123")
	assert(account_created, "Should create account successfully")
	print("  ✓ Account created")
	
	# Test 2: Login
	print("\nTest 2: Logging in...")
	var login_success := AccountManager.login("testuser", "testpass123")
	assert(login_success, "Should login successfully")
	assert(AccountManager.is_logged_in(), "Should be logged in")
	assert(AccountManager.current_username == "testuser", "Username should be testuser")
	print("  ✓ Login successful")
	
	# Test 3: Create a character
	print("\nTest 3: Creating character...")
	var char_created := CharacterManager.create_character(0, "TestHero")
	assert(char_created, "Should create character successfully")
	print("  ✓ Character created")
	
	# Test 4: Link character to account
	print("\nTest 4: Linking character to account...")
	AccountManager.add_character_slot(0)
	var slots: Array = AccountManager.get_character_slots()
	assert(slots.has(0), "Account should have character slot 0")
	print("  ✓ Character linked to account")
	
	# Test 5: Verify character is accessible
	print("\nTest 5: Verifying character access...")
	var character_data := CharacterManager.get_character(0)
	assert(not character_data.is_empty(), "Should be able to access character")
	assert(character_data["name"] == "TestHero", "Character name should match")
	print("  ✓ Character accessible")
	
	# Test 6: Logout
	print("\nTest 6: Logging out...")
	AccountManager.logout()
	assert(not AccountManager.is_logged_in(), "Should not be logged in after logout")
	print("  ✓ Logout successful")
	
	# Test 7: Login as different user
	print("\nTest 7: Creating and logging in as different user...")
	var account2_created := AccountManager.create_account("user2", "pass456")
	assert(account2_created, "Should create second account")
	var login2_success := AccountManager.login("user2", "pass456")
	assert(login2_success, "Should login as user2")
	print("  ✓ Second user logged in")
	
	# Test 8: Verify user2 can't see user1's character
	print("\nTest 8: Verifying character isolation...")
	var slots2: Array = AccountManager.get_character_slots()
	assert(not slots2.has(0), "User2 should not have access to user1's character slot")
	print("  ✓ Character isolation works")
	
	# Test 9: Create character for user2
	print("\nTest 9: Creating character for user2...")
	var char2_created := CharacterManager.create_character(1, "Hero2")
	assert(char2_created, "Should create character in slot 1")
	AccountManager.add_character_slot(1)
	slots2 = AccountManager.get_character_slots()
	assert(slots2.has(1), "User2 should have slot 1")
	assert(not slots2.has(0), "User2 should still not have slot 0")
	print("  ✓ User2 has separate character")
	
	# Test 10: Switch back to user1 and verify
	print("\nTest 10: Switching back to user1...")
	AccountManager.logout()
	var login1_again := AccountManager.login("testuser", "testpass123")
	assert(login1_again, "Should login as testuser again")
	var slots1_again: Array = AccountManager.get_character_slots()
	assert(slots1_again.has(0), "User1 should still have slot 0")
	assert(not slots1_again.has(1), "User1 should not have slot 1")
	print("  ✓ User1 still has only their character")
	
	print("\n=== All Integration Tests Passed! ===\n")
	
	# Clean up
	print("Cleaning up test data...")
	AccountManager.logout()
	if FileAccess.file_exists("user://skillforge_accounts.json"):
		DirAccess.remove_absolute("user://skillforge_accounts.json")
	if FileAccess.file_exists("user://skillforge_characters.json"):
		DirAccess.remove_absolute("user://skillforge_characters.json")
	# Clean up character save files
	for slot in range(3):
		var save_file := "user://skillforge_save_slot_%d.json" % slot
		if FileAccess.file_exists(save_file):
			DirAccess.remove_absolute(save_file)
	print("Cleanup complete.\n")
	
	# Quit after tests
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
