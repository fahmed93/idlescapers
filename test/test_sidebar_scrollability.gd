## Test Sidebar Scrollability and Header Visibility
## Verifies that the sidebar is scrollable and header buttons remain visible
extends Control

var main_scene = preload("res://scenes/main.tscn")
var main_instance: Control = null

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Sidebar Scrollability and Header Tests ===\n")
	
	# Test 1: Load main scene
	print("Test 1: Load main scene")
	main_instance = main_scene.instantiate()
	add_child(main_instance)
	await get_tree().process_frame  # Wait for scene to initialize
	print("  ✓ Main scene loaded\n")
	
	# Test 2: Verify ScrollContainer exists and wraps sidebar
	print("Test 2: Verify ScrollContainer exists")
	var scroll_container = main_instance.get_node_or_null("HSplitContainer/SidebarScrollContainer")
	assert(scroll_container != null, "SidebarScrollContainer should exist")
	assert(scroll_container is ScrollContainer, "Should be a ScrollContainer")
	print("  ✓ ScrollContainer exists\n")
	
	# Test 3: Verify sidebar is inside ScrollContainer
	print("Test 3: Verify sidebar is inside ScrollContainer")
	var sidebar = main_instance.get_node_or_null("HSplitContainer/SidebarScrollContainer/SkillSidebar")
	assert(sidebar != null, "SkillSidebar should exist inside ScrollContainer")
	assert(sidebar is VBoxContainer, "Should be a VBoxContainer")
	print("  ✓ Sidebar is properly nested in ScrollContainer\n")
	
	# Test 4: Verify horizontal scroll is disabled
	print("Test 4: Verify horizontal scroll is disabled")
	assert(scroll_container.horizontal_scroll_mode == ScrollContainer.SCROLL_MODE_DISABLED, 
		"Horizontal scroll should be disabled")
	print("  ✓ Horizontal scroll is disabled\n")
	
	# Test 5: Verify MenuButton has z-index
	print("Test 5: Verify MenuButton has proper z-index")
	var menu_button = main_instance.get_node_or_null("MenuButton")
	assert(menu_button != null, "MenuButton should exist")
	assert(menu_button.z_index == 100, "MenuButton should have z_index of 100")
	print("  ✓ MenuButton has z_index = 100\n")
	
	# Test 6: Verify ChangeCharacterButton has z-index
	print("Test 6: Verify ChangeCharacterButton has proper z-index")
	var change_char_button = main_instance.get_node_or_null("ChangeCharacterButton")
	assert(change_char_button != null, "ChangeCharacterButton should exist")
	assert(change_char_button.z_index == 100, "ChangeCharacterButton should have z_index of 100")
	print("  ✓ ChangeCharacterButton has z_index = 100\n")
	
	# Test 7: Verify sidebar starts collapsed
	print("Test 7: Verify sidebar starts collapsed")
	assert(scroll_container.visible == false, "Sidebar should start collapsed (invisible)")
	print("  ✓ Sidebar starts collapsed\n")
	
	# Test 8: Verify Equipment button exists in sidebar
	print("Test 8: Verify Equipment button exists")
	var equipment_button_found := false
	for child in sidebar.get_children():
		if child is Button and child.text == "Equipment":
			equipment_button_found = true
			print("  ✓ Found Equipment button")
			break
	assert(equipment_button_found, "Equipment button should be present in sidebar")
	print("  ✓ Equipment button is in sidebar\n")
	
	# Test 9: Test sidebar visibility toggle
	print("Test 9: Test sidebar visibility toggle")
	# Simulate menu button press
	var initial_visibility := scroll_container.visible
	menu_button.pressed.emit()
	await get_tree().process_frame
	var after_toggle_visibility := scroll_container.visible
	assert(initial_visibility != after_toggle_visibility, "Sidebar visibility should toggle")
	print("  ✓ Sidebar visibility toggles correctly\n")
	
	print("=== All Sidebar Scrollability and Header Tests Passed! ===\n")
