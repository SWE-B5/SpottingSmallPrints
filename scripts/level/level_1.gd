extends Node2D

@onready var player = $Player
@onready var fog = $Fog

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.load_easy_game()
	fog.init($TileMap, $Player)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fog.update_pos(player.position)
