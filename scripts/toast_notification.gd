## Toast Notification
## Shows a small popup notification for action completions
extends PanelContainer

const DISPLAY_DURATION := 3.0  # How long the toast is visible
const FADE_DURATION := 0.5  # Fade out duration

@onready var skill_label: Label = $VBoxContainer/SkillLabel
@onready var xp_label: Label = $VBoxContainer/XPLabel
@onready var items_label: Label = $VBoxContainer/ItemsLabel

var timer: float = 0.0
var is_fading: bool = false

func _ready() -> void:
	modulate.a = 0.0  # Start invisible
	visible = false

func _process(delta: float) -> void:
	if not visible:
		return
	
	timer += delta
	
	if timer >= DISPLAY_DURATION and not is_fading:
		is_fading = true
		timer = 0.0
	
	if is_fading:
		var fade_progress := timer / FADE_DURATION
		modulate.a = 1.0 - fade_progress
		
		if fade_progress >= 1.0:
			queue_free()  # Clean up the toast after fading

## Show a toast notification for an action completion
func show_action_completion(skill_id: String, xp_gained: float, items_gained: Dictionary) -> void:
	# Get skill data
	var skill: SkillData = GameManager.skills.get(skill_id)
	if skill == null:
		return
	
	# Set skill name with color
	skill_label.text = skill.name
	skill_label.add_theme_color_override("font_color", skill.color)
	
	# Set XP gained
	xp_label.text = "+%.1f XP" % xp_gained
	
	# Set items gained
	var items_text := ""
	if not items_gained.is_empty():
		for item_id in items_gained:
			var item_data := Inventory.get_item_data(item_id)
			var item_name: String = item_data.name if item_data else item_id
			var amount: int = items_gained[item_id]
			if items_text != "":
				items_text += ", "
			items_text += "+%d %s" % [amount, item_name]
		items_label.text = items_text
		items_label.visible = true
	else:
		items_label.visible = false
	
	# Reset state and show
	timer = 0.0
	is_fading = false
	modulate.a = 1.0
	visible = true
