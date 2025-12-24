# Firebase Authentication Setup Instructions

This document contains the manual steps required to complete the Firebase authentication integration for IdleScapers.

## Prerequisites

- A Google account
- Access to the [Firebase Console](https://console.firebase.google.com/)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Enter a project name (e.g., "IdleScapers")
4. Accept the Firebase terms and click "Continue"
5. (Optional) Enable Google Analytics for the project
6. Click "Create project" and wait for it to be created

## Step 2: Register a Web App

1. In your Firebase project, click on the "Web" icon (`</>`) to add a web app
2. Enter an app nickname (e.g., "IdleScapers Web")
3. (Optional) Check "Also set up Firebase Hosting" if you want to host the game on Firebase
4. Click "Register app"

## Step 3: Get Firebase Configuration

After registering the app, you'll see a configuration object that looks like this:

```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "1234567890",
  appId: "1:1234567890:web:abcdef123456",
  measurementId: "G-XXXXXXXXX"
};
```

**Copy these values - you'll need them in Step 5.**

## Step 4: Enable Email/Password Authentication

1. In the Firebase Console, go to "Build" > "Authentication"
2. Click "Get started" if this is your first time
3. Go to the "Sign-in method" tab
4. Click on "Email/Password" in the list of providers
5. Enable the "Email/Password" toggle
6. Click "Save"

## Step 5: Configure the Godot Firebase Plugin

1. Open your IdleScapers project in Godot
2. Navigate to `res://addons/godot-firebase/.env`
3. Replace the placeholder values with your Firebase configuration from Step 3:

```ini
[firebase/environment_variables]

"apiKey"="YOUR_API_KEY_FROM_STEP_3",
"authDomain"="YOUR_PROJECT_ID.firebaseapp.com",
"databaseURL"="https://YOUR_PROJECT_ID.firebaseio.com",
"projectId"="YOUR_PROJECT_ID",
"databaseName"="(default)"
"storageBucket"="YOUR_PROJECT_ID.appspot.com",
"messagingSenderId"="YOUR_MESSAGING_SENDER_ID",
"appId"="YOUR_APP_ID",
"measurementId"="YOUR_MEASUREMENT_ID"
"clientId"=""
"clientSecret"=""
"domainUriPrefix"=""
"functionsGeoZone"=""
"cacheLocation"=""

[firebase/emulators/ports]

authentication=""
firestore=""
realtimeDatabase=""
functions=""
storage=""
dynamicLinks=""
```

**Important:** Replace the following placeholders:
- `YOUR_API_KEY_FROM_STEP_3` with the `apiKey` value
- `YOUR_PROJECT_ID` with your Firebase project ID (appears in multiple places)
- `YOUR_MESSAGING_SENDER_ID` with the `messagingSenderId` value
- `YOUR_APP_ID` with the `appId` value
- `YOUR_MEASUREMENT_ID` with the `measurementId` value (if you have one)

4. Save the `.env` file

## Step 6: Enable the Firebase Plugin in Godot

1. Open your project in Godot
2. Go to "Project" > "Project Settings"
3. Navigate to the "Plugins" tab
4. Find "GodotFirebase" in the list and check the "Enable" checkbox
5. Close the Project Settings window

## Step 7: Test the Authentication

1. Run the game from Godot (F5)
2. Try creating a new account with a valid email and password
3. Check the Firebase Console under "Authentication" > "Users" to see if the account was created
4. Try logging in with the credentials you just created

## Troubleshooting

### "Firebase authentication not available" error
- Make sure the Firebase plugin is enabled in Project Settings > Plugins
- Verify that the Firebase autoload is registered in `project.godot`
- Check the `.env` file for any syntax errors

### "Invalid API key" or "Project not found" errors
- Double-check that all values in the `.env` file match your Firebase project configuration
- Make sure you've enabled Email/Password authentication in the Firebase Console
- Verify that the `apiKey` and `projectId` values are correct

### Authentication works in editor but not in exported build
- Make sure the `.env` file is included in your export settings
- Add `res://addons/godot-firebase/.env` to the export include filter if needed
- For web exports, check browser console for CORS or network errors

### Users can't sign up
- Verify Email/Password authentication is enabled in Firebase Console
- Check Firebase Console > Authentication > Settings > Authorized domains
- Make sure your domain (or localhost for testing) is in the authorized domains list

## Security Considerations

### Important Security Notes:

1. **API Key Exposure**: The Firebase Web API key is safe to include in client-side code. It's not a secret and is meant to identify your Firebase project. However, you should still set up Firebase Security Rules to protect your data.

2. **Firebase Security Rules**: By default, Firebase might have open rules for development. Before deploying to production, set up proper security rules in the Firebase Console.

3. **Rate Limiting**: Consider enabling rate limiting in Firebase Authentication settings to prevent abuse.

4. **User Management**: You can manage users, reset passwords, and disable accounts from the Firebase Console under Authentication > Users.

## Production Checklist

Before deploying your game to production:

- [ ] Set up Firebase Security Rules
- [ ] Enable rate limiting in Firebase Authentication
- [ ] Review authorized domains in Firebase Console
- [ ] Set up proper error logging and monitoring
- [ ] Consider implementing email verification for new accounts
- [ ] Test the authentication flow on all target platforms (Web, Mobile, Desktop)
- [ ] Back up your Firebase configuration values securely

## Additional Resources

- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)
- [GodotFirebase Plugin Wiki](https://github.com/GodotNuts/GodotFirebase/wiki)
- [Firebase Console](https://console.firebase.google.com/)

## Support

If you encounter issues not covered in this guide:

1. Check the GodotFirebase GitHub Issues: https://github.com/GodotNuts/GodotFirebase/issues
2. Join the GodotFirebase Discord community for support
3. Review the Firebase documentation for authentication errors

---

**Note**: This integration replaces the previous local authentication system. Character data remains stored locally, only authentication is handled by Firebase.
