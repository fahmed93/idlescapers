## Crafting Skill
## Contains training methods for the Crafting skill
extends Node

## Create and return all crafting training methods
static func create_methods() -> Array[TrainingMethodData]:
	var methods: Array[TrainingMethodData] = []
	
	# ===== LEATHER ARMOR (Common Hides) =====
	
	# Level 1: Leather Gloves (rabbit hide)
	var leather_gloves := TrainingMethodData.new()
	leather_gloves.id = "leather_gloves"
	leather_gloves.name = "Leather Gloves"
	leather_gloves.description = "Craft leather gloves from rabbit hide."
	leather_gloves.level_required = 1
	leather_gloves.xp_per_action = 13.8
	leather_gloves.action_time = 2.0
	leather_gloves.consumed_items = {"rabbit_hide": 1}
	leather_gloves.produced_items = {"leather_gloves": 1}
	methods.append(leather_gloves)
	
	# Level 3: Leather Boots (rabbit hide)
	var leather_boots := TrainingMethodData.new()
	leather_boots.id = "leather_boots"
	leather_boots.name = "Leather Boots"
	leather_boots.description = "Craft leather boots from rabbit hide."
	leather_boots.level_required = 3
	leather_boots.xp_per_action = 16.25
	leather_boots.action_time = 2.0
	leather_boots.consumed_items = {"rabbit_hide": 1}
	leather_boots.produced_items = {"leather_boots": 1}
	methods.append(leather_boots)
	
	# Level 7: Leather Cowl (cowhide)
	var leather_cowl := TrainingMethodData.new()
	leather_cowl.id = "leather_cowl"
	leather_cowl.name = "Leather Cowl"
	leather_cowl.description = "Craft a leather cowl from cowhide."
	leather_cowl.level_required = 7
	leather_cowl.xp_per_action = 18.5
	leather_cowl.action_time = 2.5
	leather_cowl.consumed_items = {"cowhide": 1}
	leather_cowl.produced_items = {"leather_cowl": 1}
	methods.append(leather_cowl)
	
	# Level 9: Leather Vambraces (cowhide)
	var leather_vambraces := TrainingMethodData.new()
	leather_vambraces.id = "leather_vambraces"
	leather_vambraces.name = "Leather Vambraces"
	leather_vambraces.description = "Craft leather vambraces from cowhide."
	leather_vambraces.level_required = 9
	leather_vambraces.xp_per_action = 22.0
	leather_vambraces.action_time = 2.5
	leather_vambraces.consumed_items = {"cowhide": 1}
	leather_vambraces.produced_items = {"leather_vambraces": 1}
	methods.append(leather_vambraces)
	
	# Level 11: Leather Body (cowhide x3)
	var leather_body := TrainingMethodData.new()
	leather_body.id = "leather_body"
	leather_body.name = "Leather Body"
	leather_body.description = "Craft a leather body from cowhide."
	leather_body.level_required = 11
	leather_body.xp_per_action = 25.0
	leather_body.action_time = 3.0
	leather_body.consumed_items = {"cowhide": 3}
	leather_body.produced_items = {"leather_body": 1}
	methods.append(leather_body)
	
	# Level 14: Leather Chaps (cowhide x2)
	var leather_chaps := TrainingMethodData.new()
	leather_chaps.id = "leather_chaps"
	leather_chaps.name = "Leather Chaps"
	leather_chaps.description = "Craft leather chaps from cowhide."
	leather_chaps.level_required = 14
	leather_chaps.xp_per_action = 27.0
	leather_chaps.action_time = 3.0
	leather_chaps.consumed_items = {"cowhide": 2}
	leather_chaps.produced_items = {"leather_chaps": 1}
	methods.append(leather_chaps)
	
	# ===== HARD LEATHER ARMOR (Tougher Hides) =====
	
	# Level 18: Hard Leather Body (bear hide x2)
	var hard_leather_body := TrainingMethodData.new()
	hard_leather_body.id = "hard_leather_body"
	hard_leather_body.name = "Hard Leather Body"
	hard_leather_body.description = "Craft a hard leather body from bear hide."
	hard_leather_body.level_required = 18
	hard_leather_body.xp_per_action = 35.0
	hard_leather_body.action_time = 3.5
	hard_leather_body.consumed_items = {"bear_hide": 2}
	hard_leather_body.produced_items = {"hard_leather_body": 1}
	methods.append(hard_leather_body)
	
	# Level 22: Studded Body (wolf hide x3)
	var studded_body := TrainingMethodData.new()
	studded_body.id = "studded_body"
	studded_body.name = "Studded Body"
	studded_body.description = "Craft a studded body from wolf hide."
	studded_body.level_required = 22
	studded_body.xp_per_action = 40.0
	studded_body.action_time = 3.5
	studded_body.consumed_items = {"wolf_hide": 3}
	studded_body.produced_items = {"studded_body": 1}
	methods.append(studded_body)
	
	# Level 26: Studded Chaps (wolf hide x2)
	var studded_chaps := TrainingMethodData.new()
	studded_chaps.id = "studded_chaps"
	studded_chaps.name = "Studded Chaps"
	studded_chaps.description = "Craft studded chaps from wolf hide."
	studded_chaps.level_required = 26
	studded_chaps.xp_per_action = 42.0
	studded_chaps.action_time = 3.5
	studded_chaps.consumed_items = {"wolf_hide": 2}
	studded_chaps.produced_items = {"studded_chaps": 1}
	methods.append(studded_chaps)
	
	# ===== SNAKE LEATHER ARMOR =====
	
	# Level 30: Snake Skin Body (snake skin x5)
	var snake_skin_body := TrainingMethodData.new()
	snake_skin_body.id = "snake_skin_body"
	snake_skin_body.name = "Snake Skin Body"
	snake_skin_body.description = "Craft a snake skin body."
	snake_skin_body.level_required = 30
	snake_skin_body.xp_per_action = 50.0
	snake_skin_body.action_time = 4.0
	snake_skin_body.consumed_items = {"snake_skin": 5}
	snake_skin_body.produced_items = {"snake_skin_body": 1}
	methods.append(snake_skin_body)
	
	# Level 34: Snake Skin Chaps (snake skin x4)
	var snake_skin_chaps := TrainingMethodData.new()
	snake_skin_chaps.id = "snake_skin_chaps"
	snake_skin_chaps.name = "Snake Skin Chaps"
	snake_skin_chaps.description = "Craft snake skin chaps."
	snake_skin_chaps.level_required = 34
	snake_skin_chaps.xp_per_action = 52.0
	snake_skin_chaps.action_time = 4.0
	snake_skin_chaps.consumed_items = {"snake_skin": 4}
	snake_skin_chaps.produced_items = {"snake_skin_chaps": 1}
	methods.append(snake_skin_chaps)
	
	# ===== GREEN DRAGONHIDE ARMOR =====
	
	# Level 40: Green D'hide Vambraces (green dragonhide x1)
	var green_vambraces := TrainingMethodData.new()
	green_vambraces.id = "green_dhide_vambraces"
	green_vambraces.name = "Green D'hide Vambraces"
	green_vambraces.description = "Craft green dragonhide vambraces."
	green_vambraces.level_required = 40
	green_vambraces.xp_per_action = 62.0
	green_vambraces.action_time = 4.5
	green_vambraces.consumed_items = {"green_dragonhide": 1}
	green_vambraces.produced_items = {"green_dhide_vambraces": 1}
	methods.append(green_vambraces)
	
	# Level 42: Green D'hide Chaps (green dragonhide x2)
	var green_chaps := TrainingMethodData.new()
	green_chaps.id = "green_dhide_chaps"
	green_chaps.name = "Green D'hide Chaps"
	green_chaps.description = "Craft green dragonhide chaps."
	green_chaps.level_required = 42
	green_chaps.xp_per_action = 124.0
	green_chaps.action_time = 5.0
	green_chaps.consumed_items = {"green_dragonhide": 2}
	green_chaps.produced_items = {"green_dhide_chaps": 1}
	methods.append(green_chaps)
	
	# Level 45: Green D'hide Body (green dragonhide x3)
	var green_body := TrainingMethodData.new()
	green_body.id = "green_dhide_body"
	green_body.name = "Green D'hide Body"
	green_body.description = "Craft green dragonhide body armor."
	green_body.level_required = 45
	green_body.xp_per_action = 186.0
	green_body.action_time = 5.5
	green_body.consumed_items = {"green_dragonhide": 3}
	green_body.produced_items = {"green_dhide_body": 1}
	methods.append(green_body)
	
	# ===== BLUE DRAGONHIDE ARMOR =====
	
	# Level 52: Blue D'hide Vambraces (blue dragonhide x1)
	var blue_vambraces := TrainingMethodData.new()
	blue_vambraces.id = "blue_dhide_vambraces"
	blue_vambraces.name = "Blue D'hide Vambraces"
	blue_vambraces.description = "Craft blue dragonhide vambraces."
	blue_vambraces.level_required = 52
	blue_vambraces.xp_per_action = 70.0
	blue_vambraces.action_time = 4.5
	blue_vambraces.consumed_items = {"blue_dragonhide": 1}
	blue_vambraces.produced_items = {"blue_dhide_vambraces": 1}
	methods.append(blue_vambraces)
	
	# Level 54: Blue D'hide Chaps (blue dragonhide x2)
	var blue_chaps := TrainingMethodData.new()
	blue_chaps.id = "blue_dhide_chaps"
	blue_chaps.name = "Blue D'hide Chaps"
	blue_chaps.description = "Craft blue dragonhide chaps."
	blue_chaps.level_required = 54
	blue_chaps.xp_per_action = 140.0
	blue_chaps.action_time = 5.0
	blue_chaps.consumed_items = {"blue_dragonhide": 2}
	blue_chaps.produced_items = {"blue_dhide_chaps": 1}
	methods.append(blue_chaps)
	
	# Level 57: Blue D'hide Body (blue dragonhide x3)
	var blue_body := TrainingMethodData.new()
	blue_body.id = "blue_dhide_body"
	blue_body.name = "Blue D'hide Body"
	blue_body.description = "Craft blue dragonhide body armor."
	blue_body.level_required = 57
	blue_body.xp_per_action = 210.0
	blue_body.action_time = 5.5
	blue_body.consumed_items = {"blue_dragonhide": 3}
	blue_body.produced_items = {"blue_dhide_body": 1}
	methods.append(blue_body)
	
	# ===== RED DRAGONHIDE ARMOR =====
	
	# Level 60: Red D'hide Vambraces (red dragonhide x1)
	var red_vambraces := TrainingMethodData.new()
	red_vambraces.id = "red_dhide_vambraces"
	red_vambraces.name = "Red D'hide Vambraces"
	red_vambraces.description = "Craft red dragonhide vambraces."
	red_vambraces.level_required = 60
	red_vambraces.xp_per_action = 78.0
	red_vambraces.action_time = 4.5
	red_vambraces.consumed_items = {"red_dragonhide": 1}
	red_vambraces.produced_items = {"red_dhide_vambraces": 1}
	methods.append(red_vambraces)
	
	# Level 62: Red D'hide Chaps (red dragonhide x2)
	var red_chaps := TrainingMethodData.new()
	red_chaps.id = "red_dhide_chaps"
	red_chaps.name = "Red D'hide Chaps"
	red_chaps.description = "Craft red dragonhide chaps."
	red_chaps.level_required = 62
	red_chaps.xp_per_action = 156.0
	red_chaps.action_time = 5.0
	red_chaps.consumed_items = {"red_dragonhide": 2}
	red_chaps.produced_items = {"red_dhide_chaps": 1}
	methods.append(red_chaps)
	
	# Level 65: Red D'hide Body (red dragonhide x3)
	var red_body := TrainingMethodData.new()
	red_body.id = "red_dhide_body"
	red_body.name = "Red D'hide Body"
	red_body.description = "Craft red dragonhide body armor."
	red_body.level_required = 65
	red_body.xp_per_action = 234.0
	red_body.action_time = 5.5
	red_body.consumed_items = {"red_dragonhide": 3}
	red_body.produced_items = {"red_dhide_body": 1}
	methods.append(red_body)
	
	# ===== BLACK DRAGONHIDE ARMOR =====
	
	# Level 70: Black D'hide Vambraces (black dragonhide x1)
	var black_vambraces := TrainingMethodData.new()
	black_vambraces.id = "black_dhide_vambraces"
	black_vambraces.name = "Black D'hide Vambraces"
	black_vambraces.description = "Craft black dragonhide vambraces."
	black_vambraces.level_required = 70
	black_vambraces.xp_per_action = 86.0
	black_vambraces.action_time = 4.5
	black_vambraces.consumed_items = {"black_dragonhide": 1}
	black_vambraces.produced_items = {"black_dhide_vambraces": 1}
	methods.append(black_vambraces)
	
	# Level 72: Black D'hide Chaps (black dragonhide x2)
	var black_chaps := TrainingMethodData.new()
	black_chaps.id = "black_dhide_chaps"
	black_chaps.name = "Black D'hide Chaps"
	black_chaps.description = "Craft black dragonhide chaps."
	black_chaps.level_required = 72
	black_chaps.xp_per_action = 172.0
	black_chaps.action_time = 5.0
	black_chaps.consumed_items = {"black_dragonhide": 2}
	black_chaps.produced_items = {"black_dhide_chaps": 1}
	methods.append(black_chaps)
	
	# Level 75: Black D'hide Body (black dragonhide x3)
	var black_body := TrainingMethodData.new()
	black_body.id = "black_dhide_body"
	black_body.name = "Black D'hide Body"
	black_body.description = "Craft black dragonhide body armor."
	black_body.level_required = 75
	black_body.xp_per_action = 258.0
	black_body.action_time = 5.5
	black_body.consumed_items = {"black_dragonhide": 3}
	black_body.produced_items = {"black_dhide_body": 1}
	methods.append(black_body)
	
	# ===== FROST DRAGONHIDE ARMOR =====
	
	# Level 78: Frost D'hide Vambraces (frost dragonhide x1)
	var frost_vambraces := TrainingMethodData.new()
	frost_vambraces.id = "frost_dhide_vambraces"
	frost_vambraces.name = "Frost D'hide Vambraces"
	frost_vambraces.description = "Craft frost dragonhide vambraces."
	frost_vambraces.level_required = 78
	frost_vambraces.xp_per_action = 95.0
	frost_vambraces.action_time = 4.5
	frost_vambraces.consumed_items = {"frost_dragonhide": 1}
	frost_vambraces.produced_items = {"frost_dhide_vambraces": 1}
	methods.append(frost_vambraces)
	
	# Level 80: Frost D'hide Chaps (frost dragonhide x2)
	var frost_chaps := TrainingMethodData.new()
	frost_chaps.id = "frost_dhide_chaps"
	frost_chaps.name = "Frost D'hide Chaps"
	frost_chaps.description = "Craft frost dragonhide chaps."
	frost_chaps.level_required = 80
	frost_chaps.xp_per_action = 190.0
	frost_chaps.action_time = 5.0
	frost_chaps.consumed_items = {"frost_dragonhide": 2}
	frost_chaps.produced_items = {"frost_dhide_chaps": 1}
	methods.append(frost_chaps)
	
	# Level 83: Frost D'hide Body (frost dragonhide x3)
	var frost_body := TrainingMethodData.new()
	frost_body.id = "frost_dhide_body"
	frost_body.name = "Frost D'hide Body"
	frost_body.description = "Craft frost dragonhide body armor."
	frost_body.level_required = 83
	frost_body.xp_per_action = 285.0
	frost_body.action_time = 5.5
	frost_body.consumed_items = {"frost_dragonhide": 3}
	frost_body.produced_items = {"frost_dhide_body": 1}
	methods.append(frost_body)
	
	# ===== ROYAL DRAGONHIDE ARMOR =====
	
	# Level 86: Royal D'hide Vambraces (royal dragonhide x1)
	var royal_vambraces := TrainingMethodData.new()
	royal_vambraces.id = "royal_dhide_vambraces"
	royal_vambraces.name = "Royal D'hide Vambraces"
	royal_vambraces.description = "Craft royal dragonhide vambraces."
	royal_vambraces.level_required = 86
	royal_vambraces.xp_per_action = 105.0
	royal_vambraces.action_time = 4.5
	royal_vambraces.consumed_items = {"royal_dragonhide": 1}
	royal_vambraces.produced_items = {"royal_dhide_vambraces": 1}
	methods.append(royal_vambraces)
	
	# Level 88: Royal D'hide Chaps (royal dragonhide x2)
	var royal_chaps := TrainingMethodData.new()
	royal_chaps.id = "royal_dhide_chaps"
	royal_chaps.name = "Royal D'hide Chaps"
	royal_chaps.description = "Craft royal dragonhide chaps."
	royal_chaps.level_required = 88
	royal_chaps.xp_per_action = 210.0
	royal_chaps.action_time = 5.0
	royal_chaps.consumed_items = {"royal_dragonhide": 2}
	royal_chaps.produced_items = {"royal_dhide_chaps": 1}
	methods.append(royal_chaps)
	
	# Level 91: Royal D'hide Body (royal dragonhide x3)
	var royal_body := TrainingMethodData.new()
	royal_body.id = "royal_dhide_body"
	royal_body.name = "Royal D'hide Body"
	royal_body.description = "Craft royal dragonhide body armor."
	royal_body.level_required = 91
	royal_body.xp_per_action = 315.0
	royal_body.action_time = 5.5
	royal_body.consumed_items = {"royal_dragonhide": 3}
	royal_body.produced_items = {"royal_dhide_body": 1}
	methods.append(royal_body)
	
	return methods
