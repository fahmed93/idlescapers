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

## Calculate time in seconds until running out of consumed items
## Returns -1 if there are no consumed items
## Returns the minimum time across all consumed items (bottleneck)
func calculate_time_until_out_of_items(speed_modifier: float = 0.0) -> float:
	if consumed_items.is_empty():
		return -1.0
	
	var min_time := INF
	
	for item_id in consumed_items:
		var consumed_per_action: int = consumed_items[item_id]
		var available_count := Inventory.get_item_count(item_id)
		
		if available_count <= 0:
			return 0.0  # Already out of items
		
		# Calculate how many actions can be done with available items
		var actions_possible := float(available_count) / float(consumed_per_action)
		
		# Calculate time for those actions (accounting for speed modifier)
		var modified_action_time := action_time / (1.0 + speed_modifier)
		var time_for_item := actions_possible * modified_action_time
		
		if time_for_item < min_time:
			min_time = time_for_item
	
	return min_time if min_time != INF else -1.0

## Format time remaining into a readable string
static func format_time_remaining(seconds: float) -> String:
	if seconds < 0:
		return ""
	
	if seconds < 60:
		return "%.0fs left" % seconds
	elif seconds < 3600:
		var mins := int(seconds / 60)
		var secs := int(seconds) % 60
		return "%dm %ds left" % [mins, secs]
	else:
		var hours := int(seconds / 3600)
		var mins := int((int(seconds) % 3600) / 60)
		return "%dh %dm left" % [hours, mins]
