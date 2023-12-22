extends Node

var PLAYER: CharacterBody2D

func _ready():
	PLAYER = get_tree().current_scene.get_node("Player")
	

func _on_level_1_body_entered(body):
	body.switch_level("level_1")


func _on_level_2_body_entered(body):
	body.switch_level("level_2")


func _on_level_3_body_entered(body):
	body.switch_level("level_3")


func _on_level_end_body_entered(body):
	body.switch_level("level_end")


func _on_finish_game_body_entered(body):
	body.switch_level("outro")
