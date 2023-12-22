extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap
 
func _ready():
	PlayerVariables.current_level = 2
	PlayerVariables.save_game()	
	fog.init(tilemap, player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!
