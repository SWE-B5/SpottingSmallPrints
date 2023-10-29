extends Node

@onready var player = $".."


func _process(delta):
	pass
	
	if PlayerVariables.active_camera == PlayerVariables.CameraTypes.MAP:
		print("map")
		get_tree().paused = true 
	else:
		print("follow")
		get_tree().paused = false
		
