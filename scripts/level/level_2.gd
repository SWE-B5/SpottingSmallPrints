extends Node2D

@onready var player = $Player
@onready var fog = $Fog

# Called when the node enters the scene tree for the first time.
func _ready():
	var tilemap = $TileMap
	fog.init(tilemap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fog.update_pos(player.position)
