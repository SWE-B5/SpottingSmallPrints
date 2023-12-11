extends CanvasLayer
#Autor Leon Frings

@onready var background = $BackgroundV1 #Hintergrund
@onready var background_blurr = $BlurBackground # Shader für Hintergrund
@onready var outro = $Outro # Oberfläche Outro
@onready var credits = $Credits # Oberfläche Intro

func _ready():
	background.show()
	background_blurr.show()
	outro.show()
	credits.hide()

func _on_credits_pressed():
	outro.hide()
	credits.show()

func _on_hauptmenu_pressed():
	#delete save file?
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")
