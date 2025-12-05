## ItemData Resource
## Defines an item that can be collected, stored, and used
class_name ItemData
extends Resource

enum ItemType { RAW_MATERIAL, PROCESSED, TOOL, CONSUMABLE }

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var type: ItemType = ItemType.RAW_MATERIAL
@export var value: int = 1  # Base sell value
@export var stackable: bool = true
@export var max_stack: int = -1  # -1 = unlimited
