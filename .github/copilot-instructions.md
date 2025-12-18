# IdleScapers - Copilot Instructions

## Project Overview
Godot 4.5 idle game inspired by Melvor Idle/RuneScape. Mobile-first design with skills (1-99), training methods, offline progress, and JSON-based persistence.

## Architecture

### Autoload Singletons (Global State)
Three autoloads registered in `project.godot` provide global access:
- **GameManager** (`autoload/game_manager.gd`): XP calculations, skill levels, training loop via `_process()`
- **Inventory** (`autoload/inventory.gd`): Item storage with signal-based updates
- **SaveManager** (`autoload/save_manager.gd`): Auto-save every 30s, offline progress calculation

Access anywhere: `GameManager.get_skill_level("fishing")`, `Inventory.add_item("raw_shrimp", 1)`

### Skill Organization
Skills are organized in separate files under `autoload/skills/`:
- Each skill has its own file (e.g., `fishing_skill.gd`, `woodcutting_skill.gd`)
- Each skill file contains a static `create_methods()` function that returns training methods
- Skills are loaded in `GameManager._load_skills()` using `preload()`

### Resource Classes (Data Definitions)
All game content uses custom Resource classes in `resources/`:
- `SkillData`: Skill definition with array of training methods
- `TrainingMethodData`: XP, time, required/consumed/produced items, success_rate
- `ItemData`: Item properties with `ItemType` enum (RAW_MATERIAL, PROCESSED, TOOL, CONSUMABLE)

### Signal-Driven Communication
Components communicate via signals, not direct calls:
```gdscript
# GameManager emits:
signal skill_xp_gained(skill_id: String, xp: float)
signal skill_level_up(skill_id: String, new_level: int)
signal training_started(skill_id: String, method_id: String)
signal action_completed(skill_id: String, method_id: String, success: bool)

# Inventory emits:
signal item_added(item_id: String, amount: int, new_total: int)
signal inventory_updated()
```

## Key Patterns

### Adding a New Skill
1. Create a new file `autoload/skills/<skill>_skill.gd` with a static `create_methods()` function
2. Register skill in `GameManager._load_skills()` with unique `id`, `name`, `color`, and preload the skill file
3. Add related items in `Inventory._load_items()` using `_add_item()` helper

Example skill file (`autoload/skills/fishing_skill.gd`):
```gdscript
## Fishing Skill
## Contains training methods for the Fishing skill
extends Node

## Create and return all fishing training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	# Add training methods here
	return methods
```

Register in `GameManager._load_skills()`:
```gdscript
var fishing := SkillData.new()
fishing.id = "fishing"
fishing.name = "Fishing"
fishing.description = "Catch fish from waters around the world."
fishing.color = Color(0.2, 0.6, 0.8)
fishing.training_methods = preload("res://autoload/skills/fishing_skill.gd").create_methods()
skills["fishing"] = fishing
```

### Adding a New Item
```gdscript
# In Inventory._load_items():
_add_item("item_id", "Display Name", "Description", ItemData.ItemType.RAW_MATERIAL, 100)
```

### Training Method Structure
```gdscript
var method := TrainingMethodData.new()
method.id = "unique_id"
method.level_required = 1
method.xp_per_action = 25.0
method.action_time = 3.0  # seconds
method.consumed_items = {"input_item": 1}  # optional
method.produced_items = {"output_item": 1}
method.success_rate = 0.85  # 1.0 = always succeeds
```

### XP Formula
Uses RuneScape-style exponential curve: `floor((level + 300 * 2^(level/7)) / 4)`
- Level 1 = 0 XP, Level 99 = 13,034,431 XP
- Pre-calculated in `GameManager.xp_table[]`

## Conventions

### Naming
- Skill/method/item IDs: `snake_case` (e.g., `raw_shrimp`, `cook_salmon`)
- Script files: `snake_case.gd` with `.gd.uid` companion files
- Resource classes: `PascalCase` with `class_name` declaration

### Type Hints
Always use static typing:
```gdscript
var skills: Dictionary = {}  # skill_id: SkillData
func get_skill_level(skill_id: String) -> int:
func _create_fishing_methods() -> Array[TrainingMethodData]:
```

### Documentation
Use `##` doc comments for classes and public functions:
```gdscript
## GameManager Autoload
## Handles skill levels, XP calculations, and training progression
extends Node
```

## Running the Project
- Open in Godot 4.2+
- Main scene: `scenes/main.tscn`
- Save location: `user://idlescapers_save.json`
- Mobile-first: 720x1280 viewport, touch emulation enabled

## Future Work
See `docs/TODO.md` for planned skills (Mining, Smithing, Combat, Crafting, Farming, etc.)
