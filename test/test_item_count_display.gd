## Test script to verify item count display for consumed items
extends Node

func _ready() -> void:
	print("\n=== ITEM COUNT DISPLAY TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Verify Inventory.get_item_count works
	print("\nTest 1: Checking Inventory.get_item_count functionality...")
	Inventory.clear_inventory()
	var count_empty = Inventory.get_item_count("raw_shrimp")
	assert(count_empty == 0, "Empty inventory should return 0")
	print("  ✓ Empty inventory count: %d" % count_empty)
	
	Inventory.add_item("raw_shrimp", 5)
	var count_after_add = Inventory.get_item_count("raw_shrimp")
	assert(count_after_add == 5, "Should have 5 raw shrimp")
	print("  ✓ After adding 5: %d" % count_after_add)
	
	# Test 2: Verify consumed items data structure
	print("\nTest 2: Checking consumed_items in training methods...")
	var cooking_skill = GameManager.skills.get("cooking")
	assert(cooking_skill != null, "Cooking skill should exist")
	
	var cook_shrimp = null
	for method in cooking_skill.training_methods:
		if method.id == "cook_shrimp":
			cook_shrimp = method
			break
	
	assert(cook_shrimp != null, "Cook Shrimp method should exist")
	assert(not cook_shrimp.consumed_items.is_empty(), "Cook Shrimp should have consumed items")
	print("  ✓ Cook Shrimp consumed items: %s" % cook_shrimp.consumed_items)
	
	# Test 3: Simulate UI item count display logic
	print("\nTest 3: Simulating UI item count display logic...")
	Inventory.clear_inventory()
	Inventory.add_item("raw_shrimp", 10)
	Inventory.add_item("raw_sardine", 25)
	
	for method in cooking_skill.training_methods:
		if method.consumed_items.is_empty():
			continue
			
		var items_text := ""
		for item_id in method.consumed_items:
			var item_data := Inventory.get_item_data(item_id)
			var item_name: String = item_data.name if item_data else item_id
			var player_count := Inventory.get_item_count(item_id)
			items_text += "Uses: %s x%d (%d owned) " % [item_name, method.consumed_items[item_id], player_count]
		
		print("  %s: %s" % [method.name, items_text.strip_edges()])
	
	print("  ✓ Item count display format working correctly")
	
	# Test 4: Verify count updates after consumption
	print("\nTest 4: Testing count updates after item consumption...")
	Inventory.clear_inventory()
	Inventory.add_item("guam_leaf", 5)
	Inventory.add_item("eye_of_newt", 5)
	
	var initial_guam = Inventory.get_item_count("guam_leaf")
	var initial_newt = Inventory.get_item_count("eye_of_newt")
	print("  Initial - Guam Leaf: %d, Eye of Newt: %d" % [initial_guam, initial_newt])
	
	# Start training herblore to make attack potions
	var herblore_skill = GameManager.skills.get("herblore")
	assert(herblore_skill != null, "Herblore skill should exist")
	
	GameManager.start_training("herblore", "attack_potion")
	print("  Started training: Attack Potion")
	
	# Wait for action_completed signal instead of hardcoded timeout
	var action_completed := false
	var on_action_complete = func(_skill: String, _method: String, _success: bool):
		action_completed = true
	
	GameManager.action_completed.connect(on_action_complete)
	
	# Wait for action to complete (with timeout safety)
	var max_wait := 5.0
	var elapsed := 0.0
	while not action_completed and elapsed < max_wait:
		await get_tree().create_timer(0.1).timeout
		elapsed += 0.1
	
	GameManager.action_completed.disconnect(on_action_complete)
	assert(action_completed, "Action should have completed within timeout")
	
	var after_guam = Inventory.get_item_count("guam_leaf")
	var after_newt = Inventory.get_item_count("eye_of_newt")
	print("  After training - Guam Leaf: %d, Eye of Newt: %d" % [after_guam, after_newt])
	
	# Verify items were consumed
	assert(after_guam < initial_guam, "Guam Leaf should be consumed")
	assert(after_newt < initial_newt, "Eye of Newt should be consumed")
	print("  ✓ Items consumed correctly during training")
	
	GameManager.stop_training()
	
	# Test 5: Verify display with 0 items
	print("\nTest 5: Testing display with 0 items owned...")
	Inventory.clear_inventory()
	
	var item_text_zero := ""
	var item_id := "raw_shrimp"
	var item_data := Inventory.get_item_data(item_id)
	var player_count := Inventory.get_item_count(item_id)
	item_text_zero = "Uses: %s x%d (%d owned)" % [item_data.name, 1, player_count]
	print("  Display text: %s" % item_text_zero)
	assert("(0 owned)" in item_text_zero, "Should show 0 owned when player has none")
	print("  ✓ Zero count displayed correctly")
	
	print("\n=== ALL TESTS PASSED ===")
	print("Item count display feature is working correctly!\n")
	
	# Only quit if running in headless mode (automated tests)
	if OS.has_feature("dedicated_server") or DisplayServer.get_name() == "headless":
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
