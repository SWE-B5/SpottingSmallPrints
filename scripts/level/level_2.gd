extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap
 

# Called when the node enters the scene tree for the first time.
 
func _ready():
	
	fog.init(tilemap, player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!
