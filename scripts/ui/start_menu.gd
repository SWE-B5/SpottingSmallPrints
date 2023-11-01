extends CanvasLayer

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

func _on_new_game_button_pressed():
	start_menu.hide()
	difficulty_selector.show()

func _on_load_game_button_pressed():
	pass # Replace with function body.


func _on_credits_button_pressed():
	credits.show()
	start_menu.hide()
	difficulty_selector.hide()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_easy_difficulty_button_pressed():
	print("make easy game")


func _on_normal_difficulty_button_pressed():
	print("make normal game")


func _on_hard_difficulty_button_pressed():
	print("make hard game")
