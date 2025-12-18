# IdleScapers

An idle game inspired by Melvor Idle and RuneScape, built with Godot 4.x.

## Features

### Core Gameplay
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
- Collapsible sidebar with hamburger menu button in top-left corner
- Skill sidebar with level display (Skills, Store, Upgrades, Inventory)
- Dedicated full-screen inventory view
- Training method list with requirements
- Progress bars for XP and actions
- Store interface for selling items
- Gold tracking across all displays
- Offline progress popup

## Getting Started

### Requirements
- Godot 4.2 or higher

### Running the Game
1. Clone this repository
2. Open the project in Godot
3. Run the main scene (`scenes/main.tscn`)

### Project Structure

```
├── autoload/               # Singleton scripts
│   ├── game_manager.gd    # XP, skills, training logic
│   ├── inventory.gd       # Item management
│   └── save_manager.gd    # Save/load, offline progress
├── resources/
│   ├── items/
│   │   └── item_data.gd   # Item resource class
│   └── skills/
│       ├── skill_data.gd          # Skill resource class
│       └── training_method_data.gd # Training method resource class
├── scenes/
│   └── main.tscn          # Main game scene
├── scripts/
│   └── main.gd            # Main scene controller
├── test/                  # Test scripts and scenes
├── docs/                  # Documentation
│   ├── README.md          # This file
│   ├── TODO.md            # Future development plans
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

**Live Demo**: [https://fahmed93.github.io/idlescapers](https://fahmed93.github.io/idlescapers)

### Deployment Process
- **Workflow**: `.github/workflows/deploy.yml`
- **Trigger**: Automatically runs on push to `main` branch
- **Build**: Uses Godot 4.5.0 to export HTML5 build
- **Deploy**: Publishes to GitHub Pages

### Manual Deployment Setup
If deploying for the first time, ensure GitHub Pages is enabled in the repository settings:
1. Go to Settings > Pages
2. Set Source to "GitHub Actions"

## License

This project is open source. See the license file for details.

## Credits

Inspired by:
- [Melvor Idle](https://melvoridle.com/)
- [Old School RuneScape](https://oldschool.runescape.com/)