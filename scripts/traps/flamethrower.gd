extends Area2D

func _on_body_entered(body):
	if(PlayerVariables.immunity_frames <= 0):
		#Health.damage_player()
		PlayerVariables.immunity_frames = PlayerVariables.immunity_duration
