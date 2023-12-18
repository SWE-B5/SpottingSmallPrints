extends Node

enum CameraTypes { MAP, FOLLOW }
enum Difficulty { EASY, MEDIUM, HARD }

# Erstellt ein JSON-String von den Daten, welche gespeichert werden sollten
func jsonify():
	return JSON.stringify({
		"difficulty": difficulty,
		"health": Health.get_for_save(),
		"inventory": Inventory.get_for_save(),
		"current_level": current_level
	})

# Lädt Daten von dem vorheringen Spiel in das jetztige
func load_save_file():
	print(FileAccess.file_exists(Constants.SAVE_PATH))
	
	if not FileAccess.file_exists(Constants.SAVE_PATH):
		return false

	var file = FileAccess.open(Constants.SAVE_PATH, FileAccess.READ)
	var obj = JSON.parse_string(file.get_as_text())
	
	difficulty = obj.difficulty
	Inventory.set_for_load(obj.inventory)
	Health.set_for_load(obj.health)
	current_level = obj.current_level
	initialize_unsaved_vars()
	return true
	
# Speichert das Spiel, überschreibt alten Spielstand, wenn vorhanden
func save_game():
	var file = FileAccess.open(Constants.SAVE_PATH, FileAccess.WRITE)
	file.store_line(jsonify())

# Löscht, alten Spielstand
func delete_save_file():
	var dir = DirAccess.open(Constants.SAVE_DIRECTORY)
	dir.remove(Constants.SAVE_FILE_NAME)

func initialize_new_game(diff: Difficulty):
	delete_save_file()
	difficulty = diff
	Inventory.update_new_game()
	current_level = 0
	match difficulty:
		Difficulty.EASY:
			Health.reset_health(3, Health.INACTIVE)
		Difficulty.MEDIUM:
			Health.reset_health(2, Health.INACTIVE)
		Difficulty.HARD:
			Health.reset_health(1, Health.INACTIVE)
	print(Health.max_lives)
	initialize_unsaved_vars()
	save_game()

func initialize_unsaved_vars():
	active_camera = CameraTypes.FOLLOW
	zoom_niveau = 5
	immobile = false
	match difficulty:
		Difficulty.EASY:
			speed = Constants.EASY_SPEED
		Difficulty.MEDIUM:
			speed = Constants.MEDIUM_SPEED
		Difficulty.HARD:
			speed = Constants.HARD_SPEED

var speed: int
var active_camera: CameraTypes = CameraTypes.FOLLOW
var difficulty: Difficulty

# Je höher das Zoom Niveau ist desto mehr reingezoomt ist der Spieler
var zoom_niveau: float = 5

# heißt, alle Movement sind geblockt aber andere Projektile usw. bewegen sich trotzdem
var immobile: bool = false

# In welchem Level der Spieler sich befindet, 0 ist Hub, 1-N sind die Labyrinthe
var current_level = 0

# Immunity Frames
var immunity_frames: float

# Immunity Duration
const immunity_duration = 1.2

var global_position: Vector2
