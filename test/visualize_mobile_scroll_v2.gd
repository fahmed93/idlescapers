## Visual Test for Mobile Scroll Container V2
## This test helps verify the improved scrolling behavior
## Run this in the Godot editor to manually test scrolling
extends Control

var test_scroll: ScrollContainer
var test_content: VBoxContainer
var status_label: Label
var mobile_scroll_script := preload("res://scripts/mobile_scroll_container.gd")

func _ready() -> void:
	# Create test UI
	custom_minimum_size = Vector2(400, 600)
	
	var vbox := VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(vbox)
	
	# Title
	var title := Label.new()
	title.text = "Mobile Scroll Test V2"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	vbox.add_child(title)
	
	# Instructions
	var instructions := Label.new()
	instructions.text = """Test these scenarios:
1. Quick tap on button (should click)
2. Drag on button >10px (should scroll)
3. Drag on empty space (should scroll)
4. Fast flick gesture (should scroll smoothly)

Watch the status label below for feedback."""
	instructions.add_theme_font_size_override("font_size", 12)
	vbox.add_child(instructions)
	
	# Status label
	status_label = Label.new()
	status_label.text = "Status: Ready"
	status_label.add_theme_font_size_override("font_size", 14)
	status_label.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(status_label)
	
	# Scrollable area
	test_scroll = ScrollContainer.new()
	test_scroll.custom_minimum_size = Vector2(0, 400)
	test_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	test_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	test_scroll.set_script(mobile_scroll_script)
	vbox.add_child(test_scroll)
	
	# Content to scroll
	test_content = VBoxContainer.new()
	test_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	test_scroll.add_child(test_content)
	
	# Add many buttons to enable scrolling
	for i in range(20):
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, 60)
		button.text = "Test Button %d" % (i + 1)
		button.pressed.connect(_on_button_pressed.bind(i + 1))
		test_content.add_child(button)
	
	# Monitor scroll events
	test_scroll.gui_input.connect(_on_scroll_input)
	
	print("\n=== Mobile Scroll Test V2 Started ===")
	print("Try tapping and dragging on buttons to test behavior")
	print("Expected: <10px movement = button click, >10px = scroll")

func _on_button_pressed(button_num: int) -> void:
	status_label.text = "✓ Button %d clicked!" % button_num
	status_label.add_theme_color_override("font_color", Color.GREEN)
	print("Button %d clicked" % button_num)
	
	# Reset status after 2 seconds
	await get_tree().create_timer(2.0).timeout
	status_label.text = "Status: Ready"
	status_label.add_theme_color_override("font_color", Color.YELLOW)

func _on_scroll_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			status_label.text = "Started drag..."
			status_label.add_theme_color_override("font_color", Color.CYAN)
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		status_label.text = "Dragging... (scroll: %d)" % test_scroll.scroll_vertical
		status_label.add_theme_color_override("font_color", Color.BLUE)

func _process(_delta: float) -> void:
	# Display current scroll position
	if test_scroll and test_scroll.get_v_scroll_bar():
		var scrollbar := test_scroll.get_v_scroll_bar()
		var scroll_percent := 0.0
		if scrollbar.max_value > 0:
			scroll_percent = (test_scroll.scroll_vertical / scrollbar.max_value) * 100.0
