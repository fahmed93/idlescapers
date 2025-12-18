## Test script to verify Mining gem finding functionality
extends Node

func _ready() -> void:
	print("\n=== MINING GEMS TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that Mining skill is registered
	print("\nTest 1: Checking Mining skill is registered...")
	var mining_skill = GameManager.skills.get("mining")
	assert(mining_skill != null, "Mining skill should be registered")
	print("  ✓ Mining skill found: %s" % mining_skill.name)
	
	# Test 2: Check that gem items exist
	print("\nTest 2: Checking gem items are registered...")
	var sapphire = Inventory.get_item_data("sapphire")
	var emerald = Inventory.get_item_data("emerald")
	var ruby = Inventory.get_item_data("ruby")
	var diamond = Inventory.get_item_data("diamond")
	
	assert(sapphire != null, "Sapphire should be registered")
	print("  ✓ Sapphire: %s (value: %d)" % [sapphire.description, sapphire.value])
	
	assert(emerald != null, "Emerald should be registered")
	print("  ✓ Emerald: %s (value: %d)" % [emerald.description, emerald.value])
	
	assert(ruby != null, "Ruby should be registered")
	print("  ✓ Ruby: %s (value: %d)" % [ruby.description, ruby.value])
	
	assert(diamond != null, "Diamond should be registered")
	print("  ✓ Diamond: %s (value: %d)" % [diamond.description, diamond.value])
	
	# Test 3: Check that mining methods have bonus_items
	print("\nTest 3: Checking mining methods have bonus gems...")
	var training_methods = mining_skill.training_methods
	var copper_method = null
	
	for method in training_methods:
		if method.id == "copper_ore":
			copper_method = method
			break
	
	assert(copper_method != null, "Copper mining method should exist")
	assert(not copper_method.bonus_items.is_empty(), "Copper mining should have bonus items")
	assert(copper_method.bonus_items.has("sapphire"), "Should have sapphire as bonus")
	assert(copper_method.bonus_items.has("emerald"), "Should have emerald as bonus")
	assert(copper_method.bonus_items.has("ruby"), "Should have ruby as bonus")
	assert(copper_method.bonus_items.has("diamond"), "Should have diamond as bonus")
	
	print("  ✓ Copper ore has bonus gems:")
	for gem in copper_method.bonus_items:
		var chance = copper_method.bonus_items[gem]
		print("    - %s: %.1f%% chance" % [gem, chance * 100])
	
	# Test 4: Verify gem rarity decreases for higher tier gems
	print("\nTest 4: Verifying gem rarity (higher tier = lower chance)...")
	var sapphire_chance = copper_method.bonus_items["sapphire"]
	var emerald_chance = copper_method.bonus_items["emerald"]
	var ruby_chance = copper_method.bonus_items["ruby"]
	var diamond_chance = copper_method.bonus_items["diamond"]
	
	assert(sapphire_chance > emerald_chance, "Sapphire should be more common than emerald")
	assert(emerald_chance > ruby_chance, "Emerald should be more common than ruby")
	assert(ruby_chance > diamond_chance, "Ruby should be more common than diamond")
	print("  ✓ Gem rarity verified: Sapphire > Emerald > Ruby > Diamond")
	
	# Test 5: Test mining simulation to get gems
	print("\nTest 5: Testing mining simulation for gem drops...")
	print("  Mining copper ore 1000 times to collect gems...")
	
	# Clear inventory first
	Inventory.clear_inventory()
	
	var initial_level = GameManager.get_skill_level("mining")
	print("  Initial Mining level: %d" % initial_level)
	
	# Start mining
	var start_result = GameManager.start_training("mining", "copper_ore")
	assert(start_result, "Should be able to start mining copper")
	print("  ✓ Training started successfully")
	
	# Simulate mining actions by running enough time
	# Copper ore takes 2.5s per action, so 1000 actions = 2500s
	# We'll run for a reasonable time and check for gems
	var actions_completed := 0
	var target_actions := 1000
	
	# Connect to action_completed signal to count
	var action_counter := func(skill_id: String, method_id: String, success: bool):
		if skill_id == "mining" and method_id == "copper_ore":
			actions_completed += 1
	
	GameManager.action_completed.connect(action_counter)
	
	# Manually trigger actions for testing
	while actions_completed < target_actions:
		GameManager._complete_action(copper_method)
	
	GameManager.action_completed.disconnect(action_counter)
	GameManager.stop_training()
	
	# Check results
	var copper_count = Inventory.get_item_count("copper_ore")
	var sapphire_count = Inventory.get_item_count("sapphire")
	var emerald_count = Inventory.get_item_count("emerald")
	var ruby_count = Inventory.get_item_count("ruby")
	var diamond_count = Inventory.get_item_count("diamond")
	
	print("\n  Results after %d actions:" % actions_completed)
	print("    Copper Ore: %d" % copper_count)
	print("    Sapphires: %d (%.2f%%)" % [sapphire_count, (float(sapphire_count) / actions_completed) * 100])
	print("    Emeralds: %d (%.2f%%)" % [emerald_count, (float(emerald_count) / actions_completed) * 100])
	print("    Rubies: %d (%.2f%%)" % [ruby_count, (float(ruby_count) / actions_completed) * 100])
	print("    Diamonds: %d (%.2f%%)" % [diamond_count, (float(diamond_count) / actions_completed) * 100])
	
	# At least some gems should have been found
	var total_gems = sapphire_count + emerald_count + ruby_count + diamond_count
	assert(total_gems > 0, "Should have found at least some gems after 1000 actions")
	print("  ✓ Total gems found: %d" % total_gems)
	
	# Verify gem rarity in actual drops
	if sapphire_count > 0 and emerald_count > 0:
		assert(sapphire_count > emerald_count, "Sapphires should be more common than emeralds in drops")
		print("  ✓ Sapphires are more common than emeralds in drops")
	
	if emerald_count > 0 and ruby_count > 0:
		assert(emerald_count > ruby_count, "Emeralds should be more common than rubies in drops")
		print("  ✓ Emeralds are more common than rubies in drops")
	
	print("\n=== ALL TESTS PASSED ===")
	print("Mining gem finding is working correctly!\n")
	
	# Only quit if running in headless mode (automated tests)
	if DisplayServer.get_name() == "headless":
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
