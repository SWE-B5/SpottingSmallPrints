extends Area2D

var PLAYER: CharacterBody2D

func _ready():
	PLAYER = get_tree().current_scene.get_node("Player")

func _on_body_entered(body):
	if(PlayerVariables.immunity_frames <= 0):
		Health.damage_player()
