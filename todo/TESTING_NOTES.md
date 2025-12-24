# Testing Notes for Firebase Authentication

## Important: Firebase Tests Require Configuration

The following test files are **currently not functional** without a properly configured Firebase project:

- `test/test_account_system.gd` / `test/test_account_system.tscn`
- `test/test_login_integration.gd` / `test/test_login_integration.tscn`

## Why Tests Don't Work Out-of-the-Box

These tests were originally designed for the local authentication system, which stored accounts in a local JSON file. With Firebase authentication:

1. **Real Firebase Project Required**: Tests need a real Firebase project with valid credentials
2. **Network Dependency**: Tests require internet connectivity to reach Firebase servers
3. **Async Operations**: Firebase authentication is asynchronous, requiring test modifications
4. **Cleanup Challenges**: Firebase accounts persist across test runs and need manual cleanup

## Testing Strategy

### Option 1: Manual Testing (Recommended for Initial Setup)

Follow the steps in `todo/FIREBASE_SETUP.md` to configure Firebase, then manually test:

1. Run the game (F5 in Godot)
2. Create a new account with email/password
3. Verify account creation in Firebase Console
4. Log out and log back in
5. Test character creation and selection

### Option 2: Firebase Emulator Suite (Advanced)

For automated testing, use the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite):

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Initialize emulators: `firebase init emulators`
3. Start emulators: `firebase emulators:start`
4. Configure `.env` to point to emulator ports
5. Run tests against emulator

### Option 3: Dedicated Test Firebase Project

Create a separate Firebase project specifically for testing:

1. Create a new Firebase project named "IdleScapers-Test"
2. Configure it with the same steps as production
3. Use a separate `.env` file for testing
4. Periodically clean up test users from Firebase Console

## Modified Test Approach

Instead of unit tests, focus on:

1. **Integration Testing**: Test the full authentication flow manually
2. **Error Handling**: Verify error messages appear correctly for various failure cases
3. **State Management**: Confirm logged-in state persists correctly
4. **Character Linking**: Verify characters are properly linked to Firebase user IDs

## Test Checklist

### Account Creation
- [ ] Create account with valid email/password
- [ ] Verify account appears in Firebase Console > Authentication
- [ ] Test validation errors:
  - [ ] Empty email
  - [ ] Invalid email format
  - [ ] Short password (< 6 characters)
  - [ ] Password mismatch
- [ ] Verify duplicate email prevention

### Login
- [ ] Log in with valid credentials
- [ ] Verify redirect to character selection
- [ ] Test error cases:
  - [ ] Wrong password
  - [ ] Non-existent email
  - [ ] Empty fields

### Logout
- [ ] Log out from character selection screen
- [ ] Verify redirect to login screen
- [ ] Confirm can't access character selection while logged out

### Character Integration
- [ ] Create character while logged in
- [ ] Verify character is linked to Firebase user ID
- [ ] Log out and log back in
- [ ] Confirm character is still accessible
- [ ] Verify other Firebase users can't see this character

## Known Limitations

1. **No Automated Tests**: Firebase integration testing requires manual testing or complex setup
2. **Test Data Cleanup**: Firebase accounts must be manually deleted from Console
3. **Rate Limiting**: Firebase has rate limits that may affect rapid testing
4. **Network Required**: All tests require internet connectivity

## Future Improvements

- Implement Firebase Emulator Suite integration
- Create automated integration tests using Emulator Suite
- Add test utilities for Firebase user cleanup
- Implement mock Firebase responses for unit tests
- Consider creating a test mode that uses local auth for CI/CD

## Running Existing Tests

**WARNING**: The existing account system tests (`test_account_system.gd` and `test_login_integration.gd`) will **fail** because they expect the old local authentication system.

These tests should either be:
1. Skipped until Firebase Emulator Suite is set up
2. Removed from the test suite
3. Rewritten to work with Firebase authentication

To temporarily skip these tests, rename them or don't include them in your test runs.
