extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap

func _ready():
	PlayerVariables.initialize_new_game(PlayerVariables.Difficulty.EASY) # kann später raus
	fog.init(tilemap, player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!
	
