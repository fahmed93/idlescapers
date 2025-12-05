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
1. Create training methods in `GameManager._create_<skill>_methods() -> Array[TrainingMethodData]`
2. Register skill in `GameManager._load_skills()` with unique `id`, `name`, `color`
3. Add related items in `Inventory._load_items()` using `_add_item()` helper

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
See `TODO.md` for planned skills (Mining, Smithing, Combat, Crafting, Farming, etc.)
