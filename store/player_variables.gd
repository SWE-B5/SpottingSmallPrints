extends Node

enum CameraTypes { MAP, FOLLOW }

func _ready():
	load_from_path(Constants.SAVE_PATH)

# Erstellt ein JSON-String von den Daten, welche gespeichert werden sollten
func jsonify():
	return JSON.stringify({
		"completed_levels": completed_levels
	})

# Lädt Daten von dem vorheringen Spiel in das jetztige
func load_from_path(path: String):
	if not FileAccess.file_exists(path):
		save_to_path(path)
	else:
		save_to_path(path)

	var file = FileAccess.open(path, FileAccess.READ)
	var obj = JSON.parse_string(file.get_as_text())
	print(obj)
	
# Speichert die Daten zu einem bestimmten Path
func save_to_path(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(jsonify())

var speed: int = 40
var active_camera: CameraTypes = CameraTypes.FOLLOW
var hp: float = Constants.START_HP
var zoom_niveau: float = 5
var freezed: bool = false

var completed_levels = []
