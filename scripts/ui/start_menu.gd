extends CanvasLayer

@onready var start_menu = $StartMenu # Start Menu mit Laden, Neues Spiel, Credits, Quit
@onready var difficulty_selector = $DifficultySelector # 3 Schwierigkeiten wählen
@onready var credits = $CreditsMenu # Credit Menu
@onready var load_game_error = $LoadGameError # Fehler Nachricht, maybe popup möglich?

func _ready():
	start_menu.show()
	difficulty_selector.hide()
	credits.hide()
	load_game_error.hide()

func spawn_to_hub():
	get_tree().change_scene_to_file("res://scenes/level/hub.tscn")

func _on_new_game_button_pressed():
	start_menu.hide()
	difficulty_selector.show()

func _on_load_game_button_pressed():
	if not PlayerVariables.load_from_path(Constants.SAVE_PATH):
		load_game_error.show()
		start_menu.hide()
		return
	spawn_to_hub()

func _on_credits_button_pressed():
	credits.show()
	start_menu.hide()

func _on_load_game_error_back_button_pressed():
	start_menu.show()
	load_game_error.hide()
	
func _on_credits_back_to_menu_button_pressed():
	credits.hide()
	start_menu.show()

func _on_difficulty_back_to_menu_button_pressed():
	difficulty_selector.hide()
	start_menu.show()

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





