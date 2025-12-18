## Test script to verify item detail popup functionality
extends Node

func _ready() -> void:
	print("\n=== ITEM DETAIL POPUP TEST ===")
	
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
	Inventory.add_item("cooked_salmon", 3)
	print("  Added 10x raw_shrimp")
	print("  Added 5x raw_sardine")
	print("  Added 3x cooked_salmon")
	assert(Inventory.get_item_count("raw_shrimp") == 10, "Should have 10 raw shrimp")
	assert(Inventory.get_item_count("raw_sardine") == 5, "Should have 5 raw sardine")
	assert(Inventory.get_item_count("cooked_salmon") == 3, "Should have 3 cooked salmon")
	
	# Test 3: Verify item data retrieval
	print("\nTest 3: Verifying item data...")
	var shrimp_data := Inventory.get_item_data("raw_shrimp")
	assert(shrimp_data != null, "Should have data for raw_shrimp")
	assert(shrimp_data.name == "Raw Shrimp", "Should have correct name")
	assert(shrimp_data.description == "A small shrimp.", "Should have correct description")
	assert(shrimp_data.value == 5, "Should have correct value")
	print("  raw_shrimp data: name='%s', value=%d" % [shrimp_data.name, shrimp_data.value])
	
	# Test 4: Calculate stack values
	print("\nTest 4: Calculating stack values...")
	var shrimp_count := Inventory.get_item_count("raw_shrimp")
	var shrimp_stack_value := shrimp_data.value * shrimp_count
	print("  raw_shrimp: %d items x %d gold = %d gold" % [shrimp_count, shrimp_data.value, shrimp_stack_value])
	assert(shrimp_stack_value == 50, "Stack value should be 50 (10 x 5)")
	
	var sardine_data := Inventory.get_item_data("raw_sardine")
	var sardine_count := Inventory.get_item_count("raw_sardine")
	var sardine_stack_value := sardine_data.value * sardine_count
	print("  raw_sardine: %d items x %d gold = %d gold" % [sardine_count, sardine_data.value, sardine_stack_value])
	assert(sardine_stack_value == 50, "Stack value should be 50 (5 x 10)")
	
	# Test 5: Test selling from popup
	print("\nTest 5: Testing sell functionality...")
	
	# Sell one item
	var gold_before := Store.get_gold()
	var count_before := Inventory.get_item_count("raw_shrimp")
	var success := Store.sell_item("raw_shrimp", 1)
	assert(success, "Sell should succeed")
	assert(Store.get_gold() == gold_before + shrimp_data.value, "Gold should increase by item value")
	assert(Inventory.get_item_count("raw_shrimp") == count_before - 1, "Item count should decrease")
	print("  Sold 1 raw_shrimp: gold %d -> %d, count %d -> %d" % [gold_before, Store.get_gold(), count_before, Inventory.get_item_count("raw_shrimp")])
	
	# Sell multiple items (10 or all if less)
	gold_before = Store.get_gold()
	count_before = Inventory.get_item_count("raw_sardine")
	var sell_amount := min(10, count_before)
	success = Store.sell_item("raw_sardine", sell_amount)
	assert(success, "Sell multiple should succeed")
	assert(Store.get_gold() == gold_before + (sardine_data.value * sell_amount), "Gold should increase correctly")
	assert(Inventory.get_item_count("raw_sardine") == count_before - sell_amount, "Item count should decrease correctly")
	print("  Sold %d raw_sardine: gold %d -> %d, count %d -> %d" % [sell_amount, gold_before, Store.get_gold(), count_before, Inventory.get_item_count("raw_sardine")])
	
	# Sell all items
	var salmon_data := Inventory.get_item_data("cooked_salmon")
	gold_before = Store.get_gold()
	count_before = Inventory.get_item_count("cooked_salmon")
	success = Store.sell_item("cooked_salmon", count_before)
	assert(success, "Sell all should succeed")
	assert(Store.get_gold() == gold_before + (salmon_data.value * count_before), "Gold should increase correctly")
	assert(Inventory.get_item_count("cooked_salmon") == 0, "Item should be gone from inventory")
	print("  Sold all %d cooked_salmon: gold %d -> %d, count %d -> 0" % [count_before, gold_before, Store.get_gold(), count_before])
	
	# Test 6: Verify item no longer in inventory after selling all
	print("\nTest 6: Verifying item removal from inventory...")
	var items := Inventory.get_all_items()
	assert(not items.has("cooked_salmon"), "Sold out item should not be in inventory")
	assert(items.has("raw_shrimp"), "Remaining items should still be in inventory")
	print("  cooked_salmon removed from inventory: %s" % (not items.has("cooked_salmon")))
	print("  raw_shrimp still in inventory: %s" % items.has("raw_shrimp"))
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Clean up
	Inventory.clear_inventory()
	Store.gold = 0
	print("Cleaned up test state")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
