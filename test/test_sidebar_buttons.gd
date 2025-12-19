## Test Sidebar Buttons
## Verifies that all special buttons (Equipment, Inventory, Upgrades, Progress, Settings) are present in the sidebar
extends Control

var main_scene = preload("res://scenes/main.tscn")
var main_instance: Control = null

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Sidebar Buttons Tests ===\n")
	
	# Test 1: Load main scene
	print("Test 1: Load main scene")
	main_instance = main_scene.instantiate()
	add_child(main_instance)
	await get_tree().process_frame  # Wait for scene to initialize
	print("  ✓ Main scene loaded\n")
	
	# Test 2: Verify sidebar exists
	print("Test 2: Verify sidebar exists")
	var sidebar = main_instance.get_node_or_null("HSplitContainer/SkillSidebar")
	assert(sidebar != null, "SkillSidebar should exist")
	print("  ✓ Sidebar exists\n")
	
	# Test 3: Check for equipment button
	print("Test 3: Check for equipment button")
	var equipment_button_found := false
	for child in sidebar.get_children():
		if child is Button and child.text == "Equipment":
			equipment_button_found = true
			print("  ✓ Found Equipment button with text: '%s'" % child.text)
			break
	assert(equipment_button_found, "Equipment button should be present in sidebar")
	print("  ✓ Equipment button exists in sidebar\n")
	
	# Test 4: Check for inventory button
	print("Test 4: Check for inventory button")
	var inventory_button_found := false
	for child in sidebar.get_children():
		if child is Button and child.text == "Inventory":
			inventory_button_found = true
			print("  ✓ Found Inventory button with text: '%s'" % child.text)
			break
	assert(inventory_button_found, "Inventory button should be present in sidebar")
	print("  ✓ Inventory button exists in sidebar\n")
	
	# Test 5: Check for upgrades button
	print("Test 5: Check for upgrades button")
	var upgrades_button_found := false
	for child in sidebar.get_children():
		if child is Button and child.text == "Upgrades":
			upgrades_button_found = true
			print("  ✓ Found Upgrades button with text: '%s'" % child.text)
			break
	assert(upgrades_button_found, "Upgrades button should be present in sidebar")
	print("  ✓ Upgrades button exists in sidebar\n")
	
	# Test 6: Verify all three special buttons are present
	print("Test 6: Count special buttons")
	var special_buttons := []
	for child in sidebar.get_children():
		if child is Button:
			var text: String = child.text
			if text == "Equipment" or text == "Inventory" or text == "Upgrades":
				special_buttons.append(text)
	
	print("  Found special buttons: %s" % str(special_buttons))
	assert(special_buttons.size() == 3, "Should have exactly 3 special buttons (Equipment, Inventory, Upgrades)")
	assert("Equipment" in special_buttons, "Equipment should be in special buttons")
	assert("Inventory" in special_buttons, "Inventory should be in special buttons")
	assert("Upgrades" in special_buttons, "Upgrades should be in special buttons")
	print("  ✓ All 3 special buttons present\n")
	
	# Test 7: Verify skill buttons also exist
	print("Test 7: Verify skill buttons exist")
	var skill_button_count := 0
	var total_button_count := 0
	for child in sidebar.get_children():
		if child is Button:
			total_button_count += 1
			var text: String = child.text
			# Special buttons have single-word text without newlines
			# Skill buttons have format like "Fishing\nLv. 1" (multiline with level)
			# Also exclude Info section buttons (Progress, Settings)
			if text not in ["Equipment", "Inventory", "Upgrades", "Progress", "Settings"]:
				skill_button_count += 1
	
	print("  Found %d total buttons (%d skill + 3 player + 2 info)" % [total_button_count, skill_button_count])
	assert(skill_button_count > 0, "Should have at least one skill button")
	assert(total_button_count == skill_button_count + 3 + 2, "Total buttons should equal skill buttons + 3 player buttons + 2 info buttons")
	print("  ✓ Skill buttons are present alongside special buttons\n")
	
	print("=== All Sidebar Button Tests Passed! ===\n")
