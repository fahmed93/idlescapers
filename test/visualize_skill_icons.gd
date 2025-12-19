extends Control

## Visual test to verify skill icons appear in sidebar buttons

@onready var skill_sidebar: VBoxContainer = $VBoxContainer

func _ready() -> void:
	print("\n=== VISUAL SKILL ICONS TEST ===\n")
	
	# Wait for autoloads to initialize
	await get_tree().process_frame
	
	print("Creating skill buttons with icons...\n")
	
	# Simulate the sidebar creation from main.gd
	for skill_id in GameManager.skills:
		var skill: SkillData = GameManager.skills[skill_id]
		var button := Button.new()
		button.custom_minimum_size = Vector2(120, 60)
		button.text = "%s\nLv. %d" % [skill.name, GameManager.get_skill_level(skill_id)]
		button.add_theme_color_override("font_color", skill.color)
		
		# Add skill icon if available (this is what we're testing!)
		if skill.icon:
			button.icon = skill.icon
			button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
			print("  ✓ %s button created with icon (icon size: %dx%d)" % [skill.name, skill.icon.get_width(), skill.icon.get_height()])
		else:
			print("  ✗ %s button created WITHOUT icon" % skill.name)
		
		skill_sidebar.add_child(button)
	
	print("\n=== TEST COMPLETE ===")
	print("Created %d skill buttons in sidebar" % skill_sidebar.get_child_count())
	print("Each button should display:")
	print("  - Skill icon (64x64px) on the left")
	print("  - Skill name and level text")
	print("  - Colored text matching skill color\n")
	
	# Keep the scene running for a moment to allow viewing if needed
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
