extends Node
#Autor Leon Frings

#getter and setter for saving
func set_for_load(array):
	max_lives = array[0]
	if SAVE_SHIELD:
		shield = array[1]
	else:
		shield = INACTIVE
	if SAVE_LIVES:
		current_lives = array[2]
	else:
		current_lives = max_lives
	update_hud()

func get_for_save():
	return [max_lives, shield, current_lives]

#returns whether able to apply shield
#true = can activate
#false = already activated
func check_shield_possible():
	if (shield == ACTIVE):
		return false
	else:
		return true

#activates shield
func apply_shield():
	shield = ACTIVE
	update_hud()

#resets lives to current max_lives setting
#max_lives can be changes with first parameter as well
#shield is kept or reset depending on KEEP_SHIELD_AT_RESET setting
#explicit shield state can be set via second parameter
func reset_health(new_max_lives: int = max_lives, new_shield: Shield_States = shield):
	max_lives = new_max_lives
	current_lives = max_lives
	if (KEEP_SHIELD_AT_RESET):
		shield = new_shield
	elif (new_shield!= shield):
		shield = new_shield
	else:
		shield = INACTIVE
	update_hud()

#deals damage to the player/deactivates shield
#goes to death_screen if player dies 
func damage_player(damage:int = 1):
	if debug_immunity:
		return
	if shield ==ACTIVE:
		shield = INACTIVE
	else:
		current_lives -= damage
	update_hud()
	if current_lives <= 0 :
		is_death = true
		get_tree().current_scene.fog.save_fog()
		get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")


###########################################
# Alles hier drunter nur intern verwendet #
###########################################

#Var für death_screen in start_menu Scene
var is_death: bool = false 

#Shield_sates type
enum Shield_States {ACTIVE = 1, INACTIVE = 0}
const ACTIVE = Shield_States.ACTIVE
const INACTIVE = Shield_States.INACTIVE

#player health
var current_lives = 1
var shield: Shield_States = INACTIVE

#Settings
var max_lives = 1
const SAVE_LIVES = false
const SAVE_SHIELD = false
const KEEP_SHIELD_AT_RESET = false
const debug_immunity = false

#short form
func update_hud():
	#if get_tree().get_first_node_in_group("Group HUDs"):
	#	.update_health_hud(current_lives, shield)
	get_tree().call_group("Group HUDs", "update_health_hud", current_lives, shield)
