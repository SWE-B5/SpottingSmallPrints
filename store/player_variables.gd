extends Node

enum CameraTypes { MAP, FOLLOW }

func _ready():
	load_from_path(Constants.SAVE_PATH)

func jsonify():
	return JSON.stringify({
		"completed_levels": completed_levels
	})

func load_from_path(path: String):
	if not FileAccess.file_exists(path):
		save_to_path(path)
	else:
		save_to_path(path)

	var file = FileAccess.open(path, FileAccess.READ)
	var obj = JSON.parse_string(file.get_as_text())
	print(obj)
	
func save_to_path(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_line(jsonify())

var speed = 100
var is_active_camera = CameraTypes.FOLLOW
var hp = Constants.START_HP
var zoom_niveau = 5
var freezed = false

var completed_levels = []
