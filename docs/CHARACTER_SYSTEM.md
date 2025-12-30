# Character Selection System

## Overview
The game now supports multiple character saves (up to 3 characters) with a startup screen for character management.

## Components

### CharacterManager Autoload
- **Location**: `autoload/character_manager.gd`
- **Purpose**: Manages character slots, creation, deletion, and selection
- **Max Characters**: 3
- **Save File**: `user://skillforge_characters.json`

#### Character Data Structure
Each character contains:
- `slot`: int (0-2)
- `name`: String (character name, max 20 chars)
- `created_at`: int (unix timestamp)
- `last_played`: int (unix timestamp)
- `total_level`: int (sum of all skill levels)
- `total_xp`: float (sum of all skill XP)

#### Key Methods
- `create_character(slot: int, character_name: String) -> bool`: Create a new character
- `delete_character(slot: int) -> bool`: Delete a character and its save file
- `select_character(slot: int) -> bool`: Select a character to play
- `get_character(slot: int) -> Dictionary`: Get character data
- `is_slot_occupied(slot: int) -> bool`: Check if slot is occupied
- `is_max_characters_reached() -> bool`: Check if all slots are full

### SaveManager Updates
- **Location**: `autoload/save_manager.gd`
- **Changes**:
  - Save files are now per-character: `user://skillforge_save_slot_X.json`
  - Auto-save is disabled until a character is selected
  - Save/load operations use `CharacterManager.get_current_save_file()`
  - Added `_reset_game_state()` to reset all game data for new characters

### Startup Screen
- **Scene**: `scenes/startup.tscn`
- **Script**: `scripts/startup.gd`
- **Purpose**: Character selection/creation interface

#### Features
- Displays all 3 character slots
- Shows character stats (name, level, XP, dates)
- Create new characters with custom names
- Delete existing characters with confirmation dialog
- Play button loads character and switches to main game

## Migration from Old Saves
The system automatically migrates existing saves:
- If `user://skillforge_save.json` exists and no characters are created yet
- Creates a "Legacy Character" in slot 0
- Copies old save data to new slot 0 save file
- Removes old save file after successful migration

## Workflow

### New Player
1. Start game → Startup screen loads
2. Click "Create Character" on any empty slot
3. Enter character name
4. Click "Create" → Character is created
5. Click "Play" → Loads into main game

### Existing Player (First Time After Update)
1. Start game → Startup screen loads
2. Old save is automatically migrated to slot 0 as "Legacy Character"
3. Click "Play" on the migrated character → Continues with existing progress

### Multiple Characters
1. Start game → Startup screen loads
2. Select any character and click "Play"
3. Game loads that character's save data
4. All progress is saved to that character's slot
5. Return to startup screen by restarting the game
6. Can switch between characters or create new ones

## File Structure
```
user://
├── skillforge_characters.json      # Character list (max 3)
├── skillforge_save_slot_0.json     # Character 0 save data
├── skillforge_save_slot_1.json     # Character 1 save data
└── skillforge_save_slot_2.json     # Character 2 save data
```

## Testing
A test script is available at `test_character_system.gd` that validates:
- Character creation (1-3 characters)
- Slot occupation limits
- Character selection
- Save file path generation
- Character deletion
- Slot reuse after deletion

## UI Layout
The startup screen has:
- **Title**: "SkillForge Idle"
- **Subtitle**: "Select or Create a Character"
- **3 Character Slots**: Each showing either:
  - Empty slot with "Create Character" button
  - Character info (name, stats, dates) with "Play" and "Delete" buttons
- **Create Dialog**: Modal for entering character name
- **Delete Confirmation**: Modal to confirm character deletion

## Code Changes Summary

### Modified Files
1. `project.godot`
   - Added CharacterManager to autoload
   - Changed main scene to `scenes/startup.tscn`

2. `autoload/save_manager.gd`
   - Removed hardcoded save file path
   - Added character slot support
   - Added auto-save toggle
   - Added game state reset function

### New Files
1. `autoload/character_manager.gd` - Character management system
2. `scenes/startup.tscn` - Startup screen scene
3. `scripts/startup.gd` - Startup screen controller
4. `test_character_system.gd` - Test script for validation

## Future Enhancements
Potential improvements:
- Character portraits/avatars
- Character stats preview on startup screen
- Last save time display
- Backup/restore functionality
- Character export/import
- Cloud save support
