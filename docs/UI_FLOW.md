# Character Selection UI Flow

## Startup Screen Layout

```
┌─────────────────────────────────────────────────────────┐
│                                                           │
│                  SkillForge Idle                          │
│              Select or Create a Character                 │
│                                                           │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌─────────────────────────────────────────────────┐   │
│  │ Hero One                           │ Play      │   │
│  │ Total Level: 45 | Total XP: 12450  │───────────│   │
│  │ Created: 2024-12-18 10:30:00       │ Delete    │   │
│  │ Last Played: 2024-12-18 12:45:00   │           │   │
│  └─────────────────────────────────────────────────┘   │
│                                                           │
│  ┌─────────────────────────────────────────────────┐   │
│  │ Slot 2 - Empty                     │ Create    │   │
│  │                                     │Character  │   │
│  └─────────────────────────────────────────────────┘   │
│                                                           │
│  ┌─────────────────────────────────────────────────┐   │
│  │ Slot 3 - Empty                     │ Create    │   │
│  │                                     │Character  │   │
│  └─────────────────────────────────────────────────┘   │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

## Create Character Dialog

```
┌──────────────────────────────────┐
│    Create Character              │
├──────────────────────────────────┤
│                                  │
│  Character Name:                 │
│  ┌────────────────────────────┐ │
│  │ Enter character name...    │ │
│  └────────────────────────────┘ │
│                                  │
│     [Create]    [Cancel]        │
│                                  │
└──────────────────────────────────┘
```

## Delete Confirmation Dialog

```
┌──────────────────────────────────────────┐
│    Confirm Deletion                      │
├──────────────────────────────────────────┤
│                                          │
│  Are you sure you want to delete        │
│  'Hero One'?                             │
│  This action cannot be undone!           │
│                                          │
│           [OK]    [Cancel]              │
│                                          │
└──────────────────────────────────────────┘
```

## User Flows

### Flow 1: New Player (No Existing Characters)
```
Start Game
    ↓
Startup Screen (3 empty slots)
    ↓
Click "Create Character"
    ↓
Enter Name → "My Hero"
    ↓
Click "Create"
    ↓
Character appears in slot
    ↓
Click "Play"
    ↓
Load into Main Game (fresh start)
```

### Flow 2: Existing Player (Legacy Save Migration)
```
Start Game
    ↓
Auto-migration detects old save
    ↓
Creates "Legacy Character" in Slot 0
    ↓
Startup Screen shows migrated character
    ↓
Click "Play" on Legacy Character
    ↓
Load into Main Game (existing progress)
```

### Flow 3: Multiple Characters
```
Start Game
    ↓
Startup Screen (shows all characters)
    ↓
Select Character (e.g., Slot 1)
    ↓
Click "Play"
    ↓
Load into Main Game with Slot 1's save
    ↓
(All progress saved to Slot 1)
    ↓
Restart Game
    ↓
Startup Screen
    ↓
Select Different Character (e.g., Slot 2)
    ↓
Click "Play"
    ↓
Load into Main Game with Slot 2's save
```

### Flow 4: Delete Character
```
Startup Screen
    ↓
Click "Delete" on a character
    ↓
Confirmation Dialog appears
    ↓
Click "OK"
    ↓
Character deleted
Slot becomes empty
Save file removed
    ↓
Can create new character in that slot
```

## Color Scheme
- **Background**: Dark gray (#1E232E)
- **Character Names**: White
- **Stats Text**: Light gray
- **Play Button**: Default
- **Delete Button**: Red tint (#CC4C4C)
- **Create Button**: Default
- **Empty Slot Text**: Gray (#808080)

## Mobile Optimization
- Touch-friendly button sizes (minimum 40px height)
- Vertical layout for portrait mode
- Scrollable if needed on smaller screens
- Large, readable fonts (18-20px for names, 12px for stats)
