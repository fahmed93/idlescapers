## Test script to verify skill cape functionality
extends Node

func _ready() -> void:
	print("\n=== SKILL CAPES TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that all 15 skill capes are loaded
	print("\nTest 1: Checking skill capes loaded...")
	var skill_ids := [
		"fishing", "cooking", "woodcutting", "fletching", "mining",
		"firemaking", "smithing", "herblore", "thieving", "agility",
		"astrology", "jewelcrafting", "skinning", "foraging", "crafting"
	]
	
	var cape_count := 0
	for skill_id in skill_ids:
		var upgrades := UpgradeShop.get_upgrades_for_skill(skill_id)
		for upgrade in upgrades:
			if upgrade.is_skill_cape:
				cape_count += 1
				print("  ✓ Found %s cape for %s" % [upgrade.name, skill_id])
				assert(upgrade.level_required == 99, "Cape should require level 99")
				assert(upgrade.cost == 99000, "Cape should cost 99000 gold")
				assert(not upgrade.cape_effect_id.is_empty(), "Cape should have an effect ID")
	
	assert(cape_count == 15, "Should have exactly 15 skill capes (one per skill)")
	print("  Total skill capes: %d ✓" % cape_count)
	
	# Test 2: Check cape properties
	print("\nTest 2: Checking cape properties...")
	var fishing_cape: UpgradeData = UpgradeShop.upgrades.get("fishing_cape")
	assert(fishing_cape != null, "Fishing cape should exist")
	assert(fishing_cape.is_skill_cape, "Fishing cape should be marked as skill cape")
	assert(fishing_cape.cape_effect_id == "double_fish", "Fishing cape should have double_fish effect")
	print("  ✓ Fishing cape: %s" % fishing_cape.name)
	print("    Effect: %s" % fishing_cape.cape_effect_id)
	print("    Description: %s" % fishing_cape.description)
	
	# Test 3: Test purchasing skill cape (without enough gold)
	print("\nTest 3: Testing purchase without gold...")
	GameManager.skill_levels["fishing"] = 99  # Set level to 99
	Store.gold = 0
	var purchase_result := UpgradeShop.purchase_upgrade("fishing_cape")
	print("  Purchase result (should fail): %s" % purchase_result)
	assert(not purchase_result, "Purchase should fail without gold")
	assert(not UpgradeShop.is_purchased("fishing_cape"), "Cape should not be purchased")
	
	# Test 4: Test purchasing (without required level)
	print("\nTest 4: Testing purchase without level 99...")
	GameManager.skill_levels["fishing"] = 98
	Store.gold = 100000
	purchase_result = UpgradeShop.purchase_upgrade("fishing_cape")
	print("  Purchase result (should fail): %s" % purchase_result)
	assert(not purchase_result, "Purchase should fail without level 99")
	
	# Test 5: Test purchasing (with level 99 and gold)
	print("\nTest 5: Testing purchase with level 99 and gold...")
	GameManager.skill_levels["fishing"] = 99
	Store.gold = 100000
	purchase_result = UpgradeShop.purchase_upgrade("fishing_cape")
	print("  Purchase result (should succeed): %s" % purchase_result)
	print("  Gold remaining: %d" % Store.gold)
	assert(purchase_result, "Purchase should succeed with level 99 and gold")
	assert(UpgradeShop.is_purchased("fishing_cape"), "Cape should be purchased")
	assert(Store.gold == 1000, "Gold should be deducted (100000 - 99000 = 1000)")
	
	# Test 6: Test cape effect checking
	print("\nTest 6: Testing cape effect checking...")
	assert(UpgradeShop.has_skill_cape("fishing"), "Should have fishing cape")
	assert(not UpgradeShop.has_skill_cape("cooking"), "Should not have cooking cape")
	assert(UpgradeShop.has_cape_effect("double_fish"), "Should have double_fish effect")
	assert(not UpgradeShop.has_cape_effect("perfect_cooking"), "Should not have perfect_cooking effect")
	print("  ✓ Cape effect checking works correctly")
	
	# Test 7: Test cape effect ID getter
	print("\nTest 7: Testing cape effect ID getter...")
	var fishing_effect := UpgradeShop.get_cape_effect("fishing")
	print("  Fishing cape effect: %s" % fishing_effect)
	assert(fishing_effect == "double_fish", "Should return correct effect ID")
	var cooking_effect := UpgradeShop.get_cape_effect("cooking")
	assert(cooking_effect.is_empty(), "Should return empty string for skill without cape")
	print("  ✓ Cape effect ID getter works correctly")
	
	# Test 8: Test multiple cape purchases
	print("\nTest 8: Testing multiple cape purchases...")
	GameManager.skill_levels["cooking"] = 99
	GameManager.skill_levels["woodcutting"] = 99
	Store.gold = 250000
	UpgradeShop.purchase_upgrade("cooking_cape")
	UpgradeShop.purchase_upgrade("woodcutting_cape")
	assert(UpgradeShop.has_skill_cape("fishing"), "Should have fishing cape")
	assert(UpgradeShop.has_skill_cape("cooking"), "Should have cooking cape")
	assert(UpgradeShop.has_skill_cape("woodcutting"), "Should have woodcutting cape")
	assert(UpgradeShop.has_cape_effect("double_fish"), "Should have double_fish effect")
	assert(UpgradeShop.has_cape_effect("perfect_cooking"), "Should have perfect_cooking effect")
	assert(UpgradeShop.has_cape_effect("double_logs"), "Should have double_logs effect")
	print("  ✓ Multiple cape purchases work correctly")
	
	# Test 9: Test saving and loading
	print("\nTest 9: Testing save/load...")
	SaveManager.save_game()
	print("  Game saved")
	
	# Clear purchased upgrades
	var saved_purchases := UpgradeShop.purchased_upgrades.duplicate()
	UpgradeShop.purchased_upgrades.clear()
	print("  Cleared purchased upgrades")
	assert(UpgradeShop.purchased_upgrades.is_empty(), "Purchased upgrades should be empty")
	assert(not UpgradeShop.has_skill_cape("fishing"), "Should not have fishing cape after clearing")
	
	# Reload
	SaveManager.load_game()
	print("  Game loaded")
	print("  Purchased upgrades count: %d" % UpgradeShop.purchased_upgrades.size())
	assert(UpgradeShop.purchased_upgrades.size() == saved_purchases.size(), "Purchased upgrades should be restored")
	assert(UpgradeShop.has_skill_cape("fishing"), "Should have fishing cape after loading")
	assert(UpgradeShop.has_skill_cape("cooking"), "Should have cooking cape after loading")
	assert(UpgradeShop.has_skill_cape("woodcutting"), "Should have woodcutting cape after loading")
	print("  ✓ Save/load preserves cape purchases")
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Clean up
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
