## Test Progress and Settings Button Persistence
## Verifies that Progress and Settings buttons are not affected when skill buttons are recreated
extends Control

var main_scene = preload("res://scenes/main.tscn")
var main_instance: Control = null

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Progress and Settings Button Persistence Tests ===\n")
	
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
	
	# Test 3: Verify Progress and Settings buttons exist initially
	print("Test 3: Verify Progress and Settings buttons exist initially")
	var progress_button = _find_button_by_text(sidebar, "Progress")
	var settings_button = _find_button_by_text(sidebar, "Settings")
	assert(progress_button != null, "Progress button should exist initially")
	assert(settings_button != null, "Settings button should exist initially")
	print("  ✓ Progress button exists")
	print("  ✓ Settings button exists\n")
	
	# Test 4: Store button references to verify they persist
	print("Test 4: Store button references")
	var progress_button_ref = progress_button
	var settings_button_ref = settings_button
	print("  ✓ Stored button references\n")
	
	# Test 5: Call _create_skill_buttons() to simulate recreation
	# Note: Calling this "private" method directly is intentional for testing internal behavior.
	# This ensures the button persistence logic works correctly when skills are dynamically updated.
	print("Test 5: Recreate skill buttons")
	main_instance._create_skill_buttons()
	await get_tree().process_frame
	print("  ✓ Skill buttons recreated\n")
	
	# Test 6: Verify Progress and Settings buttons still exist after recreation
	print("Test 6: Verify buttons persist after recreation")
	var progress_button_after = _find_button_by_text(sidebar, "Progress")
	var settings_button_after = _find_button_by_text(sidebar, "Settings")
	assert(progress_button_after != null, "Progress button should exist after recreation")
	assert(settings_button_after != null, "Settings button should exist after recreation")
	print("  ✓ Progress button persists")
	print("  ✓ Settings button persists\n")
	
	# Test 7: Verify the buttons are the same instances (not recreated)
	print("Test 7: Verify buttons are same instances (not recreated)")
	assert(progress_button_ref == progress_button_after, "Progress button should be the same instance")
	assert(settings_button_ref == settings_button_after, "Settings button should be the same instance")
	print("  ✓ Progress button is same instance")
	print("  ✓ Settings button is same instance\n")
	
	print("=== All Progress and Settings Button Persistence Tests Passed! ===\n")

func _find_button_by_text(parent: Node, button_text: String) -> Button:
	for child in parent.get_children():
		if child is Button and child.text == button_text:
			return child
	return null
