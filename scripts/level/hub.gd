extends Node2D

@onready var player = $Player
@onready var note1 = get_node("note")


func _ready():
	PlayerVariables.load_easy_game()
	
