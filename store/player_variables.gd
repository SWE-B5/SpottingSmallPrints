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
		"shield": shield
	})

# Lädt Daten von dem vorheringen Spiel in das jetztige
func load_from_path(path: String):
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
	shield = obj.shield
	return true
	
# Speichert die Daten zu einem bestimmten Path
func save_to_path(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(jsonify())

func generate_hard_game():
	load_hard_game()
	
func generate_medium_game():
	load_medium_game()
	
func generate_easy_game():
	load_easy_game()
	
func load_easy_game():
	difficulty = Difficulty.EASY
	speed = Constants.EASY_SPEED
	max_lives = 3
	current_lives = 3
	
func load_medium_game():
	difficulty = Difficulty.MEDIUM
	speed = Constants.MEDIUM_SPEED
	max_lives = 2
	current_lives = 2

func load_hard_game():
	difficulty = Difficulty.HARD
	speed = Constants.HARD_SPEED
	max_lives = 1
	current_lives = 1

var max_lives: int
var current_lives: int

var speed: int
var active_camera: CameraTypes = CameraTypes.FOLLOW
var difficulty: Difficulty

# brauchen wir das? nö oder
var hp: float = Constants.START_HP 

# Ob der Spieler ein Schild hat oder nicht
var shield: bool = false

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
