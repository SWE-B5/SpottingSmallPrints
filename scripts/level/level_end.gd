extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap

func _ready():
	PlayerVariables.load_medium_game()
	fog.init(tilemap, player)
	Health.reset_health()
	Inventory.update_after_death()
	
func _process(_delta):
	fog.update_pos(player.position)
