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
	highest_completed_level = flag_override_start_level - 1
	if PlayerVariables.flag_override_start_level == 5:
		current_level = 0
	else:
		current_level = PlayerVariables.flag_override_start_level
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
	if flag_more_speed:
		speed *= 3

var speed: int
var active_camera: CameraTypes = CameraTypes.FOLLOW
var difficulty: Difficulty
var lightsout_is_finnished: bool = false
# Je höher das Zoom Niveau ist desto mehr reingezoomt ist der Spieler
var zoom_niveau: float = 5

# heißt, alle Movement sind geblockt aber andere Projektile usw. bewegen sich trotzdem
var immobile: bool = false

# In welchem Level der Spieler sich befindet, 0 ist Hub, 1-N sind die Labyrinthe
var current_level: int = 0
var highest_completed_level: int = -1
var level_end: bool = false

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
	load_cheats()

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
			PlayerVariables.immobile = false
			highest_completed_level += 1
			if current_level != 0:
				get_tree().get_first_node_in_group('Player').switch_level("hub") #teleport_level
			else:
				get_tree().current_scene._ready()
		4:
			pass

#internes flag
var flag_go_to_credits: bool = false

#cheat "settings"
var flag_unsterblich: bool= false
var flag_open_all_silver_doors: bool = false
var flag_override_start_level: int = 0
var flag_skip_dialogue: bool = false
var flag_hide_fog: bool = false
var flag_open_all_gold_chests: bool = false
var flag_skip_raetsel: bool = false
var flag_skip_lightsout: bool = false
var flag_key_helper: bool = true
var flag_more_speed: bool = false

func save_cheats():
	var safe_file = JSON.stringify({
		"unsterblich": flag_unsterblich,
		"open_all_silver_doors": flag_open_all_silver_doors,
		"override_start_level": flag_override_start_level,
		"skip_dialogue": flag_skip_dialogue,
		"hide_fog": flag_hide_fog,
		"open_all_gold_chests": flag_open_all_gold_chests,
		"skip_raetsel": flag_skip_raetsel,
		"skip_lightsout": flag_skip_lightsout,
		"key_helper": flag_key_helper,
		"more_speed": flag_more_speed
	})
	var file = FileAccess.open(Constants.CHEATS_SAVE_PATH, FileAccess.WRITE)
	file.store_line(safe_file)

func load_cheats():
	if not FileAccess.file_exists(Constants.CHEATS_SAVE_PATH):
		return false
	var file = FileAccess.open(Constants.CHEATS_SAVE_PATH, FileAccess.READ)
	var obj = JSON.parse_string(file.get_as_text())
	flag_unsterblich = obj.unsterblich
	flag_open_all_silver_doors = obj.open_all_silver_doors
	flag_override_start_level = obj.override_start_level
	flag_skip_dialogue = obj.skip_dialogue
	flag_hide_fog = obj.hide_fog
	flag_open_all_gold_chests = obj.open_all_gold_chests
	flag_skip_raetsel = obj.skip_raetsel
	flag_skip_lightsout = obj.skip_lightsout
	flag_key_helper = obj.key_helper
	flag_more_speed = obj.more_speed
	return true
	
func reset_cheats():
	var dir = DirAccess.open(Constants.SAVE_DIRECTORY)
	dir.remove(Constants.CHEATS_SAFE_FILE_NAME)
	flag_unsterblich = false
	flag_open_all_silver_doors = false
	flag_override_start_level = 0
	flag_skip_dialogue = false
	flag_hide_fog = false
	flag_open_all_gold_chests = false
	flag_skip_raetsel = false
	flag_skip_lightsout = false
	flag_key_helper = true
	flag_more_speed = false
