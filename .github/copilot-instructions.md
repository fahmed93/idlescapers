# IdleScapers - Copilot Instructions

## Project Overview
Godot 4.5 idle game inspired by Melvor Idle/RuneScape. Mobile-first (720x1280), skills 1-99 with RuneScape XP curve, offline progress, JSON persistence, multiple character slots.

## Architecture

### Autoload Singletons (`project.godot`)
Seven autoloads provide global state—access anywhere without references:
- **CharacterManager**: Multi-character slots (max 3), save file routing per slot
- **GameManager**: Skills registry, XP/levels, training loop via `_process(delta)`
- **Inventory**: Item registry + player inventory, signal-based updates
- **SaveManager**: Auto-save (30s), offline progress calculation, JSON persistence
- **Store**: Gold currency, item selling with `sell_item(id, amount)`
- **UpgradeShop**: Purchasable speed modifiers per skill
- **Equipment**: Equipment slots and stat bonuses management

```gdscript
# Access patterns:
GameManager.get_skill_level("fishing")
Inventory.add_item("raw_shrimp", 1)
Store.sell_all("cooked_salmon")
UpgradeShop.get_skill_speed_modifier("woodcutting")
```

### Data Flow
```
User selects character → CharacterManager.select_character(slot)
                       → SaveManager.load_game() (enables auto_save_enabled)
                       → Scene changes to main.tscn
                       
Training loop: GameManager._process() → checks consumed_items → applies speed_modifier
             → _complete_action() → add_xp() + Inventory updates → emits signals
             
UI updates via signals: skill_xp_gained, action_completed, inventory_updated
```

### Resource Classes (`resources/`)
- **SkillData**: `id`, `name`, `color`, `training_methods: Array[TrainingMethodData]`
- **TrainingMethodData**: `level_required`, `xp_per_action`, `action_time`, `consumed_items`, `produced_items`, `success_rate`
- **ItemData**: `id`, `name`, `type` (RAW_MATERIAL|PROCESSED|TOOL|CONSUMABLE), `value`
- **UpgradeData**: `skill_id`, `level_required`, `cost`, `speed_modifier`

## Key Patterns

### Adding a New Skill (3 steps)
1. **Create skill file** `autoload/skills/<skill>_skill.gd`:
```gdscript
extends Node

static func create_methods() -> Array[TrainingMethodData]:
    var methods: Array[TrainingMethodData] = []
    
    var method := TrainingMethodData.new()
    method.id = "mine_copper"
    method.name = "Copper Ore"
    method.level_required = 1
    method.xp_per_action = 17.5
    method.action_time = 2.5
    method.produced_items = {"copper_ore": 1}
    methods.append(method)
    
    return methods
```

2. **Register in GameManager._load_skills()**:
```gdscript
var mining := SkillData.new()
mining.id = "mining"
mining.name = "Mining"
mining.description = "Extract ores and gems from rocks."
mining.color = Color(0.6, 0.5, 0.4)
mining.training_methods = preload("res://autoload/skills/mining_skill.gd").create_methods()
skills["mining"] = mining
skill_xp["mining"] = 0.0
skill_levels["mining"] = 1
```

3. **Add items in Inventory._load_items()**:
```gdscript
_add_item("copper_ore", "Copper Ore", "A soft reddish ore.", ItemData.ItemType.RAW_MATERIAL, 5)
```

### Training Method Properties
| Property | Type | Description |
|----------|------|-------------|
| `consumed_items` | Dictionary | Items removed per action (e.g., `{"raw_shrimp": 1}`) |
| `produced_items` | Dictionary | Items gained on success |
| `success_rate` | float | 0.0-1.0, XP always granted, items only on success |
| `action_time` | float | Base seconds (modified by UpgradeShop speed bonuses) |

### Signal-Driven UI Updates
```gdscript
# Connect in _ready():
GameManager.skill_xp_gained.connect(_on_xp_gained)
GameManager.action_completed.connect(_on_action_completed)
Inventory.inventory_updated.connect(_update_inventory_display)
Store.gold_changed.connect(_update_gold_display)
```

## Conventions

### Naming
- IDs: `snake_case` (`raw_shrimp`, `cook_salmon`, `bronze_pickaxe`)
- Scripts: `snake_case.gd` (Godot auto-generates `.gd.uid` files)
- Classes: `PascalCase` with `class_name` declaration

### Type Hints (Required)
```gdscript
var skills: Dictionary = {}  # skill_id: SkillData
func get_skill_level(skill_id: String) -> int:
static func create_methods() -> Array[TrainingMethodData]:
```

### Documentation Style
```gdscript
## ClassName Autoload/Resource
## Brief description of responsibility
extends Node
```

## Testing
Tests in `test/` directory use scene-based manual verification:
- Run test scene directly in Godot editor
- Tests use `assert()` with descriptive messages
- Print checkmarks for visual verification: `print("  ✓ Test passed")`

Example (`test/test_herblore.gd`):
```gdscript
func _ready() -> void:
    await get_tree().process_frame  # Wait for autoloads
    var skill = GameManager.skills.get("herblore")
    assert(skill != null, "Herblore skill should be registered")
```

## Running the Project
- **Godot Version**: 4.5+ (see `project.godot` features)
- **Startup Scene**: `scenes/startup.tscn` (character selection)
- **Main Game**: `scenes/main.tscn`
- **Save Location**: `user://idlescapers_slot_X.json` (per character)
- **Touch Emulation**: Enabled for mouse (`project.godot`)

## XP Formula
RuneScape-style exponential: `floor((level + 300 * 2^(level/7)) / 4)`
- Level 1 = 0 XP, Level 99 = 13,034,431 XP
- Pre-calculated in `GameManager.xp_table[]`

## CI/CD & Deployment
GitHub Actions workflows in `.github/workflows/`:
- **deploy.yml**: Auto-deploys to GitHub Pages on push to `main`
- **pr-build.yml**: Validates builds on pull requests

The workflow uses `chickensoft-games/setup-godot@v2` with Godot 4.5.0 and exports to HTML5/Web.

**Live Demo**: https://fahmed93.github.io/idlescapers

## Build & Test Commands

### Local Development
```bash
# Run the project (requires Godot 4.5+ installed)
godot --path . scenes/startup.tscn

# Run tests
./run_tests.sh

# Run individual test
godot --headless --path . test/test_<name>.tscn

# Import project assets
godot --headless --import --quit
```

### CI/CD Build
```bash
# Export HTML5 build (used by GitHub Actions)
godot --headless --export-release "Web" build/web/index.html
```

The project uses GitHub Actions for:
- **PR validation** (`.github/workflows/pr-build.yml`) - Builds on every PR
- **Auto-deployment** (`.github/workflows/deploy.yml`) - Deploys to GitHub Pages on push to `main`

## Security Best Practices

### Critical Security Rules
1. **Never commit secrets** - No API keys, credentials, or tokens in code
2. **Sanitize user input** - Always validate and sanitize data before processing
3. **Save file integrity** - Validate JSON structure when loading save files
4. **XSS prevention** - Be cautious with dynamic UI text (though Godot's Label nodes are inherently safe)

### What to Review Carefully
- Save/load operations in `SaveManager`
- User input handling in UI scripts
- Any new autoload that handles external data
- Item/skill ID validation to prevent injection attacks

### What's Safe to Change
- UI positioning and styling
- XP formulas and game balance
- Adding new skills/items following existing patterns
- Documentation updates

## Issue & PR Workflow

### Approaching Tasks
1. **Understand first** - Read the issue thoroughly, check related docs in `docs/`
2. **Minimal changes** - Make the smallest possible change to fix the issue
3. **Follow patterns** - Use existing code patterns (see Key Patterns section)
4. **Test locally** - Run `./run_tests.sh` before committing
5. **Update docs** - Add implementation docs to `docs/` for new features

### PR Best Practices
- Keep PRs focused on a single issue/feature
- Run tests before pushing
- Don't modify unrelated files
- Document breaking changes
- Update `docs/TODO.md` when completing planned features

### Code Review Expectations
- Changes should follow existing conventions
- Type hints are required on all new code
- Signals should be used for cross-component communication
- No direct autoload modifications from scenes (use signals instead)

## Development Workflow

### Making Changes
1. **Explore first** - Use `view` to understand related code
2. **Test changes** - Run relevant test scenes
3. **Verify in editor** - Open changed scenes in Godot to check visuals
4. **Document** - Add `.md` files in `docs/` for new features
5. **Commit** - Use descriptive commit messages

### Debugging
- Check console output with `print()` statements
- Use `assert()` for validation in tests
- Test with `godot --headless` for CI simulation
- Check `user://` directory for save files during testing

### Common Pitfalls
- Forgetting to preload resources before using them
- Not waiting for autoloads in `_ready()` (use `await get_tree().process_frame`)
- Modifying `.gd.uid` files (these are auto-generated)
- Putting docs in root instead of `docs/`
- Not using type hints on new code

## Documentation Standards
**All generated `.md` files go in `docs/`** — keep the project root clean.

Existing documentation:
- `docs/README.md` - Project overview
- `docs/TODO.md` - Planned features and skill implementations
- `docs/IMPLEMENTATION_DETAILS.md` - Architecture deep-dive
- `docs/*_IMPLEMENTATION.md` - Feature-specific docs (e.g., `HERBLORE_IMPLEMENTATION.md`)

When creating new documentation:
```
docs/
├── README.md                    # Main project docs
├── TODO.md                      # Future work
├── <FEATURE>_IMPLEMENTATION.md  # Feature details
└── <CONCEPT>.md                 # Architectural concepts
```

## Tools & Ecosystem

### Godot-Specific Tools
- **Godot CLI** - Headless mode for testing and building
- **GDScript** - Python-like scripting language (statically typed with hints)
- **Scene system** - `.tscn` files for UI and game objects
- **Resource system** - `.tres` and custom resources for data

### File Types
- `.gd` - GDScript source files
- `.gd.uid` - Auto-generated unique IDs (don't modify)
- `.tscn` - Scene files (can be text-edited but prefer Godot editor)
- `.tres` - Resource files
- `.import` - Asset import metadata (auto-generated)

### No Additional Build Tools
- No npm, pip, or other package managers needed
- No linters beyond Godot's built-in parser
- No external dependencies to manage
