## Test script for inventory tabs system
extends Node

func _ready() -> void:
	print("\n=== Testing Inventory Tabs System ===\n")
	
	# Wait for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Verify main tab exists
	print("Test 1: Verifying main tab exists...")
	assert(Inventory.tabs.has(Inventory.MAIN_TAB_ID), "Main tab should exist")
	assert(Inventory.tab_order.size() >= 1, "Tab order should contain at least main tab")
	assert(Inventory.get_tab_name(Inventory.MAIN_TAB_ID) == "Main", "Main tab name should be 'Main'")
	print("  ✓ Main tab exists with correct name")
	
	# Test 2: Create new tabs
	print("\nTest 2: Creating new tabs...")
	var tab1_id := Inventory.create_tab("Tab 1")
	var tab2_id := Inventory.create_tab("Tab 2")
	assert(not tab1_id.is_empty(), "Tab 1 should be created successfully")
	assert(not tab2_id.is_empty(), "Tab 2 should be created successfully")
	assert(Inventory.tabs.size() == 3, "Should have 3 tabs total")
	print("  ✓ Created 2 new tabs, total: %d" % Inventory.tabs.size())
	
	# Test 3: Verify tab order
	print("\nTest 3: Verifying tab order...")
	assert(Inventory.tab_order.size() == 3, "Tab order should have 3 entries")
	assert(Inventory.tab_order[0] == Inventory.MAIN_TAB_ID, "First tab should be main")
	print("  ✓ Tab order is correct: %s" % str(Inventory.tab_order))
	
	# Test 4: Add items to specific tabs
	print("\nTest 4: Adding items to different tabs...")
	Inventory.add_item_to_tab(Inventory.MAIN_TAB_ID, "raw_shrimp", 10)
	Inventory.add_item_to_tab(tab1_id, "raw_sardine", 5)
	Inventory.add_item_to_tab(tab2_id, "cooked_shrimp", 3)
	
	assert(Inventory.get_item_count_in_tab(Inventory.MAIN_TAB_ID, "raw_shrimp") == 10, "Main tab should have 10 shrimp")
	assert(Inventory.get_item_count_in_tab(tab1_id, "raw_sardine") == 5, "Tab 1 should have 5 sardines")
	assert(Inventory.get_item_count_in_tab(tab2_id, "cooked_shrimp") == 3, "Tab 2 should have 3 cooked shrimp")
	print("  ✓ Items added to different tabs correctly")
	
	# Test 5: Move items between tabs
	print("\nTest 5: Moving items between tabs...")
	var move_success := Inventory.move_item_between_tabs("raw_shrimp", Inventory.MAIN_TAB_ID, tab1_id, 5)
	assert(move_success, "Should successfully move items between tabs")
	assert(Inventory.get_item_count_in_tab(Inventory.MAIN_TAB_ID, "raw_shrimp") == 5, "Main tab should have 5 shrimp left")
	assert(Inventory.get_item_count_in_tab(tab1_id, "raw_shrimp") == 5, "Tab 1 should have 5 shrimp")
	print("  ✓ Successfully moved 5 shrimp from main to tab 1")
	
	# Test 6: Verify cannot move more items than available
	print("\nTest 6: Testing move validation...")
	var invalid_move := Inventory.move_item_between_tabs("raw_shrimp", Inventory.MAIN_TAB_ID, tab2_id, 100)
	assert(not invalid_move, "Should not be able to move more items than available")
	print("  ✓ Correctly prevented invalid move")
	
	# Test 7: Rename tab
	print("\nTest 7: Renaming tab...")
	var rename_success := Inventory.rename_tab(tab1_id, "My Awesome Tab")
	assert(rename_success, "Should successfully rename tab")
	assert(Inventory.get_tab_name(tab1_id) == "My Awesome Tab", "Tab name should be updated")
	print("  ✓ Successfully renamed tab to '%s'" % Inventory.get_tab_name(tab1_id))
	
	# Test 8: Delete tab
	print("\nTest 8: Deleting tab...")
	var items_before_delete := Inventory.get_item_count_in_tab(tab2_id, "cooked_shrimp")
	var delete_success := Inventory.delete_tab(tab2_id)
	assert(delete_success, "Should successfully delete tab")
	assert(not Inventory.tabs.has(tab2_id), "Tab should no longer exist")
	assert(Inventory.tabs.size() == 2, "Should have 2 tabs left")
	
	# Items from deleted tab should be moved to main
	var items_in_main := Inventory.get_item_count_in_tab(Inventory.MAIN_TAB_ID, "cooked_shrimp")
	assert(items_in_main == items_before_delete, "Items from deleted tab should be in main tab")
	print("  ✓ Successfully deleted tab, items moved to main")
	
	# Test 9: Cannot delete main tab
	print("\nTest 9: Testing main tab protection...")
	var cannot_delete_main := Inventory.delete_tab(Inventory.MAIN_TAB_ID)
	assert(not cannot_delete_main, "Should not be able to delete main tab")
	assert(Inventory.tabs.has(Inventory.MAIN_TAB_ID), "Main tab should still exist")
	print("  ✓ Main tab is protected from deletion")
	
	# Test 10: Test max tabs limit
	print("\nTest 10: Testing maximum tabs limit...")
	var created_tabs := 0
	for i in range(20):  # Try to create many tabs
		var new_tab := Inventory.create_tab("Extra Tab %d" % i)
		if not new_tab.is_empty():
			created_tabs += 1
	assert(Inventory.tabs.size() <= Inventory.MAX_TABS, "Should not exceed maximum tab limit")
	print("  ✓ Tab limit enforced, current tabs: %d, max: %d" % [Inventory.tabs.size(), Inventory.MAX_TABS])
	
	# Test 11: Get all items from a tab
	print("\nTest 11: Getting all items from tab...")
	var main_items := Inventory.get_tab_items(Inventory.MAIN_TAB_ID)
	assert(main_items is Dictionary, "Should return dictionary of items")
	assert(main_items.has("raw_shrimp"), "Main tab should contain raw_shrimp")
	print("  ✓ Retrieved items from tab: %d items" % main_items.size())
	
	print("\n=== All Tests Passed! ===\n")
	
	# Clean up test data
	print("Cleaning up test data...")
	Inventory.clear_inventory()
	# Delete test tabs
	var tabs_to_delete := []
	for tab_id in Inventory.tab_order:
		if tab_id != Inventory.MAIN_TAB_ID:
			tabs_to_delete.append(tab_id)
	for tab_id in tabs_to_delete:
		Inventory.delete_tab(tab_id)
	print("Cleanup complete.\n")
	
	# Quit after tests
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
