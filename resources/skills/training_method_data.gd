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

## Calculate effective XP per hour
func get_xp_per_hour() -> float:
	if action_time <= 0:
		return 0.0
	return (xp_per_action * success_rate * 3600.0) / action_time

## Get a formatted description with stats
func get_stats_text() -> String:
	var text := "Level %d | %.1f XP | %.1fs" % [level_required, xp_per_action, action_time]
	if success_rate < 1.0:
		text += " | %d%% success" % int(success_rate * 100)
	return text
