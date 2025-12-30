# SkillForge Idle

An idle game inspired by Melvor Idle and RuneScape, built with Godot 4.x.

## Features

### Core Gameplay
- **Account System**: Firebase Authentication for secure login and account creation
- **Multiple Characters**: Create up to 3 characters per account
- **Skills (1-99)**: Level up skills from 1 to 99 using the classic RuneScape XP curve
- **Training Methods**: Unlock new training methods at skill milestones
- **Offline Progress**: Automatically calculates progress while you're away
- **Save/Load System**: Auto-saves every 30 seconds with JSON-based persistence
- **Store & Economy**: Sell items for gold to track your wealth

### Current Skills
- **Fishing**: Catch fish from shrimp to anglerfish (10 training methods)
- **Cooking**: Cook raw fish with varying success rates (10 training methods)
- **Woodcutting**: Chop trees from normal to redwood (7 training methods)
- **Fletching**: Create bows and arrows from logs
- **Mining**: Extract ores from rocks
- **Firemaking**: Burn logs for XP

### UI Features
- Mobile-first touch-friendly design
- Skill sidebar with level display
- Training method list with requirements
- Progress bars for XP and actions
- Inventory display with item counts
- Store interface for selling items
- Gold tracking across all displays
- Offline progress popup

## Getting Started

### Requirements
- Godot 4.2 or higher
- Firebase project (for authentication) - see setup instructions below

### Firebase Setup

Before running the game, you must configure Firebase Authentication:

1. **Create a Firebase project** at [Firebase Console](https://console.firebase.google.com/)
2. **Enable Email/Password authentication** in Firebase Console → Authentication → Sign-in method
3. **Get your Firebase config** from Project Settings → Your apps → Web app
4. **Configure the plugin**:
   - Copy `addons/godot-firebase/example.env` to `addons/godot-firebase/.env`
   - Fill in your Firebase configuration values
5. **Enable the plugin** in Godot: Project → Project Settings → Plugins → Check "GodotFirebase"

**Detailed instructions**: See `todo/FIREBASE_SETUP.md` for step-by-step guide.

### Running the Game
1. Clone this repository
2. Open the project in Godot
3. **Complete Firebase setup** (see above)
4. Run the main scene (starts at `scenes/login.tscn`)
5. Create an account with email/password
6. Create a character and start playing!

### Project Structure

```
├── addons/                  # Godot plugins
│   ├── godot-firebase/      # Firebase plugin for authentication
│   └── http-sse-client/     # HTTP SSE client (Firebase dependency)
├── autoload/                # Singleton scripts
│   ├── account_manager.gd   # Firebase authentication
│   ├── character_manager.gd # Multi-character management
│   ├── game_manager.gd      # XP, skills, training logic
│   ├── inventory.gd         # Item management
│   └── save_manager.gd      # Save/load, offline progress
├── resources/
│   ├── items/
│   │   └── item_data.gd     # Item resource class
│   └── skills/
│       ├── skill_data.gd          # Skill resource class
│       └── training_method_data.gd # Training method resource class
├── scenes/
│   ├── login.tscn           # Login/account creation screen
│   ├── startup.tscn         # Character selection screen
│   └── main.tscn            # Main game scene
├── scripts/
│   └── main.gd              # Main scene controller
├── test/                    # Test scripts and scenes
├── todo/                    # Setup and migration documentation
│   ├── FIREBASE_SETUP.md    # Firebase configuration guide
│   ├── TESTING_NOTES.md     # Testing strategies
│   └── MIGRATION_GUIDE.md   # Breaking changes and migration
├── docs/                    # Documentation
│   ├── README.md            # This file
│   ├── TODO.md              # Future development plans
│   └── UPGRADES_IMPLEMENTATION.md  # Upgrades system documentation
└── project.godot          # Godot project configuration
```

## XP Curve

Uses the classic RuneScape XP formula:
- Level 1 = 0 XP
- Level 2 = 83 XP
- Level 99 = 13,034,431 XP

XP required for each level: `sum of floor((level + 300 * 2^(level/7)) / 4)`

## Architecture

### Autoloads
- **AccountManager**: Manages user accounts and authentication
- **CharacterManager**: Manages character slots and selection
- **GameManager**: Manages skill XP, levels, and training state
- **Inventory**: Handles item storage and retrieval
- **SaveManager**: Saves/loads game state and calculates offline progress
- **Store**: Manages gold currency and item selling

### Resource Classes
- **SkillData**: Defines a skill with its training methods
- **TrainingMethodData**: Defines a training method with XP, time, and items
- **ItemData**: Defines an item with its properties and value

## Future Development

See [TODO.md](TODO.md) for planned skills and features including:
- Mining, Smithing, Combat system
- Crafting, Farming, Herblore
- And many more!

## Deployment

This project is automatically deployed to GitHub Pages when changes are pushed to the main branch.

**Live Demo**: [https://fahmed93.github.io/skillforgeidle](https://fahmed93.github.io/skillforgeidle)

### Deployment Process
- **Workflow**: `.github/workflows/deploy.yml`
- **Trigger**: Automatically runs on push to `main` branch
- **Build**: Uses Godot 4.5.0 to export HTML5 build
- **Deploy**: Publishes to GitHub Pages

### Manual Deployment Setup
If deploying for the first time, ensure GitHub Pages is enabled in the repository settings:
1. Go to Settings > Pages
2. Set Source to "GitHub Actions"

## Testing

The project includes automated tests for all major game systems. Tests run automatically on pull requests.

### Running Tests Locally
```bash
./run_tests.sh
```

Or run individual tests:
```bash
godot --headless --path . test/test_<name>.tscn
```

### CI/CD Testing
- **Workflow**: `.github/workflows/pr-build.yml`
- **Coverage**: 17 automated tests covering skills, inventory, character system, and more
- **When**: Runs on all pull requests before building
- See [docs/TESTING.md](TESTING.md) for detailed information

## License

This project is open source. See the license file for details.

## Credits

Inspired by:
- [Melvor Idle](https://melvoridle.com/)
- [Old School RuneScape](https://oldschool.runescape.com/)