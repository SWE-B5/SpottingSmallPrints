extends Node

enum CameraTypes { MAP, FOLLOW }
enum Difficulty { EASY, MEDIUM, HARD }

func _ready():
	pass

func _process(delta):
	pass

# Erstellt ein JSON-String von den Daten, welche gespeichert werden sollten
func jsonify():
	return JSON.stringify({
		"completed_levels": completed_levels,
		"notes_collected": notes_collected,
		"difficulty": difficulty,
		"health": Health.get_for_save()
	})

# Lädt Daten von dem vorheringen Spiel in das jetztige
func load_from_path(path: String):
	print(FileAccess.file_exists(path))
	
	if not FileAccess.file_exists(path):
		return false

	var file = FileAccess.open(path, FileAccess.READ)
	var obj = JSON.parse_string(file.get_as_text())
	
	difficulty = obj.difficulty
	
	if difficulty == Difficulty.EASY:
		load_easy_game()
	elif difficulty == Difficulty.MEDIUM:
		load_medium_game()
	elif difficulty == Difficulty.HARD:
		load_hard_game()
	
	completed_levels = obj.completed_levels
	notes_collected = obj.notes_collected
	Health.set_for_load(obj.health)
	return true
	
# Speichert die Daten zu einem bestimmten Path
func save_to_path(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(jsonify())

func generate_hard_game():
	Health.reset_health(3, Health.INACTIVE)
	load_hard_game()
	
func generate_medium_game():
	Health.reset_health(2, Health.INACTIVE)
	load_medium_game()
	
func generate_easy_game():
	Health.reset_health(1, Health.INACTIVE)
	load_easy_game()
	
func load_easy_game():
	difficulty = Difficulty.EASY
	speed = Constants.EASY_SPEED
	
	
func load_medium_game():
	difficulty = Difficulty.MEDIUM
	speed = Constants.MEDIUM_SPEED
	

func load_hard_game():
	difficulty = Difficulty.HARD
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

# erstes Level = 0, diese Türen kann man dann nicht mehr öffnen
var completed_levels = []

# Notes die im ganzen Spiel collected wurden
var notes_collected = []

# Die Notes die wir gerade im Level gespeichert haben
var current_level_collected_notes = []

# Immunity Frames
var immunity_frames: float

# Immunity Duration
const immunity_duration = 1.2
