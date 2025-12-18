## UpgradeData Resource
## Defines an upgrade that can be purchased to improve skill training
class_name UpgradeData
extends Resource

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var skill_id: String = ""  # Which skill this upgrade applies to
@export var level_required: int = 1  # Skill level required to purchase
@export var cost: int = 100  # Gold cost to purchase
@export var speed_modifier: float = 0.1  # Percentage faster (0.1 = 10% faster)

## Get formatted description with stats
func get_stats_text() -> String:
	var speed_percent := int(speed_modifier * 100)
	return "Level %d | %d Gold | +%d%% Speed" % [level_required, cost, speed_percent]
