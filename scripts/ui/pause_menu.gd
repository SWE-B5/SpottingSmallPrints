extends CanvasLayer

var is_active = false
@onready var resume_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var quit_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready():
	hide()
	resume_button.connect("pressed", toggle)
	quit_button.connect("pressed", quit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle()
	get_tree().paused = is_active # wenns nicht hier ist, spielt er trotzdem weiter

func quit():
	PlayerVariables.save_to_path(Constants.SAVE_PATH)
	get_tree().quit()

func toggle():
	is_active = !is_active
	visible = is_active
