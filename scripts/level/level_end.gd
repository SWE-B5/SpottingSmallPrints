extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap

func _ready():
	fog.init(tilemap, player)
	Health.reset_health()
	Inventory.update_after_death()
	PlayerVariables.flag_action_after_dialog = 0
	PlayerVariables.ref_last_dialog = 0
	PlayerVariables.flag_raetsel_open = false
	PlayerVariables.flag_dialog_open = false
	PlayerVariables.immobile = false
