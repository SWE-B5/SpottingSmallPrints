extends Node2D

@onready var fog = $Fog
@onready var player = $Player

func _ready():
	fog.draw()
	
func _process(delta):
	fog.tick(player.global_position)
