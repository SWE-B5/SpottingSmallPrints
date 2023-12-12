extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap

func _ready():
	PlayerVariables.load_medium_game()
	fog.init(tilemap, player)
	Health.reset_health() #muss bleiben
	Inventory.update_after_death() #muss bleiben
	
func _process(_delta):
	fog.update_pos(player.position)
