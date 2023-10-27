extends Node

@onready var player = $".."

func _process(delta):
	handle_map_input()
	handle_camera()
	
	if PlayerVariables.is_active_camera == PlayerVariables.CameraTypes.MAP:
		get_tree().paused = true
	else:
		get_tree().paused = false
		
func handle_map_input():
	if Input.is_action_just_pressed("map") && player.can_open_map():
		if PlayerVariables.is_active_camera ==  PlayerVariables.CameraTypes.FOLLOW:
			PlayerVariables.is_active_camera = PlayerVariables.CameraTypes.MAP
		else:
			PlayerVariables.is_active_camera = PlayerVariables.CameraTypes.FOLLOW

func handle_camera():
	if PlayerVariables.is_active_camera == PlayerVariables.CameraTypes.FOLLOW:
		$"../FollowCamera".zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)
		$"../FollowCamera".make_current()
	else:
		$MapCamera.zoom = Vector2(0.5, 0.5)
		$MapCamera.make_current()
