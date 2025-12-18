## ItemData Resource
## Defines an item that can be collected, stored, and used
class_name ItemData
extends Resource

enum ItemType { RAW_MATERIAL, PROCESSED, TOOL, CONSUMABLE }
enum EquipmentSlot { 
	NONE,
	HELM, 
	NECKLACE, 
	CHEST, 
	GLOVES, 
	RING_1, 
	RING_2, 
	MAIN_HAND, 
	OFF_HAND, 
	LEGS, 
	ARROWS, 
	BOOTS,
	# Special value for items that can go in either ring slot
	RING = RING_1
}

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var type: ItemType = ItemType.RAW_MATERIAL
@export var value: int = 1  # Base sell value
@export var stackable: bool = true
@export var max_stack: int = -1  # -1 = unlimited
@export var equipment_slot: EquipmentSlot = EquipmentSlot.NONE  # Which slot this item can be equipped in
