extends Node2D

@onready var player = $Player
@onready var anzahl_Notes = 0
@onready var node_scene = load("res://scenes/items/note.tscn")

@onready var hub_Note_1 = self.get_child(7)
@onready var hub_Note_2 = self.get_child(8)
@onready var hub_Note_3 = self.get_child(9)
@onready var gold_truhe = $GoldeneTruhe

@onready var scene
func _ready():
	PlayerVariables.level_end = false
	PlayerVariables.current_level = 0
	PlayerVariables.save_game()
	PlayerVariables.flag_action_after_dialog = 0
	PlayerVariables.ref_last_dialog = 0
	PlayerVariables.flag_raetsel_open = false
	PlayerVariables.flag_dialog_open = false
	PlayerVariables.immobile = false
	anzahl_Notes = Inventory.number_of_notes_found()
	if PlayerVariables.highest_completed_level >= 0:
		gold_truhe.is_closed = false
		gold_truhe.detecion_area.disabled = true
		gold_truhe.sprite.animation =  "open"
	
	Inventory.update_after_death() #muss drin bleiben!
	for i in anzahl_Notes :
		var id = Inventory.get_xth_found_note_id(i)
		scene = node_scene.instantiate()
		scene.type = scene.note_type.HUB
		scene.note_id = id
		add_child(scene)
		scene.set_position(Vector2(1000,1000)) #weit weg
		
		if id == 1:
			hub_Note_1.type = hub_Note_1.note_type.HUB
			hub_Note_1.set_position(Vector2(320, -48))
			hub_Note_1.detecion_area.disabled = false
			hub_Note_1.show();
			hub_Note_1.collected = false
		
		elif id == 2:
			hub_Note_2.type = hub_Note_2.note_type.HUB
			hub_Note_2.set_position(Vector2(384, -48))
			hub_Note_2.detecion_area.disabled = false
			hub_Note_2.show();
			hub_Note_2.collected = false
			
		elif id == 3:
			hub_Note_3.type = hub_Note_3.note_type.HUB
			hub_Note_3.set_position(Vector2(448, -48))
			hub_Note_3.detecion_area.disabled = false
			hub_Note_3.show();
			hub_Note_3.collected = false
			
		elif id > 3 && id <= 6:
			scene.set_position(Vector2(560 + ((id-4) * 64), -48))
			scene.show()
			
		elif id > 6 && id <= 9:
			scene.set_position(Vector2(320 + ((id-7) * 64), 32))
			scene.show()
			
		elif id > 9:
			scene.set_position(Vector2(560 + ((id-10) * 64), 32))
			scene.show()

func _process(delta):
	anzahl_Notes = Inventory.number_of_notes_found()
	for i in anzahl_Notes:
		var id = Inventory.get_xth_found_note_id(i)
		
		if id == 1:
			hub_Note_1.type = hub_Note_1.note_type.HUB
			hub_Note_1.set_position(Vector2(320, -48))
			hub_Note_1.detecion_area.disabled = false
			hub_Note_1.show();
			hub_Note_1.collected = false
		
		elif id == 2:
			hub_Note_2.type = hub_Note_2.note_type.HUB
			hub_Note_2.set_position(Vector2(384, -48))
			hub_Note_2.detecion_area.disabled = false
			hub_Note_2.show();
			hub_Note_2.collected = false
			
		elif id == 3:
			hub_Note_3.type = hub_Note_3.note_type.HUB
			hub_Note_3.set_position(Vector2(448, -48))
			hub_Note_3.detecion_area.disabled = false
			hub_Note_3.show();
			hub_Note_3.collected = false

