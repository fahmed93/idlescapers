# Quick Start - Firebase Authentication

## TL;DR - What You Need to Do

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com/
   - Click "Add project" → Enter name → Create
   
2. **Enable Email Authentication**
   - In Firebase Console: Build → Authentication → Get Started
   - Sign-in method tab → Email/Password → Enable → Save

3. **Get Config Values**
   - Project Settings (gear icon) → Your apps → Web app (`</>` icon)
   - Register app → Copy the config object

4. **Configure Plugin**
   ```bash
   # Copy the template
   cp addons/godot-firebase/example.env addons/godot-firebase/.env
   
   # Edit .env and paste your values from step 3
   # Replace:
   #   "apiKey"="YOUR_API_KEY_HERE",
   #   "authDomain"="YOUR_PROJECT_ID.firebaseapp.com",
   #   etc.
   ```

5. **Enable Plugin in Godot**
   - Open Godot
   - Project → Project Settings → Plugins
   - Find "GodotFirebase" and check Enable

6. **Test It**
   - Press F5 to run
   - Create an account with any email/password
   - Check Firebase Console → Authentication → Users

## Important Files

- `addons/godot-firebase/.env` - **YOU MUST CREATE THIS** (copy from example.env)
- `todo/FIREBASE_SETUP.md` - Detailed setup guide
- `todo/MIGRATION_GUIDE.md` - What changed from old auth system
- `todo/TESTING_NOTES.md` - How to test the integration

## Common Issues

**"Firebase authentication not available"**
→ Enable the plugin in Project Settings → Plugins

**"Invalid API key"**
→ Double-check values in `.env` file match Firebase Console

**Can't find .env file**
→ You need to create it! Copy `example.env` to `.env` first

**Authentication works in editor but not in exported game**
→ Make sure `.env` file is included in export settings

## What Changed

- **Before**: Username + password (stored locally)
- **Now**: Email + password (stored in Firebase)
- **Your Character Data**: Still saved locally, not affected

## Need Help?

1. Read `todo/FIREBASE_SETUP.md` for detailed instructions
2. Check `todo/MIGRATION_GUIDE.md` for technical details
3. See [GodotFirebase Wiki](https://github.com/GodotNuts/GodotFirebase/wiki)
