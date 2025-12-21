## Test script for account management system
extends Node

func _ready() -> void:
	print("\n=== Testing Account Management System ===\n")
	
	# Test 1: Create accounts
	print("Test 1: Creating accounts...")
	var success1 := AccountManager.create_account("player1", "password123")
	var success2 := AccountManager.create_account("player2", "password456")
	
	print("Created 2 accounts: %s, %s" % [success1, success2])
	assert(success1 and success2, "Both account creations should succeed")
	print("  ✓ Account creation works")
	
	# Test 2: Try to create duplicate account (should fail)
	print("\nTest 2: Trying to create duplicate account (should fail)...")
	var success3 := AccountManager.create_account("player1", "different_password")
	print("Creating duplicate account: %s (expected: false)" % success3)
	assert(not success3, "Should not be able to create duplicate account")
	print("  ✓ Duplicate account prevention works")
	
	# Test 3: Invalid account creation (username too short)
	print("\nTest 3: Testing username validation (too short)...")
	var success4 := AccountManager.create_account("ab", "password123")
	print("Creating account with short username: %s (expected: false)" % success4)
	assert(not success4, "Should not allow username shorter than 3 characters")
	print("  ✓ Username validation works")
	
	# Test 4: Invalid account creation (password too short)
	print("\nTest 4: Testing password validation (too short)...")
	var success5 := AccountManager.create_account("player3", "12345")
	print("Creating account with short password: %s (expected: false)" % success5)
	assert(not success5, "Should not allow password shorter than 6 characters")
	print("  ✓ Password validation works")
	
	# Test 5: Login with correct credentials
	print("\nTest 5: Logging in with correct credentials...")
	var login1 := AccountManager.login("player1", "password123")
	print("Login success: %s (expected: true)" % login1)
	assert(login1, "Should be able to login with correct credentials")
	assert(AccountManager.is_logged_in(), "Should be logged in")
	assert(AccountManager.current_username == "player1", "Current username should be player1")
	print("  ✓ Login works")
	
	# Test 6: Login with incorrect password
	print("\nTest 6: Logging in with incorrect password...")
	AccountManager.logout()
	var login2 := AccountManager.login("player1", "wrong_password")
	print("Login with wrong password: %s (expected: false)" % login2)
	assert(not login2, "Should not be able to login with wrong password")
	assert(not AccountManager.is_logged_in(), "Should not be logged in")
	print("  ✓ Password validation on login works")
	
	# Test 7: Login with non-existent account
	print("\nTest 7: Logging in with non-existent account...")
	var login3 := AccountManager.login("nonexistent", "password123")
	print("Login with non-existent account: %s (expected: false)" % login3)
	assert(not login3, "Should not be able to login with non-existent account")
	print("  ✓ Non-existent account check works")
	
	# Test 8: Character slot management
	print("\nTest 8: Testing character slot management...")
	AccountManager.login("player1", "password123")
	AccountManager.add_character_slot(0)
	AccountManager.add_character_slot(1)
	
	var slots: Array = AccountManager.get_character_slots()
	print("Character slots for player1: %s" % str(slots))
	assert(slots.size() == 2, "Should have 2 character slots")
	assert(slots.has(0) and slots.has(1), "Should have slots 0 and 1")
	print("  ✓ Add character slot works")
	
	# Test 9: Remove character slot
	print("\nTest 9: Removing character slot...")
	AccountManager.remove_character_slot(0)
	slots = AccountManager.get_character_slots()
	print("Character slots after removal: %s" % str(slots))
	assert(slots.size() == 1, "Should have 1 character slot")
	assert(not slots.has(0), "Should not have slot 0")
	assert(slots.has(1), "Should still have slot 1")
	print("  ✓ Remove character slot works")
	
	# Test 10: Logout
	print("\nTest 10: Testing logout...")
	AccountManager.logout()
	assert(not AccountManager.is_logged_in(), "Should not be logged in after logout")
	assert(AccountManager.current_username == "", "Current username should be empty")
	print("  ✓ Logout works")
	
	# Test 11: Check account exists
	print("\nTest 11: Testing account existence check...")
	var exists1 := AccountManager.account_exists("player1")
	var exists2 := AccountManager.account_exists("nonexistent")
	print("player1 exists: %s (expected: true)" % exists1)
	print("nonexistent exists: %s (expected: false)" % exists2)
	assert(exists1, "player1 should exist")
	assert(not exists2, "nonexistent should not exist")
	print("  ✓ Account existence check works")
	
	print("\n=== All Tests Passed! ===\n")
	
	# Clean up - delete test accounts
	print("Cleaning up test data...")
	if FileAccess.file_exists("user://idlescapers_accounts.json"):
		DirAccess.remove_absolute("user://idlescapers_accounts.json")
	print("Cleanup complete.\n")
	
	# Quit after tests
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
