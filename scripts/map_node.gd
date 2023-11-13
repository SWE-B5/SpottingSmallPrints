extends Node

const ZOOM_LEVEL = 0.8
const ZOOM_INCREASE = 0.01

@onready var player = $"../.."
@onready var map_camera = $MapCamera
@onready var follow_camera = $"../../FollowCamera"

var current_zoom_level = PlayerVariables.zoom_niveau
var is_active = false

func _process(delta):	
	handle_map_input()
	handle_zoom()
	
func handle_map_input():
	if Input.is_action_just_pressed("map") && player.can_open_map():
		if PlayerVariables.active_camera == PlayerVariables.CameraTypes.FOLLOW:
			PlayerVariables.active_camera = PlayerVariables.CameraTypes.MAP
		else:
			PlayerVariables.active_camera = PlayerVariables.CameraTypes.FOLLOW	
		handle_camera()

func handle_zoom():
	if is_active:
		if current_zoom_level > ZOOM_LEVEL:
			current_zoom_level -= ZOOM_INCREASE
			follow_camera.zoom = Vector2(current_zoom_level, current_zoom_level)

func handle_camera():
	if PlayerVariables.active_camera == PlayerVariables.CameraTypes.FOLLOW:
		PlayerVariables.immobile = false
		follow_camera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)
		follow_camera.make_current()
		is_active = false
	else:
		PlayerVariables.immobile = true
		follow_camera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)
		current_zoom_level = PlayerVariables.zoom_niveau
		follow_camera.make_current()
		is_active = true
