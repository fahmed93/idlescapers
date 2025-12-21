## Inventory Autoload
## Manages player items and item data
extends Node

signal item_added(item_id: String, amount: int, new_total: int)
signal item_removed(item_id: String, amount: int, new_total: int)
signal inventory_updated()
signal tab_created(tab_id: String, tab_name: String)
signal tab_deleted(tab_id: String)
signal tab_renamed(tab_id: String, new_name: String)
signal item_moved_between_tabs(item_id: String, from_tab: String, to_tab: String)

## Item data registry
var items: Dictionary = {}  # item_id: ItemData

## Player inventory (legacy - main tab)
var inventory: Dictionary = {}  # item_id: quantity

## Tab system
var tabs: Dictionary = {}  # tab_id: { name: String, items: Dictionary }
var tab_order: Array[String] = []  # Ordered list of tab IDs
const MAIN_TAB_ID := "main"
const MAX_TABS := 10

func _ready() -> void:
	_load_items()
	_initialize_tabs()

## Load all item definitions
func _load_items() -> void:
	# Fish (raw)
	_add_item("raw_shrimp", "Raw Shrimp", "A small shrimp.", ItemData.ItemType.RAW_MATERIAL, 5)
	_add_item("raw_sardine", "Raw Sardine", "A small oily fish.", ItemData.ItemType.RAW_MATERIAL, 10)
	_add_item("raw_herring", "Raw Herring", "A silver fish.", ItemData.ItemType.RAW_MATERIAL, 15)
	_add_item("raw_trout", "Raw Trout", "A freshwater fish.", ItemData.ItemType.RAW_MATERIAL, 25)
	_add_item("raw_salmon", "Raw Salmon", "A large pink fish.", ItemData.ItemType.RAW_MATERIAL, 40)
	_add_item("raw_lobster", "Raw Lobster", "A valuable crustacean.", ItemData.ItemType.RAW_MATERIAL, 80)
	_add_item("raw_swordfish", "Raw Swordfish", "A large fish with a bill.", ItemData.ItemType.RAW_MATERIAL, 120)
	_add_item("raw_monkfish", "Raw Monkfish", "A strange looking fish.", ItemData.ItemType.RAW_MATERIAL, 180)
	_add_item("raw_shark", "Raw Shark", "An apex predator.", ItemData.ItemType.RAW_MATERIAL, 300)
	_add_item("raw_anglerfish", "Raw Anglerfish", "A deep sea fish.", ItemData.ItemType.RAW_MATERIAL, 500)
	
	# Additional fish (raw)
	_add_item("raw_anchovy", "Raw Anchovy", "Tiny fish in a school.", ItemData.ItemType.RAW_MATERIAL, 8)
	_add_item("raw_mackerel", "Raw Mackerel", "A striped fast swimmer.", ItemData.ItemType.RAW_MATERIAL, 12)
	_add_item("raw_cod", "Raw Cod", "A popular white fish.", ItemData.ItemType.RAW_MATERIAL, 18)
	_add_item("raw_pike", "Raw Pike", "An aggressive predator.", ItemData.ItemType.RAW_MATERIAL, 30)
	_add_item("raw_bass", "Raw Bass", "A prized sport fish.", ItemData.ItemType.RAW_MATERIAL, 50)
	_add_item("raw_tuna", "Raw Tuna", "A powerful ocean fish.", ItemData.ItemType.RAW_MATERIAL, 100)
	_add_item("raw_manta_ray", "Raw Manta Ray", "A graceful giant.", ItemData.ItemType.RAW_MATERIAL, 220)
	_add_item("raw_sea_turtle", "Raw Sea Turtle", "An ancient marine reptile.", ItemData.ItemType.RAW_MATERIAL, 350)
	_add_item("raw_sailfish", "Raw Sailfish", "The fastest fish.", ItemData.ItemType.RAW_MATERIAL, 550)
	_add_item("kraken_tentacle", "Kraken Tentacle", "A legendary sea creature's limb.", ItemData.ItemType.RAW_MATERIAL, 800)
	
	# Fish (cooked)
	_add_item("cooked_shrimp", "Cooked Shrimp", "A tasty cooked shrimp.", ItemData.ItemType.CONSUMABLE, 10)
	_add_item("cooked_sardine", "Cooked Sardine", "A cooked sardine.", ItemData.ItemType.CONSUMABLE, 20)
	_add_item("cooked_herring", "Cooked Herring", "A cooked herring.", ItemData.ItemType.CONSUMABLE, 30)
	_add_item("cooked_trout", "Cooked Trout", "A cooked trout.", ItemData.ItemType.CONSUMABLE, 50)
	_add_item("cooked_salmon", "Cooked Salmon", "A cooked salmon.", ItemData.ItemType.CONSUMABLE, 80)
	_add_item("cooked_lobster", "Cooked Lobster", "A cooked lobster.", ItemData.ItemType.CONSUMABLE, 150)
	_add_item("cooked_swordfish", "Cooked Swordfish", "A cooked swordfish.", ItemData.ItemType.CONSUMABLE, 250)
	_add_item("cooked_monkfish", "Cooked Monkfish", "A cooked monkfish.", ItemData.ItemType.CONSUMABLE, 350)
	_add_item("cooked_shark", "Cooked Shark", "A cooked shark.", ItemData.ItemType.CONSUMABLE, 600)
	_add_item("cooked_anglerfish", "Cooked Anglerfish", "A cooked anglerfish.", ItemData.ItemType.CONSUMABLE, 1000)
	
	# Additional fish (cooked)
	_add_item("cooked_anchovy", "Cooked Anchovy", "A salty cooked anchovy.", ItemData.ItemType.CONSUMABLE, 15)
	_add_item("cooked_mackerel", "Cooked Mackerel", "A flavorful cooked mackerel.", ItemData.ItemType.CONSUMABLE, 25)
	_add_item("cooked_cod", "Cooked Cod", "A delicious cooked cod.", ItemData.ItemType.CONSUMABLE, 35)
	_add_item("cooked_pike", "Cooked Pike", "A hearty cooked pike.", ItemData.ItemType.CONSUMABLE, 60)
	_add_item("cooked_bass", "Cooked Bass", "A premium cooked bass.", ItemData.ItemType.CONSUMABLE, 100)
	_add_item("cooked_tuna", "Cooked Tuna", "A protein-rich cooked tuna.", ItemData.ItemType.CONSUMABLE, 200)
	_add_item("cooked_manta_ray", "Cooked Manta Ray", "An exotic cooked manta ray.", ItemData.ItemType.CONSUMABLE, 440)
	_add_item("cooked_sea_turtle", "Cooked Sea Turtle", "A rare cooked sea turtle.", ItemData.ItemType.CONSUMABLE, 700)
	_add_item("cooked_sailfish", "Cooked Sailfish", "A premium cooked sailfish.", ItemData.ItemType.CONSUMABLE, 1100)
	_add_item("cooked_kraken_tentacle", "Cooked Kraken Tentacle", "An ultimate cooked kraken feast.", ItemData.ItemType.CONSUMABLE, 1600)
	
	# Logs
	_add_item("logs", "Logs", "Standard wooden logs.", ItemData.ItemType.RAW_MATERIAL, 5, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/logs.png")
	_add_item("oak_logs", "Oak Logs", "Sturdy oak logs.", ItemData.ItemType.RAW_MATERIAL, 20, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/oak_logs.png")
	_add_item("willow_logs", "Willow Logs", "Flexible willow logs.", ItemData.ItemType.RAW_MATERIAL, 40, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/willow_logs.png")
	_add_item("maple_logs", "Maple Logs", "Quality maple logs.", ItemData.ItemType.RAW_MATERIAL, 80, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/maple_logs.png")
	_add_item("yew_logs", "Yew Logs", "Valuable yew logs.", ItemData.ItemType.RAW_MATERIAL, 200, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/yew_logs.png")
	_add_item("magic_logs", "Magic Logs", "Magical logs.", ItemData.ItemType.RAW_MATERIAL, 500, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/magic_logs.png")
	_add_item("redwood_logs", "Redwood Logs", "Massive redwood logs.", ItemData.ItemType.RAW_MATERIAL, 1000, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/redwood_logs.png")
	_add_item("achey_logs", "Achey Logs", "Flexible achey logs.", ItemData.ItemType.RAW_MATERIAL, 15, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/achey_logs.png")
	_add_item("teak_logs", "Teak Logs", "Durable teak logs.", ItemData.ItemType.RAW_MATERIAL, 90, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/teak_logs.png")
	_add_item("mahogany_logs", "Mahogany Logs", "Rich mahogany logs.", ItemData.ItemType.RAW_MATERIAL, 150, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/mahogany_logs.png")
	_add_item("arctic_pine_logs", "Arctic Pine Logs", "Hardy arctic pine logs.", ItemData.ItemType.RAW_MATERIAL, 170, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/arctic_pine_logs.png")
	_add_item("eucalyptus_logs", "Eucalyptus Logs", "Fragrant eucalyptus logs.", ItemData.ItemType.RAW_MATERIAL, 220, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/eucalyptus_logs.png")
	_add_item("elder_logs", "Elder Logs", "Mystical elder logs.", ItemData.ItemType.RAW_MATERIAL, 280, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/elder_logs.png")
	_add_item("blisterwood_logs", "Blisterwood Logs", "Cursed blisterwood logs.", ItemData.ItemType.RAW_MATERIAL, 350, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/blisterwood_logs.png")
	_add_item("bloodwood_logs", "Bloodwood Logs", "Crimson bloodwood logs.", ItemData.ItemType.RAW_MATERIAL, 450, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/bloodwood_logs.png")
	_add_item("crystal_logs", "Crystal Logs", "Shimmering crystal logs.", ItemData.ItemType.RAW_MATERIAL, 600, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/crystal_logs.png")
	_add_item("spirit_logs", "Spirit Logs", "Ancient spirit tree logs.", ItemData.ItemType.RAW_MATERIAL, 750, ItemData.EquipmentSlot.NONE, "res://assets/icons/items/spirit_logs.png")
  
	# Fletching materials
	_add_item("arrow_shafts", "Arrow Shafts", "Wooden shafts for arrows.", ItemData.ItemType.PROCESSED, 1)
	_add_item("feather", "Feather", "A feather for fletching arrows.", ItemData.ItemType.RAW_MATERIAL, 2)
	_add_item("bowstring", "Bowstring", "String for stringing bows.", ItemData.ItemType.PROCESSED, 10)
	_add_item("bronze_arrowhead", "Bronze Arrowhead", "A bronze arrowhead.", ItemData.ItemType.PROCESSED, 3)
	
	# Bows
	_add_item("shortbow", "Shortbow", "A basic shortbow.", ItemData.ItemType.TOOL, 50, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("longbow", "Longbow", "A basic longbow.", ItemData.ItemType.TOOL, 100, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("oak_shortbow", "Oak Shortbow", "A shortbow made of oak.", ItemData.ItemType.TOOL, 150, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("oak_longbow", "Oak Longbow", "A longbow made of oak.", ItemData.ItemType.TOOL, 200, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("willow_shortbow", "Willow Shortbow", "A shortbow made of willow.", ItemData.ItemType.TOOL, 300, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("willow_longbow", "Willow Longbow", "A longbow made of willow.", ItemData.ItemType.TOOL, 400, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("maple_shortbow", "Maple Shortbow", "A shortbow made of maple.", ItemData.ItemType.TOOL, 600, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("maple_longbow", "Maple Longbow", "A longbow made of maple.", ItemData.ItemType.TOOL, 800, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("yew_shortbow", "Yew Shortbow", "A shortbow made of yew.", ItemData.ItemType.TOOL, 1200, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("yew_longbow", "Yew Longbow", "A longbow made of yew.", ItemData.ItemType.TOOL, 1600, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("magic_shortbow", "Magic Shortbow", "A magical shortbow.", ItemData.ItemType.TOOL, 2500, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("magic_longbow", "Magic Longbow", "A magical longbow.", ItemData.ItemType.TOOL, 3500, ItemData.EquipmentSlot.MAIN_HAND)
	
	# Arrows
	_add_item("headless_arrow", "Headless Arrow", "An arrow without an arrowhead.", ItemData.ItemType.PROCESSED, 2, ItemData.EquipmentSlot.ARROWS)
	_add_item("bronze_arrow", "Bronze Arrow", "An arrow with a bronze tip.", ItemData.ItemType.PROCESSED, 5, ItemData.EquipmentSlot.ARROWS)
  
	# Ores
	_add_item("copper_ore", "Copper Ore", "A soft reddish ore.", ItemData.ItemType.RAW_MATERIAL, 5)
	_add_item("tin_ore", "Tin Ore", "A silvery ore.", ItemData.ItemType.RAW_MATERIAL, 5)
	_add_item("iron_ore", "Iron Ore", "A common metallic ore.", ItemData.ItemType.RAW_MATERIAL, 15)
	_add_item("silver_ore", "Silver Ore", "A shiny precious ore.", ItemData.ItemType.RAW_MATERIAL, 25)
	_add_item("coal", "Coal", "Fuel for smelting.", ItemData.ItemType.RAW_MATERIAL, 30)
	_add_item("gold_ore", "Gold Ore", "A valuable golden ore.", ItemData.ItemType.RAW_MATERIAL, 50)
	_add_item("mithril_ore", "Mithril Ore", "A light blue ore.", ItemData.ItemType.RAW_MATERIAL, 100)
	_add_item("adamantite_ore", "Adamantite Ore", "A greenish ore.", ItemData.ItemType.RAW_MATERIAL, 200)
	_add_item("runite_ore", "Runite Ore", "A rare cyan ore.", ItemData.ItemType.RAW_MATERIAL, 500)
	
	# Gems
	_add_item("sapphire", "Sapphire", "A brilliant blue gem.", ItemData.ItemType.RAW_MATERIAL, 100)
	_add_item("emerald", "Emerald", "A lustrous green gem.", ItemData.ItemType.RAW_MATERIAL, 200)
	_add_item("ruby", "Ruby", "A precious red gem.", ItemData.ItemType.RAW_MATERIAL, 400)
	_add_item("diamond", "Diamond", "A rare and valuable gem.", ItemData.ItemType.RAW_MATERIAL, 800)
	
	# Bars (smelted from ores)
	_add_item("bronze_bar", "Bronze Bar", "A bar of bronze metal.", ItemData.ItemType.PROCESSED, 15)
	_add_item("iron_bar", "Iron Bar", "A bar of iron metal.", ItemData.ItemType.PROCESSED, 30)
	_add_item("silver_bar", "Silver Bar", "A bar of silver metal.", ItemData.ItemType.PROCESSED, 50)
	_add_item("steel_bar", "Steel Bar", "A bar of refined steel.", ItemData.ItemType.PROCESSED, 100)
	_add_item("gold_bar", "Gold Bar", "A bar of gold metal.", ItemData.ItemType.PROCESSED, 150)
	_add_item("mithril_bar", "Mithril Bar", "A bar of mithril metal.", ItemData.ItemType.PROCESSED, 300)
	_add_item("adamantite_bar", "Adamantite Bar", "A bar of adamantite metal.", ItemData.ItemType.PROCESSED, 600)
	_add_item("runite_bar", "Runite Bar", "A bar of runite metal.", ItemData.ItemType.PROCESSED, 1500)
	
	# Smithed items - Arrowheads
	_add_item("iron_arrowhead", "Iron Arrowhead", "An iron arrowhead.", ItemData.ItemType.PROCESSED, 5)
	_add_item("steel_arrowhead", "Steel Arrowhead", "A steel arrowhead.", ItemData.ItemType.PROCESSED, 10)
	_add_item("mithril_arrowhead", "Mithril Arrowhead", "A mithril arrowhead.", ItemData.ItemType.PROCESSED, 20)
	_add_item("adamantite_arrowhead", "Adamantite Arrowhead", "An adamantite arrowhead.", ItemData.ItemType.PROCESSED, 40)
	_add_item("runite_arrowhead", "Runite Arrowhead", "A runite arrowhead.", ItemData.ItemType.PROCESSED, 100)
	
	# Smithed items - Daggers
	_add_item("bronze_dagger", "Bronze Dagger", "A bronze dagger.", ItemData.ItemType.TOOL, 20, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("iron_dagger", "Iron Dagger", "An iron dagger.", ItemData.ItemType.TOOL, 40, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("steel_dagger", "Steel Dagger", "A steel dagger.", ItemData.ItemType.TOOL, 100, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("mithril_dagger", "Mithril Dagger", "A mithril dagger.", ItemData.ItemType.TOOL, 200, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("adamantite_dagger", "Adamantite Dagger", "An adamantite dagger.", ItemData.ItemType.TOOL, 400, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("runite_dagger", "Runite Dagger", "A runite dagger.", ItemData.ItemType.TOOL, 1000, ItemData.EquipmentSlot.MAIN_HAND)
	
	# Smithed items - Swords
	_add_item("bronze_sword", "Bronze Sword", "A bronze sword.", ItemData.ItemType.TOOL, 40, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("iron_sword", "Iron Sword", "An iron sword.", ItemData.ItemType.TOOL, 80, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("steel_sword", "Steel Sword", "A steel sword.", ItemData.ItemType.TOOL, 200, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("mithril_sword", "Mithril Sword", "A mithril sword.", ItemData.ItemType.TOOL, 400, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("adamantite_sword", "Adamantite Sword", "An adamantite sword.", ItemData.ItemType.TOOL, 800, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("runite_sword", "Runite Sword", "A runite sword.", ItemData.ItemType.TOOL, 2000, ItemData.EquipmentSlot.MAIN_HAND)
	
	# Smithed items - Scimitars
	_add_item("bronze_scimitar", "Bronze Scimitar", "A bronze scimitar.", ItemData.ItemType.TOOL, 50, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("iron_scimitar", "Iron Scimitar", "An iron scimitar.", ItemData.ItemType.TOOL, 100, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("steel_scimitar", "Steel Scimitar", "A steel scimitar.", ItemData.ItemType.TOOL, 250, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("mithril_scimitar", "Mithril Scimitar", "A mithril scimitar.", ItemData.ItemType.TOOL, 500, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("adamantite_scimitar", "Adamantite Scimitar", "An adamantite scimitar.", ItemData.ItemType.TOOL, 1000, ItemData.EquipmentSlot.MAIN_HAND)
	_add_item("runite_scimitar", "Runite Scimitar", "A runite scimitar.", ItemData.ItemType.TOOL, 2500, ItemData.EquipmentSlot.MAIN_HAND)
	
	# Smithed items - Armor (Helmets)
	_add_item("bronze_full_helm", "Bronze Full Helm", "A bronze full helmet.", ItemData.ItemType.TOOL, 60, ItemData.EquipmentSlot.HELM)
	_add_item("iron_full_helm", "Iron Full Helm", "An iron full helmet.", ItemData.ItemType.TOOL, 120, ItemData.EquipmentSlot.HELM)
	_add_item("steel_full_helm", "Steel Full Helm", "A steel full helmet.", ItemData.ItemType.TOOL, 300, ItemData.EquipmentSlot.HELM)
	_add_item("mithril_full_helm", "Mithril Full Helm", "A mithril full helmet.", ItemData.ItemType.TOOL, 600, ItemData.EquipmentSlot.HELM)
	_add_item("adamantite_full_helm", "Adamantite Full Helm", "An adamantite full helmet.", ItemData.ItemType.TOOL, 1200, ItemData.EquipmentSlot.HELM)
	_add_item("runite_full_helm", "Runite Full Helm", "A runite full helmet.", ItemData.ItemType.TOOL, 3000, ItemData.EquipmentSlot.HELM)
	
	# Smithed items - Armor (Platebodies)
	_add_item("bronze_platebody", "Bronze Platebody", "A bronze platebody.", ItemData.ItemType.TOOL, 150, ItemData.EquipmentSlot.CHEST)
	_add_item("iron_platebody", "Iron Platebody", "An iron platebody.", ItemData.ItemType.TOOL, 300, ItemData.EquipmentSlot.CHEST)
	_add_item("steel_platebody", "Steel Platebody", "A steel platebody.", ItemData.ItemType.TOOL, 750, ItemData.EquipmentSlot.CHEST)
	_add_item("mithril_platebody", "Mithril Platebody", "A mithril platebody.", ItemData.ItemType.TOOL, 1500, ItemData.EquipmentSlot.CHEST)
	_add_item("adamantite_platebody", "Adamantite Platebody", "An adamantite platebody.", ItemData.ItemType.TOOL, 3000, ItemData.EquipmentSlot.CHEST)
	_add_item("runite_platebody", "Runite Platebody", "A runite platebody.", ItemData.ItemType.TOOL, 7500, ItemData.EquipmentSlot.CHEST)
	
	# Smithed items - Armor (Platelegs)
	_add_item("bronze_platelegs", "Bronze Platelegs", "Bronze platelegs.", ItemData.ItemType.TOOL, 120, ItemData.EquipmentSlot.LEGS)
	_add_item("iron_platelegs", "Iron Platelegs", "Iron platelegs.", ItemData.ItemType.TOOL, 240, ItemData.EquipmentSlot.LEGS)
	_add_item("steel_platelegs", "Steel Platelegs", "Steel platelegs.", ItemData.ItemType.TOOL, 600, ItemData.EquipmentSlot.LEGS)
	_add_item("mithril_platelegs", "Mithril Platelegs", "Mithril platelegs.", ItemData.ItemType.TOOL, 1200, ItemData.EquipmentSlot.LEGS)
	_add_item("adamantite_platelegs", "Adamantite Platelegs", "Adamantite platelegs.", ItemData.ItemType.TOOL, 2400, ItemData.EquipmentSlot.LEGS)
	_add_item("runite_platelegs", "Runite Platelegs", "Runite platelegs.", ItemData.ItemType.TOOL, 6000, ItemData.EquipmentSlot.LEGS)
  
	# Firemaking products
	_add_item("ashes", "Ashes", "Remains of burnt logs.", ItemData.ItemType.PROCESSED, 1)
	
	# Dirty herbs (from Foraging)
	_add_item("dirty_guam_leaf", "Dirty Guam Leaf", "An unclean guam leaf that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 5)
	_add_item("dirty_marrentill", "Dirty Marrentill", "An unclean marrentill that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 7)
	_add_item("dirty_tarromin", "Dirty Tarromin", "An unclean tarromin that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 9)
	_add_item("dirty_harralander", "Dirty Harralander", "An unclean harralander that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 11)
	_add_item("dirty_ranarr_weed", "Dirty Ranarr Weed", "An unclean ranarr weed that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 18)
	_add_item("dirty_toadflax", "Dirty Toadflax", "An unclean toadflax that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 22)
	_add_item("dirty_irit_leaf", "Dirty Irit Leaf", "An unclean irit leaf that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 30)
	_add_item("dirty_avantoe", "Dirty Avantoe", "An unclean avantoe that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 38)
	_add_item("dirty_kwuarm", "Dirty Kwuarm", "An unclean kwuarm that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 50)
	_add_item("dirty_snapdragon", "Dirty Snapdragon", "An unclean snapdragon that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 65)
	_add_item("dirty_cadantine", "Dirty Cadantine", "An unclean cadantine that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 75)
	_add_item("dirty_lantadyme", "Dirty Lantadyme", "An unclean lantadyme that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 90)
	_add_item("dirty_dwarf_weed", "Dirty Dwarf Weed", "An unclean dwarf weed that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 105)
	_add_item("dirty_torstol", "Dirty Torstol", "An unclean torstol that needs cleaning.", ItemData.ItemType.RAW_MATERIAL, 150)
	
	# Herbs (grimy/clean)
	_add_item("guam_leaf", "Guam Leaf", "A basic herb used in Attack potions.", ItemData.ItemType.RAW_MATERIAL, 8)
	_add_item("marrentill", "Marrentill", "A herb used in Antipoison.", ItemData.ItemType.RAW_MATERIAL, 10)
	_add_item("tarromin", "Tarromin", "A herb used in Strength potions.", ItemData.ItemType.RAW_MATERIAL, 12)
	_add_item("harralander", "Harralander", "A herb used in various potions.", ItemData.ItemType.RAW_MATERIAL, 15)
	_add_item("ranarr_weed", "Ranarr Weed", "A valuable herb used in Prayer potions.", ItemData.ItemType.RAW_MATERIAL, 25)
	_add_item("toadflax", "Toadflax", "A herb used in Saradomin brews.", ItemData.ItemType.RAW_MATERIAL, 30)
	_add_item("irit_leaf", "Irit Leaf", "A herb used in Super Attack potions.", ItemData.ItemType.RAW_MATERIAL, 40)
	_add_item("avantoe", "Avantoe", "A herb used in fishing potions.", ItemData.ItemType.RAW_MATERIAL, 50)
	_add_item("kwuarm", "Kwuarm", "A herb used in Super Strength potions.", ItemData.ItemType.RAW_MATERIAL, 65)
	_add_item("snapdragon", "Snapdragon", "A valuable herb used in Super Restore.", ItemData.ItemType.RAW_MATERIAL, 85)
	_add_item("cadantine", "Cadantine", "A herb used in Super Defence potions.", ItemData.ItemType.RAW_MATERIAL, 100)
	_add_item("lantadyme", "Lantadyme", "A herb used in Antifire potions.", ItemData.ItemType.RAW_MATERIAL, 120)
	_add_item("dwarf_weed", "Dwarf Weed", "A herb used in Ranging potions.", ItemData.ItemType.RAW_MATERIAL, 140)
	_add_item("torstol", "Torstol", "The most powerful herb for extreme potions.", ItemData.ItemType.RAW_MATERIAL, 200)
	
	# Secondary ingredients
	_add_item("eye_of_newt", "Eye of Newt", "A common potion ingredient.", ItemData.ItemType.RAW_MATERIAL, 3)
	_add_item("unicorn_horn_dust", "Unicorn Horn Dust", "Powdered unicorn horn.", ItemData.ItemType.PROCESSED, 15)
	_add_item("limpwurt_root", "Limpwurt Root", "A root from the limpwurt plant.", ItemData.ItemType.RAW_MATERIAL, 20)
	_add_item("red_spiders_eggs", "Red Spiders' Eggs", "Eggs from red spiders.", ItemData.ItemType.RAW_MATERIAL, 18)
	_add_item("chocolate_dust", "Chocolate Dust", "Ground chocolate.", ItemData.ItemType.PROCESSED, 10)
	_add_item("white_berries", "White Berries", "Rare white berries.", ItemData.ItemType.RAW_MATERIAL, 12)
	_add_item("snape_grass", "Snape Grass", "A plant used in Prayer potions.", ItemData.ItemType.RAW_MATERIAL, 25)
	_add_item("crushed_nest", "Crushed Nest", "A ground bird's nest.", ItemData.ItemType.PROCESSED, 40)
	_add_item("wine_of_zamorak", "Wine of Zamorak", "A dark wine blessed by Zamorak.", ItemData.ItemType.RAW_MATERIAL, 50)
	_add_item("dragon_scale_dust", "Dragon Scale Dust", "Powdered dragon scales.", ItemData.ItemType.PROCESSED, 80)
	_add_item("potato_cactus", "Potato Cactus", "A prickly desert plant.", ItemData.ItemType.RAW_MATERIAL, 30)
	_add_item("jangerberries", "Jangerberries", "Dark berries used in Zamorak brew.", ItemData.ItemType.RAW_MATERIAL, 35)
	
	# Potions
	_add_item("attack_potion", "Attack Potion", "Temporarily boosts Attack.", ItemData.ItemType.CONSUMABLE, 50)
	_add_item("antipoison", "Antipoison", "Cures and prevents poison.", ItemData.ItemType.CONSUMABLE, 75)
	_add_item("strength_potion", "Strength Potion", "Temporarily boosts Strength.", ItemData.ItemType.CONSUMABLE, 100)
	_add_item("restore_potion", "Restore Potion", "Restores lowered stats.", ItemData.ItemType.CONSUMABLE, 125)
	_add_item("energy_potion", "Energy Potion", "Restores run energy.", ItemData.ItemType.CONSUMABLE, 135)
	_add_item("defence_potion", "Defence Potion", "Temporarily boosts Defence.", ItemData.ItemType.CONSUMABLE, 150)
	_add_item("prayer_potion", "Prayer Potion", "Restores Prayer points.", ItemData.ItemType.CONSUMABLE, 175)
	_add_item("super_attack", "Super Attack", "Greatly boosts Attack.", ItemData.ItemType.CONSUMABLE, 200)
	_add_item("super_strength", "Super Strength", "Greatly boosts Strength.", ItemData.ItemType.CONSUMABLE, 250)
	_add_item("super_restore", "Super Restore", "Fully restores lowered stats.", ItemData.ItemType.CONSUMABLE, 285)
	_add_item("super_defence", "Super Defence", "Greatly boosts Defence.", ItemData.ItemType.CONSUMABLE, 300)
	_add_item("saradomin_brew", "Saradomin Brew", "A holy brew that heals and boosts Defence.", ItemData.ItemType.CONSUMABLE, 360)
	_add_item("ranging_potion", "Ranging Potion", "Boosts Ranged level.", ItemData.ItemType.CONSUMABLE, 325)
	_add_item("antifire", "Antifire Potion", "Protects against dragonfire.", ItemData.ItemType.CONSUMABLE, 315)
	_add_item("magic_potion", "Magic Potion", "Boosts Magic level.", ItemData.ItemType.CONSUMABLE, 345)
	_add_item("zamorak_brew", "Zamorak Brew", "A dark brew that boosts Attack and Strength.", ItemData.ItemType.CONSUMABLE, 350)
	_add_item("overload", "Overload", "The ultimate combat potion.", ItemData.ItemType.CONSUMABLE, 2000)
	# Thieving rewards
	_add_item("coins", "Coins", "Currency obtained from pickpocketing.", ItemData.ItemType.PROCESSED, 1)
	
	# Agility rewards
	_add_item("marks_of_grace", "Marks of Grace", "Graceful tokens earned from agility courses.", ItemData.ItemType.PROCESSED, 10)
	
	# Astrology materials
	_add_item("stardust", "Stardust", "Shimmering dust from the cosmos.", ItemData.ItemType.RAW_MATERIAL, 10)
	_add_item("celestial_essence", "Celestial Essence", "Pure essence of celestial bodies.", ItemData.ItemType.PROCESSED, 50)
	_add_item("astral_shard", "Astral Shard", "A fragment of astral energy.", ItemData.ItemType.PROCESSED, 150)
	_add_item("void_crystal", "Void Crystal", "A mysterious crystal from the void.", ItemData.ItemType.PROCESSED, 1000)
	
	# Gems (uncut)
	_add_item("sapphire", "Sapphire", "A beautiful blue gem.", ItemData.ItemType.RAW_MATERIAL, 50)
	_add_item("emerald", "Emerald", "A vibrant green gem.", ItemData.ItemType.RAW_MATERIAL, 100)
	_add_item("ruby", "Ruby", "A precious red gem.", ItemData.ItemType.RAW_MATERIAL, 200)
	_add_item("diamond", "Diamond", "A brilliant clear gem.", ItemData.ItemType.RAW_MATERIAL, 400)
	_add_item("dragonstone", "Dragonstone", "A rare mystical gem.", ItemData.ItemType.RAW_MATERIAL, 800)
	_add_item("onyx", "Onyx", "An extremely valuable black gem.", ItemData.ItemType.RAW_MATERIAL, 2000)
	
	# Jewelry - Rings
	_add_item("sapphire_ring", "Sapphire Ring", "A gold ring with a sapphire.", ItemData.ItemType.PROCESSED, 250, ItemData.EquipmentSlot.RING)
	_add_item("emerald_ring", "Emerald Ring", "A gold ring with an emerald.", ItemData.ItemType.PROCESSED, 450, ItemData.EquipmentSlot.RING)
	_add_item("ruby_ring", "Ruby Ring", "A gold ring with a ruby.", ItemData.ItemType.PROCESSED, 800, ItemData.EquipmentSlot.RING)
	_add_item("diamond_ring", "Diamond Ring", "A gold ring with a diamond.", ItemData.ItemType.PROCESSED, 1400, ItemData.EquipmentSlot.RING)
	_add_item("dragonstone_ring", "Dragonstone Ring", "A gold ring with a dragonstone.", ItemData.ItemType.PROCESSED, 2500, ItemData.EquipmentSlot.RING)
	_add_item("onyx_ring", "Onyx Ring", "A gold ring with an onyx.", ItemData.ItemType.PROCESSED, 5000, ItemData.EquipmentSlot.RING)
	
	# Jewelry - Necklaces
	_add_item("sapphire_necklace", "Sapphire Necklace", "A gold necklace with a sapphire.", ItemData.ItemType.PROCESSED, 300, ItemData.EquipmentSlot.NECKLACE)
	_add_item("emerald_necklace", "Emerald Necklace", "A gold necklace with an emerald.", ItemData.ItemType.PROCESSED, 550, ItemData.EquipmentSlot.NECKLACE)
	_add_item("ruby_necklace", "Ruby Necklace", "A gold necklace with a ruby.", ItemData.ItemType.PROCESSED, 950, ItemData.EquipmentSlot.NECKLACE)
	_add_item("diamond_necklace", "Diamond Necklace", "A gold necklace with a diamond.", ItemData.ItemType.PROCESSED, 1600, ItemData.EquipmentSlot.NECKLACE)
	_add_item("dragonstone_necklace", "Dragonstone Necklace", "A gold necklace with a dragonstone.", ItemData.ItemType.PROCESSED, 2800, ItemData.EquipmentSlot.NECKLACE)
	_add_item("onyx_necklace", "Onyx Necklace", "A gold necklace with an onyx.", ItemData.ItemType.PROCESSED, 5500, ItemData.EquipmentSlot.NECKLACE)
  
	# Animal hides and skins (for Skinning skill)
	_add_item("rabbit_hide", "Rabbit Hide", "Soft hide from a rabbit.", ItemData.ItemType.RAW_MATERIAL, 5)
	_add_item("chicken_hide", "Chicken Hide", "Hide from a chicken.", ItemData.ItemType.RAW_MATERIAL, 8)
	_add_item("cowhide", "Cowhide", "Tough hide from a cow.", ItemData.ItemType.RAW_MATERIAL, 10)
	_add_item("bear_hide", "Bear Hide", "Thick fur from a bear.", ItemData.ItemType.RAW_MATERIAL, 15)
	_add_item("wolf_hide", "Wolf Hide", "Durable pelt from a wolf.", ItemData.ItemType.RAW_MATERIAL, 20)
	_add_item("snake_skin", "Snake Skin", "Scaled skin from a snake.", ItemData.ItemType.RAW_MATERIAL, 25)
	_add_item("crocodile_hide", "Crocodile Hide", "Tough scaled hide from a crocodile.", ItemData.ItemType.RAW_MATERIAL, 30)
	_add_item("yak_hide", "Yak Hide", "Wooly hide from a yak.", ItemData.ItemType.RAW_MATERIAL, 35)
	_add_item("polar_bear_hide", "Polar Bear Hide", "Pristine white fur from a polar bear.", ItemData.ItemType.RAW_MATERIAL, 40)
	_add_item("lion_hide", "Lion Hide", "Golden pelt from a lion.", ItemData.ItemType.RAW_MATERIAL, 45)
	_add_item("tiger_hide", "Tiger Hide", "Striped fur from a tiger.", ItemData.ItemType.RAW_MATERIAL, 50)
	_add_item("black_bear_hide", "Black Bear Hide", "Sleek dark fur from a black bear.", ItemData.ItemType.RAW_MATERIAL, 55)
	_add_item("blue_dragonhide", "Blue Dragonhide", "Azure scales from a blue dragon.", ItemData.ItemType.RAW_MATERIAL, 100)
	_add_item("red_dragonhide", "Red Dragonhide", "Crimson scales from a red dragon.", ItemData.ItemType.RAW_MATERIAL, 150)
	_add_item("black_dragonhide", "Black Dragonhide", "Obsidian scales from a black dragon.", ItemData.ItemType.RAW_MATERIAL, 200)
	_add_item("green_dragonhide", "Green Dragonhide", "Emerald scales from a green dragon.", ItemData.ItemType.RAW_MATERIAL, 250)
	_add_item("frost_dragonhide", "Frost Dragonhide", "Crystalline scales from a frost dragon.", ItemData.ItemType.RAW_MATERIAL, 350)
	_add_item("royal_dragonhide", "Royal Dragonhide", "Platinum scales from a royal dragon.", ItemData.ItemType.RAW_MATERIAL, 500)
	_add_item("chimera_hide", "Chimera Hide", "Multi-textured hide from a chimera.", ItemData.ItemType.RAW_MATERIAL, 750)
	_add_item("phoenix_feather", "Phoenix Feather", "Radiant feather from a phoenix.", ItemData.ItemType.RAW_MATERIAL, 1000)
	
	# Crafted leather armor (from Crafting skill)
	_add_item("leather_gloves", "Leather Gloves", "Gloves made from soft rabbit hide.", ItemData.ItemType.TOOL, 15, ItemData.EquipmentSlot.GLOVES)
	_add_item("leather_boots", "Leather Boots", "Boots made from soft rabbit hide.", ItemData.ItemType.TOOL, 20, ItemData.EquipmentSlot.BOOTS)
	_add_item("leather_cowl", "Leather Cowl", "A leather hood for head protection.", ItemData.ItemType.TOOL, 30, ItemData.EquipmentSlot.HELM)
	_add_item("leather_vambraces", "Leather Vambraces", "Leather arm guards.", ItemData.ItemType.TOOL, 40, ItemData.EquipmentSlot.GLOVES)
	_add_item("leather_body", "Leather Body", "A leather chest piece.", ItemData.ItemType.TOOL, 80, ItemData.EquipmentSlot.CHEST)
	_add_item("leather_chaps", "Leather Chaps", "Leather leg armor.", ItemData.ItemType.TOOL, 70, ItemData.EquipmentSlot.LEGS)
	_add_item("hard_leather_body", "Hard Leather Body", "A reinforced leather body.", ItemData.ItemType.TOOL, 120, ItemData.EquipmentSlot.CHEST)
	_add_item("studded_body", "Studded Body", "A studded leather body.", ItemData.ItemType.TOOL, 160, ItemData.EquipmentSlot.CHEST)
	_add_item("studded_chaps", "Studded Chaps", "Studded leather leg armor.", ItemData.ItemType.TOOL, 140, ItemData.EquipmentSlot.LEGS)
	_add_item("snake_skin_body", "Snake Skin Body", "Body armor made from snake skin.", ItemData.ItemType.TOOL, 200, ItemData.EquipmentSlot.CHEST)
	_add_item("snake_skin_chaps", "Snake Skin Chaps", "Leg armor made from snake skin.", ItemData.ItemType.TOOL, 180, ItemData.EquipmentSlot.LEGS)
	
	# Green dragonhide armor
	_add_item("green_dhide_vambraces", "Green D'hide Vambraces", "Green dragonhide vambraces.", ItemData.ItemType.TOOL, 400, ItemData.EquipmentSlot.GLOVES)
	_add_item("green_dhide_chaps", "Green D'hide Chaps", "Green dragonhide chaps.", ItemData.ItemType.TOOL, 800, ItemData.EquipmentSlot.LEGS)
	_add_item("green_dhide_body", "Green D'hide Body", "Green dragonhide body armor.", ItemData.ItemType.TOOL, 1200, ItemData.EquipmentSlot.CHEST)
	
	# Blue dragonhide armor
	_add_item("blue_dhide_vambraces", "Blue D'hide Vambraces", "Blue dragonhide vambraces.", ItemData.ItemType.TOOL, 500, ItemData.EquipmentSlot.GLOVES)
	_add_item("blue_dhide_chaps", "Blue D'hide Chaps", "Blue dragonhide chaps.", ItemData.ItemType.TOOL, 1000, ItemData.EquipmentSlot.LEGS)
	_add_item("blue_dhide_body", "Blue D'hide Body", "Blue dragonhide body armor.", ItemData.ItemType.TOOL, 1500, ItemData.EquipmentSlot.CHEST)
	
	# Red dragonhide armor
	_add_item("red_dhide_vambraces", "Red D'hide Vambraces", "Red dragonhide vambraces.", ItemData.ItemType.TOOL, 600, ItemData.EquipmentSlot.GLOVES)
	_add_item("red_dhide_chaps", "Red D'hide Chaps", "Red dragonhide chaps.", ItemData.ItemType.TOOL, 1200, ItemData.EquipmentSlot.LEGS)
	_add_item("red_dhide_body", "Red D'hide Body", "Red dragonhide body armor.", ItemData.ItemType.TOOL, 1800, ItemData.EquipmentSlot.CHEST)
	
	# Black dragonhide armor
	_add_item("black_dhide_vambraces", "Black D'hide Vambraces", "Black dragonhide vambraces.", ItemData.ItemType.TOOL, 800, ItemData.EquipmentSlot.GLOVES)
	_add_item("black_dhide_chaps", "Black D'hide Chaps", "Black dragonhide chaps.", ItemData.ItemType.TOOL, 1600, ItemData.EquipmentSlot.LEGS)
	_add_item("black_dhide_body", "Black D'hide Body", "Black dragonhide body armor.", ItemData.ItemType.TOOL, 2400, ItemData.EquipmentSlot.CHEST)
	
	# Frost dragonhide armor
	_add_item("frost_dhide_vambraces", "Frost D'hide Vambraces", "Frost dragonhide vambraces.", ItemData.ItemType.TOOL, 1000, ItemData.EquipmentSlot.GLOVES)
	_add_item("frost_dhide_chaps", "Frost D'hide Chaps", "Frost dragonhide chaps.", ItemData.ItemType.TOOL, 2000, ItemData.EquipmentSlot.LEGS)
	_add_item("frost_dhide_body", "Frost D'hide Body", "Frost dragonhide body armor.", ItemData.ItemType.TOOL, 3000, ItemData.EquipmentSlot.CHEST)
	
	# Royal dragonhide armor
	_add_item("royal_dhide_vambraces", "Royal D'hide Vambraces", "Royal dragonhide vambraces.", ItemData.ItemType.TOOL, 1200, ItemData.EquipmentSlot.GLOVES)
	_add_item("royal_dhide_chaps", "Royal D'hide Chaps", "Royal dragonhide chaps.", ItemData.ItemType.TOOL, 2400, ItemData.EquipmentSlot.LEGS)
	_add_item("royal_dhide_body", "Royal D'hide Body", "Royal dragonhide body armor.", ItemData.ItemType.TOOL, 3600, ItemData.EquipmentSlot.CHEST)


## Helper to add item definition
func _add_item(id: String, display_name: String, desc: String, type: ItemData.ItemType, value: int, equipment_slot: ItemData.EquipmentSlot = ItemData.EquipmentSlot.NONE, icon_path: String = "") -> void:
	var item := ItemData.new()
	item.id = id
	item.name = display_name
	item.description = desc
	item.type = type
	item.value = value
	item.equipment_slot = equipment_slot
	if icon_path != "":
		item.icon = load(icon_path)
	items[id] = item

## Get item data by ID
func get_item_data(item_id: String) -> ItemData:
	return items.get(item_id)

## Get current item count
func get_item_count(item_id: String) -> int:
	return inventory.get(item_id, 0)

## Add items to inventory
func add_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	
	var current: int = inventory.get(item_id, 0)
	inventory[item_id] = current + amount
	
	item_added.emit(item_id, amount, inventory[item_id])
	inventory_updated.emit()
	return true

## Remove items from inventory
func remove_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	
	var current: int = inventory.get(item_id, 0)
	if current < amount:
		return false
	
	inventory[item_id] = current - amount
	if inventory[item_id] <= 0:
		inventory.erase(item_id)
	
	item_removed.emit(item_id, amount, inventory.get(item_id, 0))
	inventory_updated.emit()
	return true

## Check if player has enough of an item
func has_item(item_id: String, amount: int = 1) -> bool:
	return get_item_count(item_id) >= amount

## Get all inventory items
func get_all_items() -> Dictionary:
	return inventory.duplicate()

## Clear all inventory
func clear_inventory() -> void:
	inventory.clear()
	inventory_updated.emit()

## Get total value of inventory
func get_total_value() -> int:
	var total := 0
	for item_id in inventory:
		var item_data := get_item_data(item_id)
		if item_data:
			total += item_data.value * inventory[item_id]
	return total

## Initialize tab system
func _initialize_tabs() -> void:
	# Create main tab if it doesn't exist
	if not tabs.has(MAIN_TAB_ID):
		tabs[MAIN_TAB_ID] = {
			"name": "Main",
			"items": inventory
		}
		tab_order.append(MAIN_TAB_ID)

## Create a new inventory tab
func create_tab(tab_name: String) -> String:
	if tab_order.size() >= MAX_TABS:
		push_error("Cannot create more than %d tabs" % MAX_TABS)
		return ""
	
	# Validate tab name
	var validated_name := tab_name.strip_edges()
	if validated_name.is_empty():
		validated_name = "Tab %d" % (tabs.size())
	elif validated_name.length() > 20:
		validated_name = validated_name.substr(0, 20)
	
	# Generate unique tab ID
	var counter := 0
	var tab_id := "tab_%d" % counter
	while tabs.has(tab_id):
		counter += 1
		tab_id = "tab_%d" % counter
	
	tabs[tab_id] = {
		"name": validated_name,
		"items": {}
	}
	tab_order.append(tab_id)
	tab_created.emit(tab_id, validated_name)
	inventory_updated.emit()
	return tab_id

## Delete a tab (cannot delete main tab)
func delete_tab(tab_id: String) -> bool:
	if tab_id == MAIN_TAB_ID:
		push_error("Cannot delete main tab")
		return false
	
	if not tabs.has(tab_id):
		return false
	
	# Move all items from this tab to main tab
	var tab_data: Dictionary = tabs[tab_id]
	var tab_items: Dictionary = tab_data.get("items", {})
	for item_id in tab_items:
		var amount: int = tab_items[item_id]
		add_item_to_tab(MAIN_TAB_ID, item_id, amount)
	
	tabs.erase(tab_id)
	tab_order.erase(tab_id)
	tab_deleted.emit(tab_id)
	inventory_updated.emit()
	return true

## Rename a tab
func rename_tab(tab_id: String, new_name: String) -> bool:
	if not tabs.has(tab_id):
		return false
	
	# Validate tab name
	var validated_name := new_name.strip_edges()
	if validated_name.is_empty():
		return false
	elif validated_name.length() > 20:
		validated_name = validated_name.substr(0, 20)
	
	tabs[tab_id]["name"] = validated_name
	tab_renamed.emit(tab_id, validated_name)
	return true

## Get tab name
func get_tab_name(tab_id: String) -> String:
	if tabs.has(tab_id):
		return tabs[tab_id].get("name", "")
	return ""

## Get all items in a specific tab
func get_tab_items(tab_id: String) -> Dictionary:
	if tabs.has(tab_id):
		return tabs[tab_id].get("items", {}).duplicate()
	return {}

## Add item to specific tab
func add_item_to_tab(tab_id: String, item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	
	if not tabs.has(tab_id):
		return false
	
	var tab_items: Dictionary = tabs[tab_id]["items"]
	var current: int = tab_items.get(item_id, 0)
	tab_items[item_id] = current + amount
	
	# Update legacy inventory if this is the main tab
	if tab_id == MAIN_TAB_ID:
		inventory = tab_items
	
	item_added.emit(item_id, amount, tab_items[item_id])
	inventory_updated.emit()
	return true

## Remove item from specific tab
func remove_item_from_tab(tab_id: String, item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	
	if not tabs.has(tab_id):
		return false
	
	var tab_items: Dictionary = tabs[tab_id]["items"]
	var current: int = tab_items.get(item_id, 0)
	if current < amount:
		return false
	
	tab_items[item_id] = current - amount
	if tab_items[item_id] <= 0:
		tab_items.erase(item_id)
	
	# Update legacy inventory if this is the main tab
	if tab_id == MAIN_TAB_ID:
		inventory = tab_items
	
	item_removed.emit(item_id, amount, tab_items.get(item_id, 0))
	inventory_updated.emit()
	return true

## Move item between tabs
func move_item_between_tabs(item_id: String, from_tab: String, to_tab: String, amount: int = 1) -> bool:
	if from_tab == to_tab:
		return false
	
	if not tabs.has(from_tab) or not tabs.has(to_tab):
		return false
	
	var from_items: Dictionary = tabs[from_tab]["items"]
	var current: int = from_items.get(item_id, 0)
	
	if current < amount:
		return false
	
	# Remove from source tab
	if remove_item_from_tab(from_tab, item_id, amount):
		# Add to destination tab
		if add_item_to_tab(to_tab, item_id, amount):
			item_moved_between_tabs.emit(item_id, from_tab, to_tab)
			return true
		else:
			# Rollback if add failed
			add_item_to_tab(from_tab, item_id, amount)
			return false
	
	return false

## Get item count in specific tab
func get_item_count_in_tab(tab_id: String, item_id: String) -> int:
	if tabs.has(tab_id):
		return tabs[tab_id].get("items", {}).get(item_id, 0)
	return 0

## Check if player has enough of an item in specific tab
func has_item_in_tab(tab_id: String, item_id: String, amount: int = 1) -> bool:
	return get_item_count_in_tab(tab_id, item_id) >= amount
