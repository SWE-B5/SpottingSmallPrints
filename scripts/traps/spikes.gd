extends Area2D

func _ready():
	$AnimationPlayer.play("spikes")

func _on_body_entered(body):
	if(PlayerVariables.immunity_frames <= 0):
		print("player entered")
		PlayerVariables.immunity_frames = PlayerVariables.immunity_duration
