extends Node2D

@onready var player = $Player

func _ready():
	$Fog.draw()
	
func _process(delta):
	$Fog.tick(player.position)
