
extends StaticBody2D

#Speichert die ID des Schluessel der gedropped wird
var schlüssel_id = 0

@onready var interaction_area: InteractionArea = $InteractionArea

@onready var sprite = $AnimatedSprite2D

@onready var collisionshape = $CollisionShape2D

@onready var detecion_area = $InteractionArea/DetectionArea

@onready var is_closed = true




func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.animation =  "closed"

func _on_interact():
	var resource = load("res://dialogs/note_dialog.dialogue")
	if !PlayerVariables.flag_dialog_open && is_closed:
		if PlayerVariables.lightsout_is_finnished:
			Inventory.collect_item(Inventory.Item_Type.DIAMOND, schlüssel_id)
			#Hier muss noch der Dialog abgespielt werden
			is_closed = false
			# Interaktion mit Truhe deaktivieren
			detecion_area.disabled = true
			# Textur der offenen Truhe laden 
			sprite.animation =  "open"
			PlayerVariables.flag_dialog_open = true
			PlayerVariables.flag_action_after_dialog = 3
			PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource,"Diamantene_Kiste")
		else:
			PlayerVariables.flag_dialog_open = true
			PlayerVariables.flag_action_after_dialog = 0
			PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource,"Diamantene_Kiste_negative")
		
		
		
