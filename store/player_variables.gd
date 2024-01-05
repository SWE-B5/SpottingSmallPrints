extends Node

enum CameraTypes { MAP, FOLLOW }
enum Difficulty { EASY, MEDIUM, HARD }

# Erstellt ein JSON-String von den Daten, welche gespeichert werden sollten
func jsonify():
	return JSON.stringify({
		"difficulty": difficulty,
		"health": Health.get_for_save(),
		"inventory": Inventory.get_for_save(),
		"current_level": current_level,
		"highest_completed_level": highest_completed_level
	})

# Lädt Daten von dem vorheringen Spiel in das jetztige
func load_save_file():
	if not FileAccess.file_exists(Constants.SAVE_PATH):
		return false

	var file = FileAccess.open(Constants.SAVE_PATH, FileAccess.READ)
	var obj = JSON.parse_string(file.get_as_text())
	
	difficulty = obj.difficulty
	Inventory.set_for_load(obj.inventory)
	Health.set_for_load(obj.health)
	current_level = obj.current_level
	highest_completed_level = obj.highest_completed_level
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
	highest_completed_level = -1
	match difficulty:
		Difficulty.EASY:
			Health.reset_health(Constants.EASY_MAX_HEALTH, Health.INACTIVE)
		Difficulty.MEDIUM:
			Health.reset_health(Constants.MEDIUM_MAX_HEALTH, Health.INACTIVE)
		Difficulty.HARD:
			Health.reset_health(Constants.HARD_MAX_HEALTH, Health.INACTIVE)
	initialize_unsaved_vars()
	save_game()

func initialize_unsaved_vars():
	lightsout_is_finnished = false
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
var lightsout_is_finnished = false
# Je höher das Zoom Niveau ist desto mehr reingezoomt ist der Spieler
var zoom_niveau: float = 5

# heißt, alle Movement sind geblockt aber andere Projektile usw. bewegen sich trotzdem
var immobile: bool = false

# In welchem Level der Spieler sich befindet, 0 ist Hub, 1-N sind die Labyrinthe
var current_level = 0
var highest_completed_level = -1
var level_end = false

# Immunity Frames
var immunity_frames: float

# Immunity Duration
const immunity_duration = 1.2

var global_position: Vector2
#flag for fog deletion when "new game"
var flag_is_new_game = false #kann gelöscht werden?

var flag_dialog_open = false
var flag_action_after_dialog = 0
var ref_last_dialog = 0
var flag_raetsel_open = false

func _ready():
	DialogueManager.dialogue_ended.connect(PlayerVariables.action_after_dialog)

func action_after_dialog(x):
	flag_dialog_open = false
	ref_last_dialog = 0
	match flag_action_after_dialog:
		0:
			pass #normal weiter
		1:
			#rätsel öffnen memory
			Hud.queue_overlay()
			flag_raetsel_open = true
			get_tree().get_first_node_in_group("GoldeneTruhe").startMemory.emit()
		2:
			#rätsel öffnen simon
			Hud.queue_overlay()
			flag_raetsel_open = true
			get_tree().get_first_node_in_group("GoldeneTruhe").startSimonSays.emit()
		3:
			Inventory.update_after_level_completed()
			highest_completed_level += 1
			get_tree().get_first_node_in_group('Player').switch_level("hub") #teleport_level
		4:
			pass
