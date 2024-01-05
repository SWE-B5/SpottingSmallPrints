
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
	if !PlayerVariables.flag_dialog_open && is_closed:
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
		
		#Hier muss noch der Dialog abgespielt werden
		is_closed = false
		# Interaktion mit Truhe deaktivieren
		detecion_area.disabled = true
		# Textur der offenen Truhe laden 
		sprite.animation =  "open"
		PlayerVariables.immobile = true
		awaitingSignal = true
		PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource, "Goldene_Kiste_Teil1" )

func _puzzle_canceled():
	if awaitingSignal:
		awaitingSignal = false
		
		#TODO: Dialog hinzufügen
		
		is_closed = true
		detecion_area.disabled = false
		# Textur der offenen Truhe laden 
		sprite.animation =  "closed"
		PlayerVariables.immobile = false
		Hud.dequeue_overlay()
		PlayerVariables.flag_raetsel_open = false

#Schluessel Drop
func _puzzle_successful():
	if awaitingSignal:
		
		#TODO: Dialog hinzufügen und zum Hub teleportieren
		if PlayerVariables.flag_open_all_gold_chests:
			var temp = [0,0,0]
			var id = PlayerVariables.current_level * Inventory.NOTES_PER_LEVEL + 1
			for i in 3:
				temp[i] = id
				id += 1
			Inventory.inventory[Inventory.Item_Type.NOTE] = temp
			Inventory.active_items_count[Inventory.Item_Type.NOTE] = 3
		Inventory.collect_item(Inventory.Item_Type.GOLD, schlüssel_id)
		var resource = load("res://dialogs/note_dialog.dialogue")
		Inventory.dialogue_temp_gold_id = schlüssel_id
		Hud.dequeue_overlay()
		PlayerVariables.flag_raetsel_open = false
		PlayerVariables.flag_dialog_open = true
		PlayerVariables.flag_action_after_dialog = 3
		
		awaitingSignal = false
		PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource, "Goldene_Kiste_Teil2" )
		
