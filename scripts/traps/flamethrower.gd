extends Area2D

var PLAYER: CharacterBody2D

func _ready():
	PLAYER = get_tree().current_scene.get_node("Player")

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if(PlayerVariables.immunity_frames <= 0):
		Health.damage_player()
