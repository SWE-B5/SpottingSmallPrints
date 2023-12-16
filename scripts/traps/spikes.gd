extends Area2D

var PLAYER: CharacterBody2D

func _ready():
	$AnimationPlayer.play("spikes")
	PLAYER = get_parent().get_node("Player")

func _on_body_entered(body):
	if(PlayerVariables.immunity_frames <= 0):
		Health.damage_player()
		PLAYER.damage_animation()
		PlayerVariables.immunity_frames = PlayerVariables.immunity_duration
