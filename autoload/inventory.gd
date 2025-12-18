## Inventory Autoload
## Manages player items and item data
extends Node

signal item_added(item_id: String, amount: int, new_total: int)
signal item_removed(item_id: String, amount: int, new_total: int)
signal inventory_updated()

## Item data registry
var items: Dictionary = {}  # item_id: ItemData

## Player inventory
var inventory: Dictionary = {}  # item_id: quantity

func _ready() -> void:
	_load_items()

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
	_add_item("logs", "Logs", "Standard wooden logs.", ItemData.ItemType.RAW_MATERIAL, 5)
	_add_item("oak_logs", "Oak Logs", "Sturdy oak logs.", ItemData.ItemType.RAW_MATERIAL, 20)
	_add_item("willow_logs", "Willow Logs", "Flexible willow logs.", ItemData.ItemType.RAW_MATERIAL, 40)
	_add_item("maple_logs", "Maple Logs", "Quality maple logs.", ItemData.ItemType.RAW_MATERIAL, 80)
	_add_item("yew_logs", "Yew Logs", "Valuable yew logs.", ItemData.ItemType.RAW_MATERIAL, 200)
	_add_item("magic_logs", "Magic Logs", "Magical logs.", ItemData.ItemType.RAW_MATERIAL, 500)
	_add_item("redwood_logs", "Redwood Logs", "Massive redwood logs.", ItemData.ItemType.RAW_MATERIAL, 1000)
	_add_item("achey_logs", "Achey Logs", "Flexible achey logs.", ItemData.ItemType.RAW_MATERIAL, 15)
	_add_item("teak_logs", "Teak Logs", "Durable teak logs.", ItemData.ItemType.RAW_MATERIAL, 90)
	_add_item("mahogany_logs", "Mahogany Logs", "Rich mahogany logs.", ItemData.ItemType.RAW_MATERIAL, 150)
	_add_item("arctic_pine_logs", "Arctic Pine Logs", "Hardy arctic pine logs.", ItemData.ItemType.RAW_MATERIAL, 170)
	_add_item("eucalyptus_logs", "Eucalyptus Logs", "Fragrant eucalyptus logs.", ItemData.ItemType.RAW_MATERIAL, 220)
	_add_item("elder_logs", "Elder Logs", "Mystical elder logs.", ItemData.ItemType.RAW_MATERIAL, 280)
	_add_item("blisterwood_logs", "Blisterwood Logs", "Cursed blisterwood logs.", ItemData.ItemType.RAW_MATERIAL, 350)
	_add_item("bloodwood_logs", "Bloodwood Logs", "Crimson bloodwood logs.", ItemData.ItemType.RAW_MATERIAL, 450)
	_add_item("crystal_logs", "Crystal Logs", "Shimmering crystal logs.", ItemData.ItemType.RAW_MATERIAL, 600)
	_add_item("spirit_logs", "Spirit Logs", "Ancient spirit tree logs.", ItemData.ItemType.RAW_MATERIAL, 750)
  
	# Fletching materials
	_add_item("arrow_shafts", "Arrow Shafts", "Wooden shafts for arrows.", ItemData.ItemType.PROCESSED, 1)
	_add_item("feather", "Feather", "A feather for fletching arrows.", ItemData.ItemType.RAW_MATERIAL, 2)
	_add_item("bowstring", "Bowstring", "String for stringing bows.", ItemData.ItemType.PROCESSED, 10)
	_add_item("bronze_arrowhead", "Bronze Arrowhead", "A bronze arrowhead.", ItemData.ItemType.PROCESSED, 3)
	
	# Bows
	_add_item("shortbow", "Shortbow", "A basic shortbow.", ItemData.ItemType.TOOL, 50)
	_add_item("longbow", "Longbow", "A basic longbow.", ItemData.ItemType.TOOL, 100)
	_add_item("oak_shortbow", "Oak Shortbow", "A shortbow made of oak.", ItemData.ItemType.TOOL, 150)
	_add_item("oak_longbow", "Oak Longbow", "A longbow made of oak.", ItemData.ItemType.TOOL, 200)
	_add_item("willow_shortbow", "Willow Shortbow", "A shortbow made of willow.", ItemData.ItemType.TOOL, 300)
	_add_item("willow_longbow", "Willow Longbow", "A longbow made of willow.", ItemData.ItemType.TOOL, 400)
	_add_item("maple_shortbow", "Maple Shortbow", "A shortbow made of maple.", ItemData.ItemType.TOOL, 600)
	_add_item("maple_longbow", "Maple Longbow", "A longbow made of maple.", ItemData.ItemType.TOOL, 800)
	_add_item("yew_shortbow", "Yew Shortbow", "A shortbow made of yew.", ItemData.ItemType.TOOL, 1200)
	_add_item("yew_longbow", "Yew Longbow", "A longbow made of yew.", ItemData.ItemType.TOOL, 1600)
	_add_item("magic_shortbow", "Magic Shortbow", "A magical shortbow.", ItemData.ItemType.TOOL, 2500)
	_add_item("magic_longbow", "Magic Longbow", "A magical longbow.", ItemData.ItemType.TOOL, 3500)
	
	# Arrows
	_add_item("headless_arrow", "Headless Arrow", "An arrow without an arrowhead.", ItemData.ItemType.PROCESSED, 2)
	_add_item("bronze_arrow", "Bronze Arrow", "An arrow with a bronze tip.", ItemData.ItemType.PROCESSED, 5)
  
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
	
	# Bars (smelted from ores)
	_add_item("bronze_bar", "Bronze Bar", "A bar of bronze metal.", ItemData.ItemType.PROCESSED, 15)
	_add_item("iron_bar", "Iron Bar", "A bar of iron metal.", ItemData.ItemType.PROCESSED, 30)
	_add_item("silver_bar", "Silver Bar", "A bar of silver metal.", ItemData.ItemType.PROCESSED, 50)
	_add_item("steel_bar", "Steel Bar", "A bar of refined steel.", ItemData.ItemType.PROCESSED, 100)
	_add_item("gold_bar", "Gold Bar", "A bar of gold metal.", ItemData.ItemType.PROCESSED, 150)
	_add_item("mithril_bar", "Mithril Bar", "A bar of mithril metal.", ItemData.ItemType.PROCESSED, 300)
	_add_item("adamantite_bar", "Adamantite Bar", "A bar of adamantite metal.", ItemData.ItemType.PROCESSED, 600)
	_add_item("runite_bar", "Runite Bar", "A bar of runite metal.", ItemData.ItemType.PROCESSED, 1500)
  
	# Firemaking products
	_add_item("ashes", "Ashes", "Remains of burnt logs.", ItemData.ItemType.PROCESSED, 1)
	
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
	_add_item("sapphire_ring", "Sapphire Ring", "A gold ring with a sapphire.", ItemData.ItemType.PROCESSED, 250)
	_add_item("emerald_ring", "Emerald Ring", "A gold ring with an emerald.", ItemData.ItemType.PROCESSED, 450)
	_add_item("ruby_ring", "Ruby Ring", "A gold ring with a ruby.", ItemData.ItemType.PROCESSED, 800)
	_add_item("diamond_ring", "Diamond Ring", "A gold ring with a diamond.", ItemData.ItemType.PROCESSED, 1400)
	_add_item("dragonstone_ring", "Dragonstone Ring", "A gold ring with a dragonstone.", ItemData.ItemType.PROCESSED, 2500)
	_add_item("onyx_ring", "Onyx Ring", "A gold ring with an onyx.", ItemData.ItemType.PROCESSED, 5000)
	
	# Jewelry - Necklaces
	_add_item("sapphire_necklace", "Sapphire Necklace", "A gold necklace with a sapphire.", ItemData.ItemType.PROCESSED, 300)
	_add_item("emerald_necklace", "Emerald Necklace", "A gold necklace with an emerald.", ItemData.ItemType.PROCESSED, 550)
	_add_item("ruby_necklace", "Ruby Necklace", "A gold necklace with a ruby.", ItemData.ItemType.PROCESSED, 950)
	_add_item("diamond_necklace", "Diamond Necklace", "A gold necklace with a diamond.", ItemData.ItemType.PROCESSED, 1600)
	_add_item("dragonstone_necklace", "Dragonstone Necklace", "A gold necklace with a dragonstone.", ItemData.ItemType.PROCESSED, 2800)
	_add_item("onyx_necklace", "Onyx Necklace", "A gold necklace with an onyx.", ItemData.ItemType.PROCESSED, 5500)


## Helper to add item definition
func _add_item(id: String, display_name: String, desc: String, type: ItemData.ItemType, value: int) -> void:
	var item := ItemData.new()
	item.id = id
	item.name = display_name
	item.description = desc
	item.type = type
	item.value = value
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
