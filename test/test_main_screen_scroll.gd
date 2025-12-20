## Test Main Screen Mobile Scrolling
## Verifies that all ScrollContainers in the main screen have the mobile scroll script attached
extends Control

var main_scene := preload("res://scenes/main.tscn")
var main_instance: Control = null

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Main Screen Mobile Scrolling Tests ===\n")
	
	# Test 1: Load main scene
	print("Test 1: Load main scene")
	main_instance = main_scene.instantiate()
	add_child(main_instance)
	await get_tree().process_frame  # Wait for scene to initialize
	print("  ✓ Main scene loaded\n")
	
	# Test 2: Verify action list ScrollContainer has mobile scroll script
	print("Test 2: Verify action list ScrollContainer has mobile scroll script")
	var action_scroll := main_instance.get_node_or_null("MainContent/ActionList/ScrollContainer")
	assert(action_scroll != null, "Action list ScrollContainer should exist")
	assert(action_scroll is ScrollContainer, "Node should be a ScrollContainer")
	var action_script := action_scroll.get_script()
	assert(action_script != null, "Action list ScrollContainer should have a script attached")
	var action_script_path: String = action_script.resource_path
	assert("mobile_scroll_container.gd" in action_script_path, "Script should be mobile_scroll_container.gd, got: %s" % action_script_path)
	print("  ✓ Action list has mobile scroll script\n")
	
	# Test 3: Verify inventory panel ScrollContainer has mobile scroll script
	print("Test 3: Verify inventory panel ScrollContainer has mobile scroll script")
	var inventory_scroll := main_instance.get_node_or_null("MainContent/InventoryPanel/VBoxContainer/ScrollContainer")
	assert(inventory_scroll != null, "Inventory panel ScrollContainer should exist")
	assert(inventory_scroll is ScrollContainer, "Node should be a ScrollContainer")
	var inventory_script := inventory_scroll.get_script()
	assert(inventory_script != null, "Inventory panel ScrollContainer should have a script attached")
	var inventory_script_path: String = inventory_script.resource_path
	assert("mobile_scroll_container.gd" in inventory_script_path, "Script should be mobile_scroll_container.gd, got: %s" % inventory_script_path)
	print("  ✓ Inventory panel has mobile scroll script\n")
	
	# Test 4: Verify dynamically created ScrollContainers have mobile scroll script
	print("Test 4: Verify dynamically created ScrollContainers")
	
	# Trigger inventory view to create the inventory ScrollContainer
	main_instance._on_inventory_selected()
	await get_tree().process_frame
	
	var inventory_panel_view := main_instance.inventory_panel_view
	assert(inventory_panel_view != null, "Inventory panel view should be created")
	
	# Find the ScrollContainer in the inventory panel view
	var inv_scroll: ScrollContainer = null
	for child in inventory_panel_view.get_children():
		if child is VBoxContainer:
			for vbox_child in child.get_children():
				if vbox_child is ScrollContainer:
					inv_scroll = vbox_child
					break
			if inv_scroll:
				break
	
	assert(inv_scroll != null, "Inventory view ScrollContainer should exist")
	var inv_scroll_script := inv_scroll.get_script()
	assert(inv_scroll_script != null, "Inventory view ScrollContainer should have a script")
	var inv_scroll_script_path: String = inv_scroll_script.resource_path
	assert("mobile_scroll_container.gd" in inv_scroll_script_path, "Script should be mobile_scroll_container.gd, got: %s" % inv_scroll_script_path)
	print("  ✓ Inventory view has mobile scroll script\n")
	
	# Test equipment view
	main_instance._on_equipment_selected()
	await get_tree().process_frame
	
	var equipment_panel_view := main_instance.equipment_panel_view
	assert(equipment_panel_view != null, "Equipment panel view should be created")
	
	var equip_scroll: ScrollContainer = null
	for child in equipment_panel_view.get_children():
		if child is VBoxContainer:
			for vbox_child in child.get_children():
				if vbox_child is ScrollContainer:
					equip_scroll = vbox_child
					break
			if equip_scroll:
				break
	
	assert(equip_scroll != null, "Equipment view ScrollContainer should exist")
	var equip_scroll_script := equip_scroll.get_script()
	assert(equip_scroll_script != null, "Equipment view ScrollContainer should have a script")
	var equip_scroll_script_path: String = equip_scroll_script.resource_path
	assert("mobile_scroll_container.gd" in equip_scroll_script_path, "Script should be mobile_scroll_container.gd, got: %s" % equip_scroll_script_path)
	print("  ✓ Equipment view has mobile scroll script\n")
	
	# Test upgrades view
	main_instance._on_upgrades_selected()
	await get_tree().process_frame
	
	var upgrades_panel := main_instance.upgrades_panel
	assert(upgrades_panel != null, "Upgrades panel should be created")
	
	var upgrades_scroll: ScrollContainer = null
	for child in upgrades_panel.get_children():
		if child is VBoxContainer:
			for vbox_child in child.get_children():
				if vbox_child is ScrollContainer:
					upgrades_scroll = vbox_child
					break
			if upgrades_scroll:
				break
	
	assert(upgrades_scroll != null, "Upgrades view ScrollContainer should exist")
	var upgrades_scroll_script := upgrades_scroll.get_script()
	assert(upgrades_scroll_script != null, "Upgrades view ScrollContainer should have a script")
	var upgrades_scroll_script_path: String = upgrades_scroll_script.resource_path
	assert("mobile_scroll_container.gd" in upgrades_scroll_script_path, "Script should be mobile_scroll_container.gd, got: %s" % upgrades_scroll_script_path)
	print("  ✓ Upgrades view has mobile scroll script\n")
	
	print("=== All Main Screen Mobile Scrolling Tests Passed! ===\n")
	print("Note: Manual testing required to verify actual scrolling behavior in Godot editor or on device\n")
