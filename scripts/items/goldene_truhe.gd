
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

signal startSimonSays
signal startMemory

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.animation =  "closed"

func _on_interact():
		var resource = load("res://dialogs/note_dialog.dialogue")
		if not Inventory.check_all_notes_current_level():
			DialogueManager.show_dialogue_balloon(resource, "Goldene_Kiste_negative" )
			return
		DialogueManager.show_dialogue_balloon(resource, "Goldene_Kiste_Teil1" )
		#Hier muss noch der Dialog abgespielt werden
		is_closed = false
		# Interaktion mit Truhe deaktivieren
		detecion_area.disabled = true
		# Textur der offenen Truhe laden 
		sprite.animation =  "open"
		PlayerVariables.immobile = true
		if type == rätsel_typ.SIMONSAYS:
			startSimonSays.emit()
		if type == rätsel_typ.MEMORY:
			startMemory.emit()
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

#Schluessel Drop
func _puzzle_successful():
	if awaitingSignal:
		print("Puzzle successful: adding item To Inventory")
		
		#TODO: Dialog hinzufügen und zum Hub teleportieren
		
		Inventory.collect_item(Inventory.Item_Type.GOLD, schlüssel_id)
		Inventory.update_after_level_completed()
		var resource = load("res://dialogs/note_dialog.dialogue")
		Inventory.dialogue_temp_gold_id = schlüssel_id
		DialogueManager.show_dialogue_balloon(resource, "Goldene_Kiste_Teil2" )
		print(Inventory)
		PlayerVariables.immobile = false
		awaitingSignal = false
		
		
