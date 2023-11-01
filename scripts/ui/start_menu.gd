extends CanvasLayer

var hub_scene = preload("res://scenes/level/hub.tscn").instantiate()

@onready var start_menu = $StartMenu
@onready var difficulty_selector = $DifficultySelector
@onready var credits = $CreditsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	start_menu.show()
	difficulty_selector.hide()
	credits.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_to_hub():
	get_tree().change_scene_to_file("res://scenes/level/hub.tscn")

func _on_new_game_button_pressed():
	start_menu.hide()
	difficulty_selector.show()

func _on_load_game_button_pressed():
	PlayerVariables.load_from_path(Constants.SAVE_PATH)
	spawn_to_hub()

func _on_credits_button_pressed():
	credits.show()
	start_menu.hide()
	difficulty_selector.hide()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_easy_difficulty_button_pressed():
	PlayerVariables.generate_easy_game()
	spawn_to_hub()

func _on_normal_difficulty_button_pressed():
	PlayerVariables.generate_medium_game()
	spawn_to_hub()

func _on_hard_difficulty_button_pressed():
	PlayerVariables.generate_hard_game()
	spawn_to_hub()
