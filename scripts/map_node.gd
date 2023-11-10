extends Node

@onready var player = $"../.."
@onready var map_camera = $MapCamera
@onready var follow_camera = $"../../FollowCamera"

func _process(delta):	
	handle_map_input()
	
func handle_map_input():
	if Input.is_action_just_pressed("map") && player.can_open_map():
		if PlayerVariables.active_camera == PlayerVariables.CameraTypes.FOLLOW:
			PlayerVariables.active_camera = PlayerVariables.CameraTypes.MAP
		else:
			PlayerVariables.active_camera = PlayerVariables.CameraTypes.FOLLOW	
		handle_camera()

func handle_camera():
	if PlayerVariables.active_camera == PlayerVariables.CameraTypes.FOLLOW:
		PlayerVariables.immobile = false
		follow_camera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)
		follow_camera.make_current()
	else:
		PlayerVariables.immobile = true
		follow_camera.zoom = Vector2(0.6, 0.6)
		follow_camera.make_current()
