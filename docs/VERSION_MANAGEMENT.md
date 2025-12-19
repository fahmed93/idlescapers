# Version Management

## Overview
IdleScapers uses an auto-incrementing version system that updates with each deployment to GitHub Pages.

## Components

### 1. Version File (`version.txt`)
- Plain text file containing a single integer representing the current version
- Located at project root: `res://version.txt`
- Starts at `0` and increments by `1` on each deployment
- Included in the exported game build

### 2. VersionManager Autoload (`autoload/version_manager.gd`)
- Singleton that loads the version at game startup
- Provides `get_version_string()` method that returns formatted version (e.g., "v42")
- Accessible globally as `VersionManager`

### 3. Footer Display
The version is displayed in a footer at the bottom of both scenes:
- **Main Game Scene** (`scenes/main.tscn`): Shows version during gameplay
- **Startup Scene** (`scenes/startup.tscn`): Shows version on character selection screen

The footer is:
- 20 pixels tall
- Positioned at the bottom of the screen
- Uses small gray text (size 10, color #808080)
- Centered horizontally

### 4. GitHub Actions Auto-Increment (`. github/workflows/deploy.yml`)
On each deployment to `main` branch:
1. Reads current version from `version.txt`
2. Increments the version by 1
3. Writes new version back to `version.txt`
4. Commits the change back to the repository
5. Includes the updated version in the exported build

## Usage

### Accessing Version in Code
```gdscript
# Get formatted version string (e.g., "v42")
var version_string = VersionManager.get_version_string()

# Get raw version number
var version_number = VersionManager.version
```

### Manual Version Update
To manually set a version (e.g., for a major release):
1. Edit `version.txt` and set the desired version number
2. Commit and push the change
3. Next deployment will increment from that number

## Deployment Flow
```
User pushes to main
    ↓
GitHub Actions triggered
    ↓
Checkout repository (version.txt = N)
    ↓
Increment version (version.txt = N+1)
    ↓
Commit version.txt back to repo
    ↓
Build game with new version
    ↓
Deploy to GitHub Pages
```

## Example
- Initial state: `version.txt` contains `0`
- After 1st deployment: `version.txt` contains `1`, game shows "v1"
- After 2nd deployment: `version.txt` contains `2`, game shows "v2"
- And so on...
