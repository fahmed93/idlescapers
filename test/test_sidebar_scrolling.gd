## Test Sidebar Mobile Scrolling
## Verifies that the sidebar ScrollContainer has the mobile scroll script attached
extends Control

var main_scene := preload("res://scenes/main.tscn")
var main_instance: Control = null

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Sidebar Mobile Scrolling Tests ===\n")
	
	# Test 1: Load main scene
	print("Test 1: Load main scene")
	main_instance = main_scene.instantiate()
	add_child(main_instance)
	await get_tree().process_frame  # Wait for scene to initialize
	print("  ✓ Main scene loaded\n")
	
	# Test 2: Verify sidebar ScrollContainer exists
	print("Test 2: Verify sidebar ScrollContainer exists")
	var scroll_container := main_instance.get_node_or_null("SkillSidebar/ScrollContainer")
	assert(scroll_container != null, "Sidebar ScrollContainer should exist")
	assert(scroll_container is ScrollContainer, "Node should be a ScrollContainer")
	print("  ✓ Sidebar ScrollContainer exists\n")
	
	# Test 3: Verify mobile scroll script is attached
	print("Test 3: Verify mobile scroll script is attached")
	var script := scroll_container.get_script()
	assert(script != null, "ScrollContainer should have a script attached")
	var script_path: String = script.resource_path
	assert("mobile_scroll_container.gd" in script_path, "Script should be mobile_scroll_container.gd, got: %s" % script_path)
	print("  ✓ Mobile scroll script is attached: %s\n" % script_path)
	
	# Test 4: Verify follow_focus is disabled
	print("Test 4: Verify follow_focus is disabled")
	assert(scroll_container.follow_focus == false, "follow_focus should be disabled for mobile")
	print("  ✓ follow_focus is disabled\n")
	
	# Test 5: Verify horizontal scrolling is disabled
	print("Test 5: Verify horizontal scrolling is disabled")
	assert(scroll_container.horizontal_scroll_mode == ScrollContainer.SCROLL_MODE_DISABLED, "Horizontal scrolling should be disabled")
	print("  ✓ Horizontal scrolling is disabled\n")
	
	# Test 6: Verify sidebar has scrollable content (buttons)
	print("Test 6: Verify sidebar has scrollable content")
	var sidebar_content := main_instance.get_node_or_null("SkillSidebar/ScrollContainer/SidebarContent")
	assert(sidebar_content != null, "SidebarContent should exist")
	
	var button_count := 0
	for child in sidebar_content.get_children():
		if child is Button:
			button_count += 1
	
	assert(button_count > 0, "Sidebar should have buttons")
	print("  ✓ Sidebar has %d buttons (content to scroll)\n" % button_count)
	
	print("=== All Sidebar Mobile Scrolling Tests Passed! ===\n")
	print("Note: Manual testing required to verify actual scrolling behavior in Godot editor or on device\n")
