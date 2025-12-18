## Test script to verify sell from inventory functionality
extends Node

func _ready() -> void:
	print("\n=== SELL FROM INVENTORY TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Setup initial state
	print("\nTest 1: Setting up initial state...")
	Store.gold = 0
	Inventory.clear_inventory()
	print("  Initial gold: %d" % Store.get_gold())
	print("  Initial inventory count: %d items" % Inventory.get_all_items().size())
	assert(Store.get_gold() == 0, "Gold should start at 0")
	assert(Inventory.get_all_items().is_empty(), "Inventory should be empty")
	
	# Test 2: Add items to inventory
	print("\nTest 2: Adding items to inventory...")
	Inventory.add_item("raw_shrimp", 10)
	Inventory.add_item("raw_sardine", 5)
	print("  Added 10x raw_shrimp")
	print("  Added 5x raw_sardine")
	assert(Inventory.get_item_count("raw_shrimp") == 10, "Should have 10 raw shrimp")
	assert(Inventory.get_item_count("raw_sardine") == 5, "Should have 5 raw sardine")
	
	# Test 3: Sell one item
	print("\nTest 3: Testing sell one item...")
	var shrimp_data := Inventory.get_item_data("raw_shrimp")
	var expected_gold := shrimp_data.value
	var result := Store.sell_item("raw_shrimp", 1)
	print("  Sold 1x raw_shrimp for %d gold" % expected_gold)
	print("  Sell result: %s" % result)
	print("  Current gold: %d" % Store.get_gold())
	print("  Remaining shrimp: %d" % Inventory.get_item_count("raw_shrimp"))
	assert(result, "Sell should succeed")
	assert(Store.get_gold() == expected_gold, "Should have earned gold from selling")
	assert(Inventory.get_item_count("raw_shrimp") == 9, "Should have 9 raw shrimp left")
	
	# Test 4: Sell all items of a type
	print("\nTest 4: Testing sell all items...")
	var sardine_data := Inventory.get_item_data("raw_sardine")
	var sardine_count := Inventory.get_item_count("raw_sardine")
	var expected_total_gold := Store.get_gold() + (sardine_data.value * sardine_count)
	result = Store.sell_item("raw_sardine", sardine_count)
	print("  Sold %dx raw_sardine for %d gold" % [sardine_count, sardine_data.value * sardine_count])
	print("  Sell result: %s" % result)
	print("  Current gold: %d" % Store.get_gold())
	print("  Remaining sardine: %d" % Inventory.get_item_count("raw_sardine"))
	assert(result, "Sell all should succeed")
	assert(Store.get_gold() == expected_total_gold, "Should have earned gold from selling all")
	assert(Inventory.get_item_count("raw_sardine") == 0, "Should have no sardine left")
	
	# Test 5: Try to sell item not in inventory
	print("\nTest 5: Testing sell item not in inventory...")
	var gold_before := Store.get_gold()
	result = Store.sell_item("raw_lobster", 1)
	print("  Tried to sell raw_lobster (not owned)")
	print("  Sell result: %s" % result)
	print("  Gold unchanged: %s" % (Store.get_gold() == gold_before))
	assert(not result, "Sell should fail for item not in inventory")
	assert(Store.get_gold() == gold_before, "Gold should not change")
	
	# Test 6: Try to sell more than owned
	print("\nTest 6: Testing sell more than owned...")
	gold_before = Store.get_gold()
	var shrimp_before := Inventory.get_item_count("raw_shrimp")
	result = Store.sell_item("raw_shrimp", 100)
	print("  Tried to sell 100 raw_shrimp (only have %d)" % shrimp_before)
	print("  Sell result: %s" % result)
	print("  Shrimp count unchanged: %s" % (Inventory.get_item_count("raw_shrimp") == shrimp_before))
	assert(not result, "Sell should fail when trying to sell more than owned")
	assert(Inventory.get_item_count("raw_shrimp") == shrimp_before, "Item count should not change")
	assert(Store.get_gold() == gold_before, "Gold should not change")
	
	# Test 7: Verify inventory signals are working
	print("\nTest 7: Testing inventory update signals...")
	var signal_received := false
	var signal_callback := func():
		signal_received = true
		print("  Inventory update signal received!")
	
	Inventory.inventory_updated.connect(signal_callback)
	Store.sell_item("raw_shrimp", 1)
	await get_tree().process_frame  # Wait for signal to propagate
	assert(signal_received, "Inventory update signal should be emitted")
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Clean up
	Inventory.clear_inventory()
	Store.gold = 0
	print("Cleaned up test state")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
