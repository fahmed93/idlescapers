## SkillData Resource
## Defines a skill with its properties, XP requirements, and training methods
class_name SkillData
extends Resource

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var color: Color = Color.WHITE
@export var training_methods: Array[TrainingMethodData] = []

## Get training methods available at a given level
func get_available_methods(level: int) -> Array[TrainingMethodData]:
	var available: Array[TrainingMethodData] = []
	for method in training_methods:
		if level >= method.level_required:
			available.append(method)
	return available

## Get the next unlock level for training methods
func get_next_unlock_level(current_level: int) -> int:
	var next_level := 100  # Default to max+1 if no more unlocks
	for method in training_methods:
		if method.level_required > current_level and method.level_required < next_level:
			next_level = method.level_required
	return next_level if next_level < 100 else -1
