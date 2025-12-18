# IdleScapers - Future Development TODO

## Overview
This document outlines planned skills, features, and improvements for IdleScapers, an idle game inspired by Melvor Idle and RuneScape.

---

## Core Skills (Implemented)

### ✅ Fishing
- **Description**: Catch fish from various water sources
- **Training Methods**:
  - Level 1: Shrimp (10 XP, 3s)
  - Level 5: Sardine (20 XP, 3.5s)
  - Level 10: Herring (30 XP, 4s)
  - Level 20: Trout (50 XP, 4.5s)
  - Level 30: Salmon (70 XP, 5s)
  - Level 40: Lobster (90 XP, 5.5s)
  - Level 50: Swordfish (100 XP, 6s)
  - Level 62: Monkfish (120 XP, 5s)
  - Level 76: Shark (110 XP, 6s)
  - Level 82: Anglerfish (120 XP, 7s)

### ✅ Cooking
- **Description**: Cook raw food into consumable meals
- **Training Methods**: Cook all fish types (requires raw fish, can fail at low levels)
- **Special Mechanic**: Success rate increases with level, failed cooks produce burnt food

### ✅ Woodcutting
- **Description**: Chop trees for logs and resources
- **Training Methods**:
  - Level 1: Normal Tree (25 XP, 3s)
  - Level 15: Oak Tree (37.5 XP, 4s)
  - Level 30: Willow Tree (67.5 XP, 4.5s)
  - Level 45: Maple Tree (100 XP, 5s)
  - Level 60: Yew Tree (175 XP, 6s)
  - Level 75: Magic Tree (250 XP, 8s)
  - Level 90: Redwood Tree (380 XP, 10s)

---

## Planned Skills

### 🔨 Mining
- **Description**: Extract ores and gems from rocks
- **Training Methods**:
  - Level 1: Copper Ore (17.5 XP, 2.5s)
  - Level 1: Tin Ore (17.5 XP, 2.5s)
  - Level 15: Iron Ore (35 XP, 3s)
  - Level 20: Silver Ore (40 XP, 4s)
  - Level 30: Coal (50 XP, 3.5s)
  - Level 40: Gold Ore (65 XP, 4s)
  - Level 55: Mithril Ore (80 XP, 5s)
  - Level 70: Adamantite Ore (95 XP, 6s)
  - Level 85: Runite Ore (125 XP, 8s)
- **Special**: Random gem drops while mining

### ⚒️ Smithing
- **Description**: Smelt ores into bars and forge equipment
- **Training Methods**:
  - Level 1: Bronze Bar (6.25 XP, 2s) - requires 1 copper + 1 tin
  - Level 15: Iron Bar (12.5 XP, 3s) - 50% success rate
  - Level 20: Silver Bar (13.75 XP, 3s)
  - Level 30: Steel Bar (17.5 XP, 4s) - requires iron + 2 coal
  - Level 40: Gold Bar (22.5 XP, 3s)
  - Level 50: Mithril Bar (30 XP, 5s)
  - Level 70: Adamantite Bar (37.5 XP, 6s)
  - Level 85: Runite Bar (50 XP, 7s)
- **Equipment Forging**: Create weapons and armor for Combat

### ⚔️ Combat
- **Description**: Fight monsters for loot and XP
- **Sub-skills**:
  - Attack - Accuracy with melee weapons
  - Strength - Damage with melee weapons
  - Defence - Damage reduction
  - Hitpoints - Health pool
  - Ranged - Accuracy and damage with bows
  - Magic - Accuracy and damage with spells
  - Prayer - Unlocks combat buffs
- **Training Methods**: Auto-combat against increasingly difficult monsters
- **Monster Tiers**:
  - Level 1-10: Chickens, Cows, Goblins
  - Level 10-30: Guards, Zombies, Skeletons
  - Level 30-50: Hill Giants, Moss Giants, Lesser Demons
  - Level 50-70: Greater Demons, Black Dragons, Hellhounds
  - Level 70-99: TzHaar, Dagannoth Kings, God Wars Bosses

### 🎨 Crafting
- **Description**: Create jewelry, leather armor, and other items
- **Training Methods**:
  - Level 1: Leather items (gloves, boots)
  - Level 20: Hard leather items
  - Level 40: Dragonhide armor (green, blue, red, black)
  - Level 5: Silver jewelry
  - Level 40: Gold jewelry
  - Level 63: Dragonstone jewelry
  - Level 80: Onyx jewelry

### 🌱 Farming
- **Description**: Grow crops, herbs, and trees for resources
- **Training Methods**:
  - Level 1: Potatoes, Onions, Cabbages
  - Level 15: Tomatoes, Sweetcorn
  - Level 26: Strawberries, Watermelons
  - Level 38: Snape Grass
  - Level 1-99: Herbs (Guam to Torstol)
  - Level 15-85: Fruit Trees
  - Level 35-99: Hardwood Trees
- **Special Mechanic**: Real-time growth with offline progress

### 🧪 Herblore
- **Description**: Create potions from herbs and secondary ingredients
- **Training Methods**:
  - Level 1: Attack Potion
  - Level 12: Antipoison
  - Level 26: Energy Potion
  - Level 38: Prayer Potion
  - Level 45: Super Attack/Strength/Defence
  - Level 66: Saradomin Brew
  - Level 78: Antifire
  - Level 90: Overload
- **Requires**: Herbs from Farming, secondaries from various skills

### 🔮 Runecraft
- **Description**: Create runes for Magic combat
- **Training Methods**:
  - Level 1: Air Runes
  - Level 5: Mind Runes
  - Level 9: Water Runes
  - Level 14: Earth Runes
  - Level 20: Fire Runes
  - Level 27: Body Runes
  - Level 35: Cosmic Runes
  - Level 44: Chaos Runes
  - Level 54: Nature Runes
  - Level 65: Law Runes
  - Level 77: Death Runes
  - Level 91: Wrath Runes

### 🏹 Fletching
- **Description**: Create bows, arrows, and bolts
- **Training Methods**:
  - Level 1: Arrow shafts, Bronze arrows
  - Level 5: Shortbows
  - Level 10: Longbows
  - Level 20: Oak bows
  - Level 35: Willow bows
  - Level 50: Maple bows
  - Level 65: Yew bows
  - Level 80: Magic bows
- **Requires**: Logs from Woodcutting

### 🔥 Firemaking
- **Description**: Burn logs for XP and unlock special fires
- **Training Methods**:
  - Level 1: Normal Logs (40 XP)
  - Level 15: Oak Logs (60 XP)
  - Level 30: Willow Logs (90 XP)
  - Level 45: Maple Logs (135 XP)
  - Level 60: Yew Logs (202.5 XP)
  - Level 75: Magic Logs (303.8 XP)
  - Level 90: Redwood Logs (350 XP)
- **Special**: Wintertodt minigame-style activity

### 🪄 Magic
- **Description**: Cast spells for combat and utility
- **Training Methods**:
  - Combat spells (Strike → Bolt → Blast → Wave → Surge)
  - Alchemy - Convert items to gold
  - Enchanting - Imbue jewelry with effects
  - Teleportation - Unlock fast travel
- **Requires**: Runes from Runecraft

### ⛏️ Thieving
- **Description**: Pickpocket NPCs and unlock chests
- **Training Methods**:
  - Level 1: Man/Woman (8 XP)
  - Level 5: Farmer (14.5 XP)
  - Level 25: Warrior (26 XP)
  - Level 40: Guard (46.8 XP)
  - Level 55: Knight (84.3 XP)
  - Level 70: Paladin (151.7 XP)
  - Level 82: Hero (273.3 XP)
  - Level 91: Elf (353.3 XP)

### 🏃 Agility
- **Description**: Complete obstacle courses for XP and unlocks
- **Training Methods**:
  - Level 1: Gnome Stronghold Course
  - Level 10: Draynor Village Course
  - Level 20: Al Kharid Course
  - Level 30: Varrock Course
  - Level 40: Canifis Course
  - Level 52: Wilderness Course
  - Level 60: Seers' Village Course
  - Level 70: Pollnivneach Course
  - Level 80: Rellekka Course
  - Level 90: Ardougne Course
- **Special**: Unlocks shortcuts and energy restoration

### 🎣 Hunter
- **Description**: Track and catch creatures
- **Training Methods**:
  - Level 1: Crimson Swifts (bird snaring)
  - Level 9: Copper Longtails
  - Level 19: Swamp Lizards (net trapping)
  - Level 27: Kebbits (tracking)
  - Level 43: Spotted Kebbits
  - Level 53: Chinchompas (box trapping)
  - Level 63: Red Chinchompas
  - Level 73: Black Chinchompas
  - Level 83: Herbiboars

### 🏗️ Construction
- **Description**: Build and upgrade your player-owned house
- **Training Methods**:
  - Level 1: Crude furniture
  - Level 20: Oak furniture
  - Level 40: Teak furniture
  - Level 60: Mahogany furniture
  - Level 80: Gilded furniture
- **Special**: Unlocks teleports, altars, storage

### 🌊 Slayer
- **Description**: Complete assignments to kill specific monsters
- **Training Methods**: Kill assigned creatures for Slayer XP + Combat XP
- **Masters**:
  - Level 1: Turael (easy tasks)
  - Level 40: Vannaka (medium tasks)
  - Level 70: Chaeldar (hard tasks)
  - Level 100 Combat: Nieve (elite tasks)
  - Level 120 Combat: Duradel (master tasks)
- **Unlocks**: Access to unique monsters and drops

---

## Feature Roadmap

### Phase 1: Core Systems ✅
- [x] Skill leveling system (1-99)
- [x] XP curve (RuneScape-style)
- [x] Training methods with level requirements
- [x] Item system (raw materials, processed goods)
- [x] Inventory management
- [x] Save/Load system
- [x] Offline progress calculation
- [x] Mobile-first responsive UI

### Phase 2: Gathering Skills
- [ ] Mining skill implementation
- [ ] Gem drops and geodes
- [ ] Tool tiers (bronze → dragon pickaxe)

### Phase 3: Production Skills
- [ ] Smithing skill implementation
- [ ] Equipment creation
- [ ] Fletching skill implementation
- [ ] Crafting skill implementation

### Phase 4: Combat System
- [ ] Combat triangle (Melee/Ranged/Magic)
- [ ] Monster database with stats and drops
- [ ] Equipment stats and bonuses
- [ ] Prayer skill and prayers
- [ ] Auto-eat and potion systems

### Phase 5: Advanced Skills
- [ ] Farming with real-time growth
- [ ] Herblore potions
- [ ] Runecraft runes
- [ ] Slayer task system

### Phase 6: Quality of Life
- [ ] Achievement system
- [ ] Daily challenges
- [ ] Statistics tracking
- [ ] Item bank with tabs
- [ ] Equipment presets

### Phase 7: Late Game Content
- [ ] Boss encounters
- [ ] Dungeon raids
- [ ] Prestige system
- [ ] Mastery pools
- [ ] Pet collection

---

## Technical Improvements

### Performance
- [ ] Optimize offline progress calculations
- [ ] Lazy loading for skill data
- [ ] Efficient item sprite loading

### UI/UX
- [ ] Dark/Light theme toggle
- [ ] Customizable UI layout
- [ ] Notification system
- [ ] Action queue system
- [ ] Keyboard shortcuts

### Save System
- [ ] Cloud save support
- [ ] Multiple save slots
- [ ] Import/Export saves
- [ ] Anti-cheat validation

### Accessibility
- [ ] Color blind modes
- [ ] Screen reader support
- [ ] Scalable font sizes
- [ ] Touch target size options

---

## Monetization Ideas (Optional)

### Ethical Options
- [ ] Cosmetic pets
- [ ] UI themes/skins
- [ ] Character customization
- [ ] Supporter badge

### NO Pay-to-Win
- No XP boosts for purchase
- No premium-only skills
- No advantage items

---

## Credits & Inspiration

- **Melvor Idle** - Core idle mechanics and presentation
- **RuneScape/OSRS** - Skill system, XP curve, content inspiration
- **Godot Engine** - Game development framework

---

*Last Updated: 2024*
*Version: 0.1.0-alpha*
