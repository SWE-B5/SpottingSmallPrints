extends Node2D

@onready var tilemap = $TileMap
@onready var player = $Player
@onready var fog = $Fog

func _ready():
	fog.init(tilemap, player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!

