## TrainingMethodData Resource
## Defines a training method within a skill (e.g., catching shrimp for Fishing)
class_name TrainingMethodData
extends Resource

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var level_required: int = 1
@export var xp_per_action: float = 10.0
@export var action_time: float = 3.0  # Time in seconds per action
@export var required_items: Dictionary = {}  # item_id: quantity required
@export var produced_items: Dictionary = {}  # item_id: quantity produced per action
@export var consumed_items: Dictionary = {}  # item_id: quantity consumed per action
@export var success_rate: float = 1.0  # 0.0 to 1.0 chance of success

## Calculate effective action time with speed modifiers
## If skill_id is provided, applies speed bonuses from purchased upgrades
func get_effective_action_time(skill_id: String = "") -> float:
	if skill_id.is_empty():
		return action_time
	
	var speed_modifier := UpgradeShop.get_skill_speed_modifier(skill_id)
	if speed_modifier <= 0:
		return action_time
	
	# Speed modifier increases training rate, so we reduce the action time
	# Example: 10% speed bonus (0.1) means actions complete 10% faster
	# Effective time = base_time / (1 + speed_modifier)
	return action_time / (1.0 + speed_modifier)

## Calculate effective XP per hour
## If skill_id is provided, applies speed bonuses from purchased upgrades
func get_xp_per_hour(skill_id: String = "") -> float:
	var effective_time := get_effective_action_time(skill_id)
	if effective_time <= 0:
		return 0.0
	return (xp_per_action * success_rate * 3600.0) / effective_time

## Get a formatted description with stats
## If skill_id is provided, shows the effective action time with upgrades applied
func get_stats_text(skill_id: String = "") -> String:
	var effective_time := get_effective_action_time(skill_id)
	var text := "Level %d | %.1f XP | %.1fs" % [level_required, xp_per_action, effective_time]
	if success_rate < 1.0:
		text += " | %d%% success" % int(success_rate * 100)
	return text
