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
@onready var extras_menu = $Extras_menu
#2 Intro Parts, weil sonst Schrift zu unleserlich
#shader über Hintergrund bei Intro, weil sonst Schrift zu Unleserlich (besonders bei der Treppe unten links)
@onready var unsterblich = $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/unsterblich
@onready var open_all_silver_doors =  $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/open_all_silver_doors
@onready var override_start_level = $Extras_menu/CenterContainer2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/start_level
@onready var skip_dialogue =  $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/keine_dialoge
@onready var hide_fog =  $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/hide_fog
@onready var open_all_gold_chests =  $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/alle_gold_truhen_oeffnen
@onready var skip_raetsel =  $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/skip_raetsel
@onready var skip_lightsout =  $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/skip_lightsout
@onready var key_helper =  $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/silver_key_helper
@onready var more_speed =  $Extras_menu/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/more_speed

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
	extras_menu.hide()

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
	if (PlayerVariables.flag_override_start_level != 0):
		if FileAccess.file_exists("user://fog_level.save"):
			var dir = DirAccess.open("user://")
			dir.remove("user://fog_level.save")
		go_to_level()
	else:
		title.hide()
		difficulty_selector.hide()
		background_blurr.show()
		intro_part_1.show()

func _on_normal_difficulty_button_pressed():
	PlayerVariables.initialize_new_game(PlayerVariables.Difficulty.MEDIUM)
	if (PlayerVariables.flag_override_start_level != 0):
		if FileAccess.file_exists("user://fog_level.save"):
			var dir = DirAccess.open("user://")
			dir.remove("user://fog_level.save")
		go_to_level()
	else:
		title.hide()
		difficulty_selector.hide()
		background_blurr.show()
		intro_part_1.show()

func _on_hard_difficulty_button_pressed():
	PlayerVariables.initialize_new_game(PlayerVariables.Difficulty.HARD)
	if (PlayerVariables.flag_override_start_level != 0):
		if FileAccess.file_exists("user://fog_level.save"):
			var dir = DirAccess.open("user://")
			dir.remove("user://fog_level.save")
		go_to_level()
	else:
		title.hide()
		difficulty_selector.hide()
		background_blurr.show()
		intro_part_1.show()

func _on_besiegeln_pressed():
	intro_part_1.hide()
	intro_part_2.show()

func _on_prufung_starten_pressed():
	if FileAccess.file_exists("user://fog_level.save"):
		var dir = DirAccess.open("user://")
		dir.remove("user://fog_level.save")
	go_to_level()

func _on_respawn_pressed():
	if not PlayerVariables.load_save_file():
		death_screen.hide()
		load_game_error.show()
		return
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

func _on_fullscreen_pressed():
	if(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		print(start_menu)
		start_menu.find_child("Fullscreen").text = "Windowed"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		start_menu.find_child("Fullscreen").text = "Fullscreen"


func _on_extras_pressed():
	update_cheat_buttons()
	start_menu.hide()
	title.hide()
	extras_menu.show()


func _on_go_to_credits_pressed():
	PlayerVariables.save_cheats()
	PlayerVariables.flag_go_to_credits = true
	get_tree().change_scene_to_file("res://scenes/ui/OutroCredits.tscn")


func _on_go_to_main_pressed():
	PlayerVariables.save_cheats()
	extras_menu.hide()
	title.show()
	start_menu.show()


func _on_unsterblich_toggled(button_pressed):
	PlayerVariables.flag_unsterblich = button_pressed


func _on_hide_fog_toggled(button_pressed):
	PlayerVariables.flag_hide_fog = button_pressed


func _on_skip_raetsel_toggled(button_pressed):
	PlayerVariables.flag_skip_raetsel = button_pressed


func _on_keine_dialoge_toggled(button_pressed):
	PlayerVariables.flag_skip_dialogue = button_pressed


func _on_alle_gold_truhen_oeffnen_toggled(button_pressed):
	PlayerVariables.flag_open_all_gold_chests = button_pressed


func _on_start_level_item_selected(index):
	PlayerVariables.flag_override_start_level = index


func _on_skip_lightsout_toggled(button_pressed):
	PlayerVariables.flag_skip_lightsout = button_pressed


func _on_open_all_silver_doors_toggled(button_pressed):
	PlayerVariables.flag_open_all_silver_doors = button_pressed


func _on_silver_key_helper_toggled(button_pressed):
	PlayerVariables.flag_key_helper = button_pressed


func _on_more_speed_toggled(button_pressed):
	PlayerVariables.flag_more_speed = button_pressed


func _on_reset_pressed():
	PlayerVariables.reset_cheats()
	update_cheat_buttons()

func update_cheat_buttons():
	unsterblich.set_pressed_no_signal(PlayerVariables.flag_unsterblich)
	open_all_silver_doors.set_pressed_no_signal(PlayerVariables.flag_open_all_silver_doors)
	override_start_level.select(PlayerVariables.flag_override_start_level)
	skip_dialogue.set_pressed_no_signal(PlayerVariables.flag_skip_dialogue)
	hide_fog.set_pressed_no_signal(PlayerVariables.flag_hide_fog)
	open_all_gold_chests.set_pressed_no_signal(PlayerVariables.flag_open_all_gold_chests)
	skip_raetsel.set_pressed_no_signal(PlayerVariables.flag_skip_raetsel)
	skip_lightsout.set_pressed_no_signal(PlayerVariables.flag_skip_lightsout)
	key_helper.set_pressed_no_signal(PlayerVariables.flag_key_helper)
	more_speed.set_pressed_no_signal(PlayerVariables.flag_more_speed)
