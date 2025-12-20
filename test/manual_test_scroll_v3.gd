## Manual Test Scene for Mobile Scroll V3
## This test demonstrates the fix for scrolling when starting on buttons
## Run this in the Godot editor to manually verify the behavior
extends Control

var test_scroll: ScrollContainer
var test_content: VBoxContainer
var status_label: Label
var instruction_label: Label
var mobile_scroll_script := preload("res://scripts/mobile_scroll_container.gd")
var button_press_count := 0
var last_scroll_pos := 0

func _ready() -> void:
	# Create test UI
	custom_minimum_size = Vector2(400, 700)
	
	var vbox := VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 10)
	add_child(vbox)
	
	# Title
	var title := Label.new()
	title.text = "Mobile Scroll Test V3 - Button First Fix"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", Color.CYAN)
	vbox.add_child(title)
	
	# Version info
	var version_info := Label.new()
	version_info.text = "Using _input() to intercept events before buttons"
	version_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	version_info.add_theme_font_size_override("font_size", 12)
	version_info.add_theme_color_override("font_color", Color.LIGHT_GRAY)
	vbox.add_child(version_info)
	
	# Instructions
	instruction_label = Label.new()
	instruction_label.text = """TEST SCENARIO - The Bug:
1. Click a button below (it will highlight)
2. Try to scroll by dragging on a button
3. V2: Scrolling won't work ❌
4. V3: Scrolling works! ✓

Try these specific tests:
• Quick tap: < 10px movement → button clicks
• Long drag: > 10px movement → scrolls
• Tap then drag: Should scroll without issue"""
	instruction_label.add_theme_font_size_override("font_size", 13)
	instruction_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(instruction_label)
	
	# Status label
	status_label = Label.new()
	status_label.text = "Status: Ready - Try clicking then scrolling!"
	status_label.add_theme_font_size_override("font_size", 14)
	status_label.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(status_label)
	
	# Scrollable area
	test_scroll = ScrollContainer.new()
	test_scroll.custom_minimum_size = Vector2(0, 450)
	test_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	test_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	test_scroll.set_script(mobile_scroll_script)
	vbox.add_child(test_scroll)
	
	# Content to scroll
	test_content = VBoxContainer.new()
	test_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	test_scroll.add_child(test_content)
	
	# Add many buttons to enable scrolling
	for i in range(25):
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, 60)
		button.text = "Test Button %d (Click me, then try scrolling)" % (i + 1)
		button.pressed.connect(_on_button_pressed.bind(i + 1))
		test_content.add_child(button)
	
	# Monitor scroll changes
	test_scroll.get_v_scroll_bar().value_changed.connect(_on_scroll_changed)
	
	print("\n=== Mobile Scroll V3 Manual Test Started ===")
	print("Try this test case:")
	print("1. Click button 5")
	print("2. Immediately drag on button 10")
	print("3. V3 should scroll smoothly without issues!")

func _on_button_pressed(button_num: int) -> void:
	button_press_count += 1
	status_label.text = "✓ Button %d clicked! (Total clicks: %d)" % [button_num, button_press_count]
	status_label.add_theme_color_override("font_color", Color.GREEN)
	print("Button %d clicked" % button_num)
	
	# Reset status after 2 seconds
	await get_tree().create_timer(2.0).timeout
	status_label.text = "Status: Ready - Click another button or scroll!"
	status_label.add_theme_color_override("font_color", Color.YELLOW)

func _on_scroll_changed(value: float) -> void:
	var scroll_delta := int(value - last_scroll_pos)
	last_scroll_pos = int(value)
	
	if abs(scroll_delta) > 0:
		status_label.text = "📜 Scrolling! Position: %d (delta: %+d)" % [int(value), scroll_delta]
		status_label.add_theme_color_override("font_color", Color.CYAN)

func _process(_delta: float) -> void:
	# Show real-time scroll position
	if test_scroll:
		var scroll_pos := test_scroll.scroll_vertical
		var max_scroll := test_scroll.get_v_scroll_bar().max_value
		if max_scroll > 0:
			var percent := (float(scroll_pos) / max_scroll) * 100.0
			# Only update if scrolling (to not overwrite button click messages)
			if abs(scroll_pos - last_scroll_pos) > 0:
				last_scroll_pos = scroll_pos
