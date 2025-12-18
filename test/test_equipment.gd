## Test Equipment System
## Verifies equipment functionality works correctly
extends Control

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Equipment System Tests ===\n")
	
	# Test 1: Verify equipment autoload exists
	print("Test 1: Equipment autoload exists")
	assert(Equipment != null, "Equipment autoload should exist")
	print("  ✓ Equipment autoload exists\n")
	
	# Test 2: Verify equipment slots are initialized
	print("Test 2: Equipment slots initialized")
	var equipped := Equipment.get_all_equipped()
	assert(equipped.size() > 0, "Equipment slots should be initialized")
	print("  ✓ Equipment has %d slots\n" % equipped.size())
	
	# Test 3: Add test items to inventory and equip
	print("Test 3: Equip bronze sword")
	Inventory.add_item("bronze_sword", 1)
	var sword_equipped := Equipment.equip_item("bronze_sword")
	assert(sword_equipped, "Should be able to equip bronze sword")
	var main_hand := Equipment.get_equipped_item(ItemData.EquipmentSlot.MAIN_HAND)
	assert(main_hand == "bronze_sword", "Bronze sword should be in main hand")
	assert(Inventory.get_item_count("bronze_sword") == 0, "Bronze sword should be removed from inventory")
	print("  ✓ Bronze sword equipped to main hand\n")
	
	# Test 4: Unequip item
	print("Test 4: Unequip bronze sword")
	var unequipped := Equipment.unequip_item(ItemData.EquipmentSlot.MAIN_HAND)
	assert(unequipped, "Should be able to unequip bronze sword")
	assert(Inventory.get_item_count("bronze_sword") == 1, "Bronze sword should be back in inventory")
	var main_hand_after := Equipment.get_equipped_item(ItemData.EquipmentSlot.MAIN_HAND)
	assert(main_hand_after == "", "Main hand should be empty")
	print("  ✓ Bronze sword unequipped\n")
	
	# Test 5: Equip armor pieces
	print("Test 5: Equip armor set")
	Inventory.add_item("bronze_full_helm", 1)
	Inventory.add_item("bronze_platebody", 1)
	Inventory.add_item("bronze_platelegs", 1)
	Inventory.add_item("leather_gloves", 1)
	Inventory.add_item("leather_boots", 1)
	
	assert(Equipment.equip_item("bronze_full_helm"), "Should equip helm")
	assert(Equipment.equip_item("bronze_platebody"), "Should equip chest")
	assert(Equipment.equip_item("bronze_platelegs"), "Should equip legs")
	assert(Equipment.equip_item("leather_gloves"), "Should equip gloves")
	assert(Equipment.equip_item("leather_boots"), "Should equip boots")
	
	assert(Equipment.get_equipped_item(ItemData.EquipmentSlot.HELM) == "bronze_full_helm", "Helm should be equipped")
	assert(Equipment.get_equipped_item(ItemData.EquipmentSlot.CHEST) == "bronze_platebody", "Chest should be equipped")
	assert(Equipment.get_equipped_item(ItemData.EquipmentSlot.LEGS) == "bronze_platelegs", "Legs should be equipped")
	assert(Equipment.get_equipped_item(ItemData.EquipmentSlot.GLOVES) == "leather_gloves", "Gloves should be equipped")
	assert(Equipment.get_equipped_item(ItemData.EquipmentSlot.BOOTS) == "leather_boots", "Boots should be equipped")
	print("  ✓ Full armor set equipped\n")
	
	# Test 6: Equip ring and necklace
	print("Test 6: Equip jewelry")
	Inventory.add_item("sapphire_ring", 1)
	Inventory.add_item("sapphire_necklace", 1)
	
	assert(Equipment.equip_item("sapphire_ring"), "Should equip ring")
	assert(Equipment.equip_item("sapphire_necklace"), "Should equip necklace")
	
	assert(Equipment.get_equipped_item(ItemData.EquipmentSlot.RING) == "sapphire_ring", "Ring should be equipped")
	assert(Equipment.get_equipped_item(ItemData.EquipmentSlot.NECKLACE) == "sapphire_necklace", "Necklace should be equipped")
	print("  ✓ Jewelry equipped\n")
	
	# Test 7: Replace equipped item
	print("Test 7: Replace equipped helm")
	Inventory.add_item("iron_full_helm", 1)
	assert(Equipment.equip_item("iron_full_helm"), "Should replace helm")
	assert(Equipment.get_equipped_item(ItemData.EquipmentSlot.HELM) == "iron_full_helm", "Iron helm should be equipped")
	assert(Inventory.get_item_count("bronze_full_helm") == 1, "Bronze helm should be back in inventory")
	assert(Inventory.get_item_count("iron_full_helm") == 0, "Iron helm should be removed from inventory")
	print("  ✓ Helm replaced successfully\n")
	
	# Test 8: is_item_equipped
	print("Test 8: Check if items are equipped")
	assert(Equipment.is_item_equipped("iron_full_helm"), "Iron helm should be equipped")
	assert(Equipment.is_item_equipped("bronze_platebody"), "Bronze platebody should be equipped")
	assert(not Equipment.is_item_equipped("bronze_full_helm"), "Bronze helm should not be equipped")
	print("  ✓ is_item_equipped works correctly\n")
	
	# Test 9: get_equipped_slot
	print("Test 9: Get equipped slot")
	var helm_slot := Equipment.get_equipped_slot("iron_full_helm")
	assert(helm_slot == ItemData.EquipmentSlot.HELM, "Iron helm should be in HELM slot")
	var not_equipped_slot := Equipment.get_equipped_slot("bronze_full_helm")
	assert(not_equipped_slot == ItemData.EquipmentSlot.NONE, "Bronze helm should return NONE")
	print("  ✓ get_equipped_slot works correctly\n")
	
	# Test 10: unequip_all
	print("Test 10: Unequip all items")
	Equipment.unequip_all()
	for slot in Equipment.get_all_equipped().values():
		assert(slot == "", "All slots should be empty")
	print("  ✓ All items unequipped\n")
	
	print("=== All Equipment Tests Passed! ===\n")
