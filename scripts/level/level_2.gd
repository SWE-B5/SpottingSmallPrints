extends Node2D

@onready var player = $Player
@onready var fog = $Fog

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.load_easy_game()
	fog.draw()
	fog.remove_standart_circle(player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fog.tick(player.position)
