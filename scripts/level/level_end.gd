extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap

func _ready():
	fog.init(tilemap, player)
	Health.reset_health()
	Inventory.update_after_death()
