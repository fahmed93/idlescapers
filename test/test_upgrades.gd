## Test script to verify upgrades shop functionality
extends Node

func _ready() -> void:
	print("\n=== UPGRADES SHOP TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Check that upgrades are loaded
	print("\nTest 1: Checking upgrades loaded...")
	var fishing_upgrades := UpgradeShop.get_upgrades_for_skill("fishing")
	print("  Fishing upgrades count: %d" % fishing_upgrades.size())
	assert(fishing_upgrades.size() > 0, "Fishing upgrades should be loaded")
	
	var woodcutting_upgrades := UpgradeShop.get_upgrades_for_skill("woodcutting")
	print("  Woodcutting upgrades count: %d" % woodcutting_upgrades.size())
	assert(woodcutting_upgrades.size() > 0, "Woodcutting upgrades should be loaded")
	
	# Test 2: Check upgrade properties
	print("\nTest 2: Checking upgrade properties...")
	var basic_rod: UpgradeData = UpgradeShop.upgrades.get("basic_fishing_rod")
	if basic_rod:
		print("  Basic Fishing Rod:")
		print("    Name: %s" % basic_rod.name)
		print("    Skill: %s" % basic_rod.skill_id)
		print("    Cost: %d gold" % basic_rod.cost)
		print("    Level Required: %d" % basic_rod.level_required)
		print("    Speed Modifier: %.1f%%" % (basic_rod.speed_modifier * 100))
		assert(basic_rod.skill_id == "fishing", "Basic rod should be for fishing")
		assert(basic_rod.speed_modifier == 0.10, "Basic rod should have 10% speed bonus")
	
	# Test 3: Test purchasing (without enough gold)
	print("\nTest 3: Testing purchase without gold...")
	Store.gold = 0
	var purchase_result := UpgradeShop.purchase_upgrade("basic_fishing_rod")
	print("  Purchase result (should fail): %s" % purchase_result)
	assert(not purchase_result, "Purchase should fail without gold")
	assert(not UpgradeShop.is_purchased("basic_fishing_rod"), "Upgrade should not be purchased")
	
	# Test 4: Test purchasing (with enough gold)
	print("\nTest 4: Testing purchase with gold...")
	Store.gold = 1000
	purchase_result = UpgradeShop.purchase_upgrade("basic_fishing_rod")
	print("  Purchase result (should succeed): %s" % purchase_result)
	print("  Gold remaining: %d" % Store.gold)
	assert(purchase_result, "Purchase should succeed with gold")
	assert(UpgradeShop.is_purchased("basic_fishing_rod"), "Upgrade should be purchased")
	assert(Store.gold == 900, "Gold should be deducted")
	
	# Test 5: Test speed modifier calculation
	print("\nTest 5: Testing speed modifier calculation...")
	var fishing_speed := UpgradeShop.get_skill_speed_modifier("fishing")
	print("  Fishing speed modifier: %.1f%%" % (fishing_speed * 100))
	assert(fishing_speed == 0.10, "Fishing should have 10% speed bonus from basic rod")
	
	# Purchase another upgrade
	Store.gold = 5000
	UpgradeShop.purchase_upgrade("steel_fishing_rod")
	fishing_speed = UpgradeShop.get_skill_speed_modifier("fishing")
	print("  Fishing speed modifier after 2nd upgrade: %.1f%%" % (fishing_speed * 100))
	assert(fishing_speed == 0.30, "Fishing should have 30% speed bonus from two upgrades")
	
	# Test 6: Test saving and loading
	print("\nTest 6: Testing save/load...")
	SaveManager.save_game()
	print("  Game saved")
	
	# Clear purchased upgrades
	var saved_purchases := UpgradeShop.purchased_upgrades.duplicate()
	UpgradeShop.purchased_upgrades.clear()
	print("  Cleared purchased upgrades")
	assert(UpgradeShop.purchased_upgrades.is_empty(), "Purchased upgrades should be empty")
	
	# Reload
	SaveManager.load_game()
	print("  Game loaded")
	print("  Purchased upgrades count: %d" % UpgradeShop.purchased_upgrades.size())
	assert(UpgradeShop.purchased_upgrades.size() == saved_purchases.size(), "Purchased upgrades should be restored")
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Clean up save file
	if FileAccess.file_exists("user://skillforge_save.json"):
		DirAccess.remove_absolute("user://skillforge_save.json")
		print("Cleaned up test save file")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
