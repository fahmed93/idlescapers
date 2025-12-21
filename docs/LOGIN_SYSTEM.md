# Login and Account System Implementation

## Overview
The game now requires users to login or create an account before accessing character selection. This adds an authentication layer while keeping the game fully offline and local.

## Components

### AccountManager Autoload
- **Location**: `autoload/account_manager.gd`
- **Purpose**: Manages user accounts and authentication
- **Save File**: `user://idlescapers_accounts.json`

#### Account Data Structure
Each account contains:
- `username`: String (unique identifier, min 3 characters)
- `password_hash`: String (SHA-256 hashed password for basic security)
- `created_at`: int (unix timestamp)
- `character_slots`: Array[int] (list of character slot indices owned by this account)

#### Key Methods
- `create_account(username: String, password: String) -> bool`: Create a new account
- `login(username: String, password: String) -> bool`: Login to an existing account
- `logout() -> void`: Logout from current account
- `is_logged_in() -> bool`: Check if a user is currently logged in
- `add_character_slot(slot: int) -> void`: Link a character slot to current account
- `remove_character_slot(slot: int) -> void`: Unlink a character slot from current account
- `get_character_slots() -> Array`: Get character slots for current account

### Login Screen
- **Scene**: `scenes/login.tscn`
- **Script**: `scripts/login.gd`
- **Purpose**: Authentication interface

#### Features
- **Login Form**: Username and password fields with enter key support
- **Create Account Form**: Username, password, and password confirmation
- **Toggle Views**: Switch between login and create account
- **Input Validation**:
  - Username: min 3 characters, max 20 characters
  - Password: min 6 characters, max 50 characters
  - Password confirmation must match
- **Error Messages**: Clear feedback for validation failures
- **Auto-login**: After creating account, user is automatically logged in

### Updated Startup Screen
- **Scene**: `scenes/startup.tscn`
- **Script**: `scripts/startup.gd`
- **Changes**:
  - Checks if user is logged in, redirects to login if not
  - Displays logged-in username at top
  - Logout button to return to login screen
  - Character slots filtered by account ownership
  - Characters created are automatically linked to logged-in account
  - Slots occupied by other accounts show as "Occupied by another user"

## User Flow

### New User Journey
1. Start game → Login screen loads
2. Click "Create Account" button
3. Enter username (min 3 chars), password (min 6 chars), confirm password
4. Click "Create Account" button
5. Automatically logged in → Character selection screen loads
6. Create character(s) in available slots
7. Click "Play" to start game

### Returning User Journey
1. Start game → Login screen loads
2. Enter username and password
3. Click "Login" or press Enter
4. Character selection screen loads showing only their characters
5. Select a character and click "Play"

### Multiple Accounts
1. Different accounts can have characters in different slots
2. Each account sees only their own characters
3. Accounts cannot access or modify other accounts' characters
4. Up to 3 accounts can each have up to 3 characters (9 total characters possible)

### Logout
1. From character selection screen, click "Logout" button
2. Returns to login screen
3. Must login again to access characters

## Security Features

### Password Hashing
- Passwords are hashed using SHA-256 with a salt before storage
- Plain-text passwords are never stored on disk
- Hash comparison is used for authentication
- Salt is application-wide (in production, per-user salts would be better)

### Character Isolation
- Characters are linked to accounts via slot ownership
- Accounts can only see/modify their own characters
- Character slots occupied by other accounts are hidden

### Validation
- Username: 3-20 characters
- Password: 6-50 characters
- No empty usernames or passwords allowed
- Duplicate usernames prevented

## File Structure
```
user://
├── idlescapers_accounts.json         # All account data
├── idlescapers_characters.json       # All character metadata
├── idlescapers_save_slot_0.json      # Character 0 save data
├── idlescapers_save_slot_1.json      # Character 1 save data
└── idlescapers_save_slot_2.json      # Character 2 save data
```

## Testing

### Unit Tests
**Test**: `test/test_account_system.tscn`
- Account creation (valid and invalid)
- Login validation (correct/incorrect credentials)
- Duplicate account prevention
- Username/password validation
- Character slot management
- Logout functionality
- Account existence checking

### Integration Tests
**Test**: `test/test_login_integration.tscn`
- Full login → character creation flow
- Character isolation between accounts
- Multi-account scenarios
- Logout and re-login
- Character slot ownership

## Code Changes Summary

### New Files
1. `autoload/account_manager.gd` - Account management system
2. `scenes/login.tscn` - Login screen scene
3. `scripts/login.gd` - Login screen controller
4. `test/test_account_system.gd` - Unit tests for account system
5. `test/test_account_system.tscn` - Unit test scene
6. `test/test_login_integration.gd` - Integration tests
7. `test/test_login_integration.tscn` - Integration test scene

### Modified Files
1. `project.godot`
   - Added AccountManager to autoload (before CharacterManager)
   - Changed main scene from `startup.tscn` to `login.tscn`

2. `scripts/startup.gd`
   - Added login check in `_ready()`, redirects if not logged in
   - Added account info label and logout button references
   - Updated `_populate_character_slots()` to filter by account ownership
   - Added `_on_logout_pressed()` handler
   - Character creation now links slot to account
   - Character deletion now unlinks slot from account

3. `scenes/startup.tscn`
   - Added AccountLabel to show logged-in username
   - Added LogoutButton to return to login screen

## Design Decisions

### Local-Only Authentication
- No server or network required
- All data stored in local user directory
- Simple SHA-256 hashing for basic password protection
- Focus on multi-user scenarios on same device

### Character Slot Isolation
- Each account owns specific character slots
- Prevents accidental data mixing
- Allows multiple users to share a device
- Maximum of 3 characters per account (9 total possible)

### Automatic Account Linking
- When a character is created, it's automatically linked to the logged-in account
- When a character is deleted, it's automatically unlinked from the account
- No manual slot management required

### Simple UI Flow
- Linear flow: Login → Character Selection → Game
- Logout returns to login screen
- No in-game account switching
- Clear visual feedback for authentication state

## Future Enhancements
Potential improvements:
- Password reset functionality (security question or email)
- Account deletion with confirmation
- Profile pictures or avatars per account
- Account statistics (total playtime, achievements)
- Export/import account data
- Cloud sync support (Firebase, etc.)
- Two-factor authentication
- Session timeout for security
- Remember me functionality

## Limitations
- Password hashing uses a simple application-wide salt (per-user salts would be more secure)
- No account recovery mechanism
- No protection against brute force attempts
- All data is local (no cloud backup)

## Migration Notes
- Existing character system unchanged
- Old saves from previous versions are unaffected
- First-time users after update will need to create an account
- Accounts file is separate from characters file for cleaner data management
