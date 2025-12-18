# Change Character Button Implementation

## Overview
A "Change Character" button has been added to the top-right corner of the main game screen, allowing players to save their current game and return to the character selection screen.

## UI Layout

```
┌─────────────────────────────────────────────────────────┐
│ ☰                                   Change Character    │ ← Top bar
├─────────────────────────────────────────────────────────┤
│ [Sidebar]  │  [Main Content Area]                       │
│            │                                             │
│  Skills    │  Selected Skill Info                       │
│  --------  │  Training Methods                          │
│  Fishing   │  Inventory                                 │
│  Cooking   │                                             │
│  ...       │                                             │
│            │                                             │
│  Upgrades  │                                             │
│  Inventory │                                             │
│            │                                             │
│ Total: XX  │  [Total Stats Panel]                       │
└─────────────────────────────────────────────────────────┘
```

## Button Specifications

### MenuButton (existing)
- **Position**: Top-left (8, 8)
- **Size**: 50x50 px
- **Text**: "☰" (hamburger menu icon)
- **Function**: Toggle sidebar visibility

### ChangeCharacterButton (new)
- **Position**: Top-right, anchored to right edge
- **Anchors**: anchor_left=1.0, anchor_right=1.0
- **Offsets**: left=-128, top=8, right=-8, bottom=48
- **Size**: 120x40 px (custom_minimum_size)
- **Text**: "Change Character"
- **Font Size**: 14
- **Function**: Save game and return to character selection

## Implementation Details

### Scene Changes (`scenes/main.tscn`)
Added new Button node:
```gdscript
[node name="ChangeCharacterButton" type="Button" parent="."]
custom_minimum_size = Vector2(120, 40)
layout_mode = 1
anchors_preset = 1
anchor_left = 1.0
anchor_right = 1.0
offset_left = -128.0
offset_top = 8.0
offset_right = -8.0
offset_bottom = 48.0
grow_horizontal = 0
theme_override_font_sizes/font_size = 14
text = "Change Character"
```

### Script Changes (`scripts/main.gd`)

1. **Added node reference**:
```gdscript
@onready var change_character_button: Button = $ChangeCharacterButton
```

2. **Connected signal in `_setup_signals()`**:
```gdscript
change_character_button.pressed.connect(_on_change_character_pressed)
```

3. **Added handler function**:
```gdscript
## Handle change character button pressed
func _on_change_character_pressed() -> void:
    # Stop any active training
    if GameManager.is_training:
        GameManager.stop_training()
    
    # Save the current game state
    SaveManager.save_game()
    
    # Disable auto-save while transitioning
    SaveManager.auto_save_enabled = false
    
    # Reset current character slot
    CharacterManager.current_slot = -1
    
    # Change back to startup scene
    get_tree().change_scene_to_file("res://scenes/startup.tscn")
```

## Behavior Flow

1. **User clicks "Change Character" button**
2. **Stop training** if currently active (prevents data loss)
3. **Save game** to persist current progress
4. **Disable auto-save** during scene transition
5. **Reset current slot** in CharacterManager
6. **Navigate** to startup scene (character selection)
7. **User can select** a different character or the same one again

## Testing

A manual test has been created at `test/test_change_character_button.gd` that verifies:
- ✓ Main scene loads successfully
- ✓ ChangeCharacterButton node exists
- ✓ Button is of type Button
- ✓ Button text is "Change Character"
- ✓ Button is anchored to top-right (anchor values)
- ✓ Button size is 120x40

## Notes

- The button appears on the main game screen only (not on startup screen)
- Button is always visible regardless of sidebar state
- Game progress is automatically saved before switching characters
- No data loss occurs when changing characters
- Works seamlessly with the existing character slot system (max 3 characters)
