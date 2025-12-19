extends Node

## Test that all log icons are loaded correctly

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	
	print("\n=== Testing Log Icons ===\n")
	
	# List of all log types
	var log_types := [
		"logs",
		"oak_logs",
		"willow_logs",
		"maple_logs",
		"yew_logs",
		"magic_logs",
		"redwood_logs",
		"achey_logs",
		"teak_logs",
		"mahogany_logs",
		"arctic_pine_logs",
		"eucalyptus_logs",
		"elder_logs",
		"blisterwood_logs",
		"bloodwood_logs",
		"crystal_logs",
		"spirit_logs"
	]
	
	var all_passed := true
	
	# Test each log type
	for log_id in log_types:
		var item_data := Inventory.get_item_data(log_id)
		
		# Check if item exists
		assert(item_data != null, "Item data for %s should exist" % log_id)
		if item_data == null:
			print("  ✗ %s - Item not found" % log_id)
			all_passed = false
			continue
		
		# Check if icon is loaded
		if item_data.icon != null:
			print("  ✓ %s - Icon loaded (size: %dx%d)" % [log_id, item_data.icon.get_width(), item_data.icon.get_height()])
		else:
			print("  ✗ %s - Icon is null" % log_id)
			all_passed = false
	
	print("\n=== Test Results ===")
	if all_passed:
		print("✓ All %d log icons loaded successfully!" % log_types.size())
	else:
		print("✗ Some log icons failed to load")
		assert(false, "Log icon test failed")
	
	print("\nTest complete!")
	get_tree().quit()
