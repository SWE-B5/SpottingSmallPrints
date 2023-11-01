extends Node

enum CameraTypes { MAP, FOLLOW }
enum Difficulty { EASY, NORMAL, HARD }

func _ready():
	load_from_path(Constants.SAVE_PATH)

# Erstellt ein JSON-String von den Daten, welche gespeichert werden sollten
func jsonify():
	return JSON.stringify({
		"completed_levels": completed_levels,
		"difficulty": difficulty
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

func generate_hard_game():
	speed = 20
	difficulty = Difficulty.HARD
	max_lives = 1
	current_lives = 1
	
func generate_medium_game():
	speed = 50
	difficulty = Difficulty.NORMAL
	max_lives = 2
	current_lives = 2
	
func generate_easy_game():
	speed = 100
	difficulty = Difficulty.EASY
	max_lives = 3
	current_lives = 3

var max_lives: int = 3
var current_lives: int = 3

var speed: int = 40
var active_camera: CameraTypes = CameraTypes.FOLLOW
var difficulty: Difficulty = Difficulty.NORMAL
var hp: float = Constants.START_HP

# Je höher das Zoom Niveau ist desto mehr reingezoomt ist der Spieler
var zoom_niveau: float = 5

# heißt, alle Movement sind geblockt aber andere Projektile usw. bewegen sich trotzdem
var immobile: bool = false

# In welchem Level der Spieler sich befindet, 0 ist Hub, 1-N sind die Labyrinthe
var current_level = 0

# erstes Level = 0, diese Türen kann man dann nicht mehr öffnen
var completed_levels = []
