extends CanvasLayer

var is_active = false
@onready var resume_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var mainmenu_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton
@onready var silver_key = $Silver_key_panel
@onready var gold_key = $Gold_key_panel
@onready var diamond_key = $Diamond_key_panel
@onready var key_ids = $key_ids

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

var temp
func toggle():
	if is_active:
		if PlayerVariables.flag_dialog_open:
			PlayerVariables.ref_last_dialog.layer = temp
		Hud.dequeue_overlay()
	else:
		gold_key.hide()
		silver_key.hide()
		diamond_key.hide()
		key_ids.hide()
		if PlayerVariables.flag_key_helper:
			update_key_helper()
		if PlayerVariables.flag_dialog_open:
			temp = PlayerVariables.ref_last_dialog.layer
			PlayerVariables.ref_last_dialog.layer = -10
		Hud.queue_overlay()
	is_active = !is_active
	visible = is_active

func update_key_helper():
	key_ids.text = "-/-"
	if (PlayerVariables.current_level > 0 && PlayerVariables.current_level < 4):
		silver_key.show()
		if Inventory.active_items_count[Inventory.SILVER] > 0:
			var temp = str(Inventory.inventory[Inventory.SILVER][0])
			for i in range (1, Inventory.active_items_count[Inventory.SILVER]) :
				temp += "," + str(Inventory.inventory[Inventory.SILVER][i])
			key_ids.text = temp
	elif (PlayerVariables.current_level == 0):
		if (Inventory.active_items_count[Inventory.DIAMOND] == 1):
			diamond_key.show()
			key_ids.text = "*"
			key_ids.show()
		else:
			gold_key.show()
			if (Inventory.active_items_count[Inventory.GOLD] == 1):
				var max = 0
				for i in Inventory.inventory[Inventory.GOLD].size():
					if Inventory.inventory[Inventory.GOLD][i] > max:
						max = Inventory.inventory[Inventory.GOLD][i]
				key_ids.text = str(max)
	key_ids.show()
	
