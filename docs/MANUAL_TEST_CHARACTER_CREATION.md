# Manual Testing Guide for Character Creation Fix

## Issue
After logging in, users cannot create a character because migrated characters occupy slot 0 without being linked to any account.

## Fix
The first account created automatically claims any orphaned (unlinked) characters.

## Test Scenarios

### Scenario 1: Fresh Install (No Migration)
1. Launch the game
2. Create a new account: username="test1", password="password123"
3. Login with the account
4. Verify all 3 slots show "Empty" with "Create Character" buttons
5. Click "Create Character" on slot 0
6. Enter name "Hero1" and click Create
7. **Expected**: Character is created successfully and appears in slot 0
8. Logout
9. Create second account: username="test2", password="password456"
10. Login with second account
11. **Expected**: Slot 0 shows "Unavailable", slots 1 and 2 show "Empty"
12. Create character in slot 1
13. **Expected**: Character is created successfully

### Scenario 2: With Migrated Character (Legacy Save)
**Setup**: 
- Create a file `~/.local/share/godot/app_userdata/IdleScapers/idlescapers_save.json` with old save data
- Or manually create a character before any accounts exist

1. Launch the game
2. **Expected**: Migration runs and creates "Legacy Character" in slot 0
3. Create first account: username="legacy", password="password123"
4. Login with the account
5. **Expected**: Slot 0 shows the migrated character with "Play" and "Delete" buttons
6. Click "Play" on the migrated character
7. **Expected**: Game loads with the migrated character's progress intact
8. Return to character selection (logout or quit)
9. Login again as "legacy"
10. **Expected**: Still can access slot 0, slots 1-2 show "Empty"
11. Logout and create second account: username="new", password="password456"
12. Login as "new"
13. **Expected**: Slot 0 shows "Unavailable", slots 1-2 show "Empty"
14. Create character in slot 1
15. **Expected**: Character created successfully

### Scenario 3: Error Handling
1. Login with an account that has no characters
2. Click "Create Character" on slot 0
3. Leave the name field empty and click Create
4. **Expected**: Console shows error: "Character name cannot be empty."
5. Enter a name longer than 20 characters and click Create
6. **Expected**: Console shows error: "Character name too long (max 20 characters)."
7. Enter a valid name and click Create
8. **Expected**: Character is created successfully
9. Try to create another character in the same slot (should not be possible through UI)
10. **Expected**: If somehow attempted, console shows error about slot already occupied

## Console Output to Verify

### During First Account Creation (with orphaned character):
```
[AccountManager] Created account: <username>
[AccountManager] Claimed orphaned character in slot 0
[AccountManager] Accounts saved.
```

### During Character Creation Success:
```
[CharacterManager] Created character '<name>' in slot <slot>.
[CharacterManager] Characters saved.
[AccountManager] Added slot <slot> to account: <username>
```

### During Character Creation Failure:
```
[CharacterManager] Slot <slot> already occupied.
[Startup] Failed to create character '<name>' in slot <slot>. Slot may already be occupied.
```

## Automated Test
Run: `godot --headless --path . test/test_orphan_character_claim.tscn`

**Expected Output**:
```
=== Testing Orphaned Character Claiming ===

Test 1: Creating an orphaned character (simulating migration)...
  ✓ Orphaned character created in slot 0

Test 2: Verifying no accounts exist...
  ✓ No accounts exist

Test 3: Creating first account...
[AccountManager] Claimed orphaned character in slot 0
  ✓ First account created

Test 4: Verifying orphaned character was claimed...
  ✓ Orphaned character claimed by first account

Test 5: Verifying character is accessible...
  ✓ Character accessible

Test 6: Creating second account...
  ✓ Second account created and logged in

Test 7: Verifying character isolation...
  ✓ Second account doesn't have the migrated character

Test 8: Creating character in slot 1 for second account...
  ✓ Second account can create characters in other slots

=== All Tests Passed! ===
```
