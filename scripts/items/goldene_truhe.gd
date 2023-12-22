
extends StaticBody2D

enum rätsel_typ {SIMONSAYS, MEMORY}

@export var type : rätsel_typ
#Speichert die ID des Schluessel der gedropped wird
@export var schlüssel_id = 0

@onready var interaction_area: InteractionArea = $InteractionArea

@onready var sprite = $AnimatedSprite2D

@onready var collisionshape = $CollisionShape2D

@onready var detecion_area = $InteractionArea/DetectionArea

@onready var is_closed = true

@onready var awaitingSignal = false

@onready var notesInLevel = []

signal startSimonSays
signal startMemory

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.animation =  "closed"
	var levelSzene = get_parent()
	var noteSzene = preload("res://scenes/items/note.tscn")
	for child in levelSzene.get_children():
		if "Note" in child.name:
			notesInLevel.append(child)

func can_be_opened():
	var res = true
	for note in notesInLevel:
		if !note.collected:
			res = false
	return res 

func _on_interact():

	if !PlayerVariables.flag_dialog_open:
		var resource = load("res://dialogs/note_dialog.dialogue")
		if not Inventory.check_all_notes_current_level():
			PlayerVariables.flag_dialog_open = true
			PlayerVariables.flag_action_after_dialog = 0
			PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource, "Goldene_Kiste_negative" )
			return
		PlayerVariables.flag_dialog_open = true
		if type == rätsel_typ.MEMORY:
			PlayerVariables.flag_action_after_dialog = 1
		else:
			PlayerVariables.flag_action_after_dialog = 2
		PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource, "Goldene_Kiste_Teil1" )
		#Hier muss noch der Dialog abgespielt werden
		is_closed = false
		# Interaktion mit Truhe deaktivieren
		detecion_area.disabled = true
		# Textur der offenen Truhe laden 
		sprite.animation =  "open"
		PlayerVariables.immobile = true
		awaitingSignal = true
		

func _puzzle_canceled():
	if awaitingSignal:
		awaitingSignal = false
		print("Puzzle Cancelled")
		
		#TODO: Dialog hinzufügen
		
		is_closed = true
		detecion_area.disabled = false
		# Textur der offenen Truhe laden 
		sprite.animation =  "closed"
		PlayerVariables.immobile = false
		Hud.dequeue_overlay()

#Schluessel Drop
func _puzzle_successful():
	if awaitingSignal:
		print("Puzzle successful: adding item To Inventory")
		
		#TODO: Dialog hinzufügen und zum Hub teleportieren
		
		Inventory.collect_item(Inventory.Item_Type.GOLD, schlüssel_id)
		var resource = load("res://dialogs/note_dialog.dialogue")
		Inventory.dialogue_temp_gold_id = schlüssel_id
		Hud.dequeue_overlay()
		PlayerVariables.flag_dialog_open = true
		PlayerVariables.flag_action_after_dialog = 3
		PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource, "Goldene_Kiste_Teil2" )
		print(Inventory)
		PlayerVariables.immobile = false
		awaitingSignal = false
		
		
