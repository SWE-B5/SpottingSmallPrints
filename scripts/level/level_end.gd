extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap

func _ready():
	PlayerVariables.save_game()
	PlayerVariables.level_end = true
	
	fog.init(tilemap, player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!
	PlayerVariables.flag_action_after_dialog = 0
	PlayerVariables.ref_last_dialog = 0
	PlayerVariables.flag_raetsel_open = false
	PlayerVariables.flag_dialog_open = false
	PlayerVariables.immobile = false
