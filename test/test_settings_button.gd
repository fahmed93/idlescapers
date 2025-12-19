## Test Settings Button
## Verifies that Settings button is present in the sidebar under Info section
extends Control

var main_scene = preload("res://scenes/main.tscn")
var main_instance: Control = null

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Settings Button Tests ===\n")
	
	# Test 1: Load main scene
	print("Test 1: Load main scene")
	main_instance = main_scene.instantiate()
	add_child(main_instance)
	await get_tree().process_frame  # Wait for scene to initialize
	print("  ✓ Main scene loaded\n")
	
	# Test 2: Verify sidebar exists
	print("Test 2: Verify sidebar exists")
	var sidebar = main_instance.get_node_or_null("SkillSidebar/ScrollContainer/SidebarContent")
	assert(sidebar != null, "SkillSidebar should exist")
	print("  ✓ Sidebar exists\n")
	
	# Test 3: Check for Progress button (renamed from Skill Summary)
	print("Test 3: Check for Progress button")
	var progress_button_found := false
	for child in sidebar.get_children():
		if child is Button and child.text == "Progress":
			progress_button_found = true
			print("  ✓ Found Progress button with text: '%s'" % child.text)
			break
	assert(progress_button_found, "Progress button should be present in sidebar")
	print("  ✓ Progress button exists in sidebar\n")
	
	# Test 4: Check for Settings button
	print("Test 4: Check for Settings button")
	var settings_button_found := false
	for child in sidebar.get_children():
		if child is Button and child.text == "Settings":
			settings_button_found = true
			print("  ✓ Found Settings button with text: '%s'" % child.text)
			break
	assert(settings_button_found, "Settings button should be present in sidebar")
	print("  ✓ Settings button exists in sidebar\n")
	
	# Test 5: Verify button order (Settings should come after Progress)
	print("Test 5: Verify button order")
	var progress_index := -1
	var settings_index := -1
	var children := sidebar.get_children()
	for i in range(children.size()):
		var child = children[i]
		if child is Button:
			if child.text == "Progress":
				progress_index = i
			elif child.text == "Settings":
				settings_index = i
	
	assert(progress_index != -1, "Progress button should exist")
	assert(settings_index != -1, "Settings button should exist")
	assert(settings_index > progress_index, "Settings button should come after Progress button")
	print("  ✓ Settings button comes after Progress button\n")
	
	# Test 6: Verify script has required settings functions
	print("Test 6: Verify script functions")
	var main_script = load("res://scripts/main.gd")
	assert(main_script != null, "main.gd should load")
	
	var script_source := main_script.source_code
	assert("is_settings_view" in script_source, "Script should have is_settings_view variable")
	assert("settings_button" in script_source, "Script should have settings_button variable")
	assert("settings_panel" in script_source, "Script should have settings_panel variable")
	assert("_create_settings_ui" in script_source, "Script should have _create_settings_ui function")
	assert("_on_settings_selected" in script_source, "Script should have _on_settings_selected function")
	assert("_show_settings_view" in script_source, "Script should have _show_settings_view function")
	
	print("  ✓ is_settings_view variable exists")
	print("  ✓ settings_button variable exists")
	print("  ✓ settings_panel variable exists")
	print("  ✓ _create_settings_ui function exists")
	print("  ✓ _on_settings_selected function exists")
	print("  ✓ _show_settings_view function exists\n")
	
	print("=== All Settings Button Tests Passed! ===\n")
