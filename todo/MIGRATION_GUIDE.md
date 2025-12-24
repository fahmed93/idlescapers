# Firebase Authentication Migration Guide

## Overview

This document describes the breaking changes introduced by migrating from local file-based authentication to Firebase Authentication.

## What Changed

### Authentication System

**Before (Local Auth):**
- Accounts stored in `user://idlescapers_accounts.json`
- Username + password authentication
- SHA-256 password hashing with application-wide salt
- Synchronous authentication (returns boolean)
- Fully offline operation

**After (Firebase Auth):**
- Accounts managed by Firebase Authentication service
- Email + password authentication
- Firebase handles password security (bcrypt with per-user salts)
- Asynchronous authentication (uses signals/callbacks)
- Requires internet connection for auth operations

### File Structure Changes

**Files Added:**
- `addons/godot-firebase/` - Firebase plugin for Godot
- `addons/http-sse-client/` - Required dependency for Firebase
- `addons/godot-firebase/.env` - Firebase configuration (not committed)
- `todo/FIREBASE_SETUP.md` - Setup instructions
- `todo/TESTING_NOTES.md` - Testing documentation

**Files Modified:**
- `autoload/account_manager.gd` - Completely rewritten for Firebase
- `scripts/login.gd` - Updated for async Firebase auth
- `scenes/login.tscn` - Updated UI labels (Username → Email)
- `project.godot` - Added Firebase autoload and plugin
- `.gitignore` - Added `.env` file exclusion

**Files Removed/Deprecated:**
- `user://idlescapers_accounts.json` - No longer used for authentication
- Character slots now stored in `user://idlescapers_character_slots.json` keyed by Firebase user ID

## Breaking Changes

### 1. AccountManager API Changes

#### `create_account()` Method

**Before:**
```gdscript
func create_account(username: String, password: String) -> bool
```
- Returns `true` for success, `false` for failure
- Synchronous operation
- Immediate feedback

**After:**
```gdscript
func create_account(email: String, password: String) -> void
```
- Returns nothing (void)
- Asynchronous operation
- Must connect to signals for results:
  - `account_created(email: String)` - Success
  - `auth_error(error_message: String)` - Failure

#### `login()` Method

**Before:**
```gdscript
func login(username: String, password: String) -> bool
```
- Returns `true` for success, `false` for failure
- Synchronous operation

**After:**
```gdscript
func login(email: String, password: String) -> void
```
- Returns nothing (void)
- Asynchronous operation
- Must connect to signals for results:
  - `logged_in(email: String)` - Success
  - `auth_error(error_message: String)` - Failure

#### Signal Changes

**New Signals:**
- `auth_error(error_message: String)` - Emitted on any authentication error

**Modified Signals:**
- `account_created(username: String)` → `account_created(email: String)`
- `logged_in(username: String)` → `logged_in(email: String)`

### 2. Input Validation Changes

**Before:**
- Username: minimum 3 characters, maximum 20 characters
- Password: minimum 6 characters

**After:**
- Email: must contain `@` and `.`, maximum 100 characters
- Password: minimum 6 characters (Firebase requirement)

### 3. Character Slot Storage

**Before:**
- Character slots stored in account data within `idlescapers_accounts.json`
- Keyed by username

**After:**
- Character slots stored separately in `idlescapers_character_slots.json`
- Keyed by Firebase user ID (not email)
- Format: `{"user_id": {"character_slots": [0, 1, 2]}}`

### 4. Session Persistence

**Before:**
- No automatic session persistence
- User must log in every time the game starts

**After:**
- Firebase handles session tokens automatically
- User may stay logged in between sessions (if Firebase session is valid)
- Need to manually check authentication state on startup

### 5. Internet Requirement

**Before:**
- Fully offline operation
- No network connectivity required

**After:**
- Internet connection required for:
  - Account creation
  - Login
  - Logout
- Character gameplay remains offline
- Authentication state cached locally by Firebase SDK

## Migration Steps for Existing Projects

If you have an existing IdleScapers installation with local accounts:

### Step 1: Backup Your Data

```bash
# Back up existing accounts (if you want to preserve usernames)
cp ~/.local/share/godot/app_userdata/IdleScapers/idlescapers_accounts.json ~/idlescapers_accounts_backup.json

# Back up character data
cp ~/.local/share/godot/app_userdata/IdleScapers/idlescapers_characters.json ~/idlescapers_characters_backup.json
cp ~/.local/share/godot/app_userdata/IdleScapers/idlescapers_save_slot_*.json ~/
```

### Step 2: Set Up Firebase

Follow the instructions in `todo/FIREBASE_SETUP.md` to:
1. Create a Firebase project
2. Enable Email/Password authentication
3. Configure the `.env` file

### Step 3: Create New Firebase Accounts

You **cannot** directly migrate local accounts to Firebase. Users must:

1. Create a new Firebase account using their desired email
2. Use any password (doesn't need to match the old one)
3. Their character data will remain intact if they had characters

### Step 4: Link Existing Characters (Optional)

If you want to preserve the link between old accounts and characters:

1. Note the slot numbers used by each old account
2. After logging in with Firebase, manually assign characters to the new Firebase user ID in `idlescapers_character_slots.json`

Example:
```json
{
  "firebase_user_id_here": {
    "character_slots": [0, 1]
  }
}
```

## Code Migration for Developers

If you have custom code that uses AccountManager:

### Before:
```gdscript
# Synchronous login
if AccountManager.login(username, password):
    print("Logged in!")
    change_scene_to_main()
else:
    show_error("Login failed")
```

### After:
```gdscript
# Async login - connect signals first
func _ready():
    AccountManager.logged_in.connect(_on_login_success)
    AccountManager.auth_error.connect(_on_login_error)

# Initiate login
AccountManager.login(email, password)

# Handle success
func _on_login_success(email: String):
    print("Logged in as: ", email)
    change_scene_to_main()

# Handle error
func _on_login_error(error_message: String):
    show_error(error_message)
```

## Testing Considerations

- Old account system tests (`test_account_system.gd`) will not work
- Firebase requires a real Firebase project for testing
- See `todo/TESTING_NOTES.md` for testing strategies

## Rollback Plan

If you need to revert to the old authentication system:

1. Check out the commit before this PR was merged
2. Restore the backed-up `idlescapers_accounts.json` file
3. Rebuild the project

## Security Improvements

Firebase Authentication provides several improvements over the local system:

1. **Better Password Hashing**: bcrypt with per-user salts instead of SHA-256 with shared salt
2. **Built-in Rate Limiting**: Protection against brute force attacks
3. **Session Management**: Secure token-based authentication
4. **Account Recovery**: Email-based password reset (can be enabled)
5. **Multi-factor Authentication**: Can be added in the future
6. **Centralized User Management**: Easy to disable accounts, monitor activity

## Known Issues and Limitations

1. **No Offline Authentication**: Cannot log in without internet
2. **Email Requirement**: Must use valid email format (no arbitrary usernames)
3. **Testing Complexity**: Requires Firebase project for any authentication testing
4. **Dependency on Firebase**: Reliance on external service (though can use Firebase Emulator for local development)
5. **Character Data Migration**: No automated migration from old accounts to Firebase

## Support and Troubleshooting

See the following documents for help:

- `todo/FIREBASE_SETUP.md` - Initial setup instructions
- `todo/TESTING_NOTES.md` - Testing strategies
- [GodotFirebase Wiki](https://github.com/GodotNuts/GodotFirebase/wiki)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)

## Questions?

Common questions:

**Q: Can I use the old local auth and Firebase auth together?**
A: No, this PR completely replaces the local auth system.

**Q: Can I keep using usernames instead of emails?**
A: Firebase requires valid email addresses. You could use fake emails like `username@localhost` during development, but this is not recommended for production.

**Q: Will my existing characters be lost?**
A: No, character save files remain intact. Only the authentication method changes. You'll need to create a Firebase account and manually link it to your character slots.

**Q: What happens if Firebase goes down?**
A: Users won't be able to log in, but logged-in users can continue playing. Consider implementing a grace period or offline mode for critical scenarios.

**Q: Can I self-host the authentication?**
A: You can use Firebase Emulator Suite for local development, but production Firebase is a managed service. For fully self-hosted auth, consider alternatives like Supabase or custom auth servers.
