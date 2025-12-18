## Test script to verify speed bonus display in skill header
extends Node

func _ready() -> void:
	print("\n=== SPEED BONUS DISPLAY TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Verify speed modifier is calculated correctly
	print("\nTest 1: Checking speed modifier calculation...")
	var fishing_speed_before := UpgradeShop.get_skill_speed_modifier("fishing")
	print("  Fishing speed modifier before upgrades: %.1f%%" % (fishing_speed_before * 100))
	assert(fishing_speed_before == 0.0, "Fishing should have no speed bonus initially")
	print("  ✓ No speed bonus without upgrades")
	
	# Test 2: Purchase an upgrade and verify modifier changes
	print("\nTest 2: Testing speed modifier after upgrade purchase...")
	Store.gold = 1000
	var purchase_result := UpgradeShop.purchase_upgrade("basic_fishing_rod")
	assert(purchase_result, "Should be able to purchase basic fishing rod")
	
	var fishing_speed_after := UpgradeShop.get_skill_speed_modifier("fishing")
	print("  Fishing speed modifier after basic rod: %.1f%%" % (fishing_speed_after * 100))
	assert(fishing_speed_after == 0.10, "Fishing should have 10% speed bonus")
	print("  ✓ Speed bonus correctly updated after upgrade")
	
	# Test 3: Verify multiple upgrades stack
	print("\nTest 3: Testing multiple upgrade stacking...")
	Store.gold = 5000
	UpgradeShop.purchase_upgrade("steel_fishing_rod")
	
	var fishing_speed_stacked := UpgradeShop.get_skill_speed_modifier("fishing")
	print("  Fishing speed modifier after 2 upgrades: %.1f%%" % (fishing_speed_stacked * 100))
	assert(fishing_speed_stacked == 0.30, "Fishing should have 30% speed bonus (10% + 20%)")
	print("  ✓ Multiple upgrades stack correctly")
	
	# Test 4: Verify different skills have independent modifiers
	print("\nTest 4: Testing skill-specific modifiers...")
	var woodcutting_speed := UpgradeShop.get_skill_speed_modifier("woodcutting")
	print("  Woodcutting speed modifier: %.1f%%" % (woodcutting_speed * 100))
	assert(woodcutting_speed == 0.0, "Woodcutting should have no speed bonus")
	print("  ✓ Different skills have independent speed modifiers")
	
	# Test 5: Purchase woodcutting upgrade
	print("\nTest 5: Testing woodcutting upgrade...")
	Store.gold = 1000
	UpgradeShop.purchase_upgrade("bronze_axe")
	
	var woodcutting_speed_after := UpgradeShop.get_skill_speed_modifier("woodcutting")
	print("  Woodcutting speed modifier after bronze axe: %.1f%%" % (woodcutting_speed_after * 100))
	assert(woodcutting_speed_after == 0.10, "Woodcutting should have 10% speed bonus")
	
	# Verify fishing still has its modifiers
	var fishing_speed_unchanged := UpgradeShop.get_skill_speed_modifier("fishing")
	assert(fishing_speed_unchanged == 0.30, "Fishing should still have 30% speed bonus")
	print("  ✓ Skill-specific modifiers remain independent")
	
	print("\n=== ALL TESTS PASSED ===")
	print("Speed bonus display feature working correctly!\n")
	print("Summary:")
	print("  - Speed modifiers calculate correctly")
	print("  - Upgrades properly affect speed bonuses")
	print("  - Multiple upgrades stack as expected")
	print("  - Each skill has independent speed modifiers")
	print("\nNote: UI display test requires manual verification in the game")
	print("      The speed bonus should appear at the top of the skill page,")
	print("      not in individual training methods.\n")
	
	# Clean up
	UpgradeShop.clear_purchased()
	Store.gold = 0
	
	# Only quit if running in headless mode (automated tests)
	if OS.has_feature("dedicated_server") or DisplayServer.get_name() == "headless":
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
