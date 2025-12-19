extends Node

## Test that inventory display shows icons correctly

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	
	print("\n=== Testing Inventory Icon Display ===\n")
	
	# Add some items with icons to the inventory
	Inventory.add_item("logs", 5)
	Inventory.add_item("oak_logs", 3)
	Inventory.add_item("willow_logs", 10)
	
	# Add some items without icons
	Inventory.add_item("raw_shrimp", 20)
	
	print("Added items to inventory:")
	print("  - logs (with icon): 5")
	print("  - oak_logs (with icon): 3")
	print("  - willow_logs (with icon): 10")
	print("  - raw_shrimp (no icon): 20")
	
	# Test that items with icons have the icon property set
	var logs_data := Inventory.get_item_data("logs")
	assert(logs_data != null, "logs item data should exist")
	assert(logs_data.icon != null, "logs should have an icon")
	print("\n✓ logs item has icon: %dx%d" % [logs_data.icon.get_width(), logs_data.icon.get_height()])
	
	var oak_logs_data := Inventory.get_item_data("oak_logs")
	assert(oak_logs_data != null, "oak_logs item data should exist")
	assert(oak_logs_data.icon != null, "oak_logs should have an icon")
	print("✓ oak_logs item has icon: %dx%d" % [oak_logs_data.icon.get_width(), oak_logs_data.icon.get_height()])
	
	# Test that items without icons don't crash the system
	var shrimp_data := Inventory.get_item_data("raw_shrimp")
	assert(shrimp_data != null, "raw_shrimp item data should exist")
	print("✓ raw_shrimp item data exists (icon: %s)" % ("present" if shrimp_data.icon else "null"))
	
	print("\n=== Test Results ===")
	print("✓ All inventory icon display tests passed!")
	print("\nTest complete!")
	get_tree().quit()
