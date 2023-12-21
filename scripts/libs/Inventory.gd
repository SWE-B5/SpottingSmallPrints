extends Node
#Autor: Leon Frings

#getter and setter for saving
func get_for_save():
	return [inventory, active_items_count]
	
func set_for_load(array):
	inventory = array[0]
	active_items_count = array[1]
	update_huds(SILVER)
	update_huds(GOLD)
	update_huds(DIAMOND)
	update_huds(NOTE)

#resets inventory completely
func update_new_game():
	inventory = [[],[],[],[],[]]
	active_items_count = [0,0,0,0,0]
	update_huds(SILVER)
	update_huds(GOLD)
	update_huds(DIAMOND)
	update_huds(NOTE)

#resets silver_keys and notes from current level in inventory
func update_after_death():
	inventory[SILVER] = []
	active_items_count[SILVER] = 0
	update_huds(SILVER)
	active_items_count[NOTE] = 0
	inventory[NOTE] = []
	update_huds(NOTE)
	#für Aufruf in _ready von leveln
	update_huds(GOLD) 
	update_huds(DIAMOND) 

#resets silver_keys and notes from current level in inventory
func update_after_level_completed():
	inventory[NOTE_GLOBAL] += inventory[NOTE]
	active_items_count[NOTE_GLOBAL] += active_items_count[NOTE]
	update_after_death()

#adds item to inventory
func collect_item(type: Item_Type, id: int):
	inventory[type] += [id]
	active_items_count[type] += 1
	if type <= 3:
		update_huds(type)

#decreases usable KEY count for key_type, if possible
func use_key(type: Item_Type):
	if(type < 3):
		if active_items_count[type] > 0:
			active_items_count[type] -= 1
			update_huds(type)

#checks inventory for KEY of specific type and id
#is in invenotory = true
#not in inventory/wrong type = false
func check_key(type: Item_Type, id: int):
	if (type < 3):
		for n in inventory[type].size():
			if inventory[type][n] == id:
				return true
	return false

#returns if all notes of the current Level have been found
#all found = true
#not all found = false
func check_all_notes_current_level():
	return NOTES_PER_LEVEL <= inventory[NOTE].size()

#for hub setup
#returns the number of opened gold doors
func number_of_opened_gold_doors():
	return inventory[GOLD].size() - active_items_count[GOLD]

#for hub setup
#returns the number of notes found 
func number_of_notes_found():
	return inventory[NOTE_GLOBAL].size() + inventory[NOTE].size()

#returns the id x'th note in Inventory
#index starts at 0
#after NOTE-Inventory continues in NOTE_GLOBAL-Inentory
#returns -1 if x >= number of collected notes or <0
func get_xth_found_note_id(x: int):
	if (x >= 0):
		if (x < inventory[NOTE].size()):
			return inventory[NOTE][x]
		else:
			x -= inventory[NOTE].size()
			if (x < inventory[NOTE].size()):
				return inventory[NOTE_GLOBAL][x]
	return -1

###########################################
# Alles hier drunter nur intern verwendet #
###########################################

#Setting
const NOTES_PER_LEVEL: int  = 3;

enum Item_Type {SILVER = 0, GOLD = 1, DIAMOND = 2, NOTE = 3, NOTE_GLOBAL = 4}
const SILVER = Item_Type.SILVER
const GOLD = Item_Type.GOLD
const DIAMOND = Item_Type.DIAMOND
const NOTE = Item_Type.NOTE
const NOTE_GLOBAL = Item_Type.NOTE_GLOBAL


#Inventory
var inventory = [[],[],[],[],[]] 
#count of items, not yet used
var active_items_count = [0,0,0,0,0]

var dialogue_temp_silver_id = 0
var dialogue_temp_gold_id = 0

#short form
func update_huds(type: Item_Type):
	if type == 3:
		get_tree().call_group("Group HUDs", "update_note_hud", active_items_count[NOTE])
	else:
		get_tree().call_group("Group HUDs", "update_key_hud", type, active_items_count[type])
