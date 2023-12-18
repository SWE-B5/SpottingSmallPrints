extends CanvasLayer

var is_active = false
@onready var resume_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var mainmenu_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton

func _ready():
	hide()
	resume_button.connect("pressed", toggle)
	mainmenu_button.connect("pressed", back_to_mainmenu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle()
	get_tree().paused = is_active # wenns nicht hier ist, spielt er trotzdem weiter

func back_to_mainmenu():
	PlayerVariables.save_game() #notwendig
	var Fog = get_tree().current_scene.get_node("Fog")
	if(Fog):
		Fog.save_fog()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/start_menu.tscn")

func toggle():
	if is_active:
		Hud.dequeue_overlay()
	else:
		Hud.queue_overlay()
	is_active = !is_active
	visible = is_active
