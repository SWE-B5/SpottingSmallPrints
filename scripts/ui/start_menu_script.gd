extends CanvasLayer
#Autor: Til Zölzer
#Autor: Leon Frings

@onready var background = $BackgroundV1 #Hintergrund
@onready var title = $Title #Titel
@onready var background_blurr = $BlurBackground #Shader für Hintergrund
@onready var start_menu = $StartMenu # Start Menu mit Laden, Neues Spiel, Quit
@onready var confirmation_screen = $ConfirmationScreen # Confirmation Screen, bei Spiel Verlassen
@onready var difficulty_selector = $DifficultySelector # 3 Schwierigkeiten wählen
@onready var load_game_error = $LoadGameError # Fehler Nachricht, maybe popup möglich?
@onready var death_screen = $DeathScreen #DeathScreen nach Tod
@onready var intro_part_1 = $IntroPart1 #Intro nach Schwierigkeitsgrad
@onready var intro_part_2 = $IntroPart2	#Intro Part 2 nach Intro Part 1
#2 Intro Parts, weil sonst Schrift zu unleserlich
#shader über Hintergrund bei Intro, weil sonst Schrift zu Unleserlich (besonders bei der Treppe unten links)

func _ready():
	background.show()
	background_blurr.hide()
	title.show()
	if Health.is_death:
		Health.is_death = false
		start_menu.hide()
		death_screen.show()
	else:
		start_menu.show()
		death_screen.hide()
	confirmation_screen.hide()
	difficulty_selector.hide()
	load_game_error.hide()
	intro_part_1.hide()
	intro_part_2.hide()

func go_to_level():
	get_tree().change_scene_to_file(Constants.LEVEL_PATHS[PlayerVariables.current_level])

func _on_new_game_button_pressed():
	start_menu.hide()
	difficulty_selector.show()
	difficulty_selector.get_child(2).hide() #neu
	difficulty_selector.get_child(3).hide() #neu
	difficulty_selector.get_child(4).hide() #neu

func _on_load_game_button_pressed():
	if not PlayerVariables.load_save_file():
		start_menu.hide()
		load_game_error.show()
		return
	go_to_level()

func _on_load_game_error_back_button_pressed():
	load_game_error.hide()
	start_menu.show()

func _on_difficulty_back_to_menu_button_pressed():
	difficulty_selector.hide()
	start_menu.show()

func _on_quit_button_pressed():
	start_menu.hide()
	confirmation_screen.show()

func _on_easy_difficulty_button_pressed():
	PlayerVariables.initialize_new_game(PlayerVariables.Difficulty.EASY)
	title.hide()
	difficulty_selector.hide()
	background_blurr.show()
	intro_part_1.show()
	

func _on_normal_difficulty_button_pressed():
	PlayerVariables.initialize_new_game(PlayerVariables.Difficulty.MEDIUM)
	title.hide()
	difficulty_selector.hide()
	background_blurr.show()
	intro_part_1.show()

func _on_hard_difficulty_button_pressed():
	PlayerVariables.initialize_new_game(PlayerVariables.Difficulty.HARD)
	title.hide()
	difficulty_selector.hide()
	background_blurr.show()
	intro_part_1.show()

func _on_besiegeln_pressed():
	intro_part_1.hide()
	intro_part_2.show()

func _on_prufung_starten_pressed():
	go_to_level()

func _on_respawn_pressed():
	if not PlayerVariables.load_save_file():
		death_screen.hide()
		load_game_error.show()
		return
	Health.is_death = true # damit fog save geladen wird
	go_to_level()


func _on_hauptmenu_pressed():
	death_screen.hide()
	start_menu.show()

func _on_confirm_quit_pressed():
	get_tree().quit()

func _on_confirm_abbruch_pressed():
	confirmation_screen.hide()
	start_menu.show()



func _on_easy_difficulty_button_mouse_entered(): #neu
	difficulty_selector.get_child(2).show()


func _on_easy_difficulty_button_mouse_exited(): #neu
	difficulty_selector.get_child(2).hide()


func _on_normal_difficulty_button_mouse_entered():
	difficulty_selector.get_child(3).show()


func _on_normal_difficulty_button_mouse_exited():
	difficulty_selector.get_child(3).hide()


func _on_hard_difficulty_button_mouse_entered():
	difficulty_selector.get_child(4).show()


func _on_hard_difficulty_button_mouse_exited():
	difficulty_selector.get_child(4).hide()
