extends StaticBody2D
#Schlüssel ID. Wird mit den IDs die im collected_keys array gespeichert sind verglichen.
#Wenn der Schlüssel im Array ist, öffnet sich die Tür
@export var id = 0

@onready var interaction_area: InteractionArea = $InteractionArea

@onready var sprite = $AnimatedSprite2D

@onready var collisionshape = $CollisionShape2D

@onready var detecion_area = $InteractionArea/DetectionArea

@onready var is_closed = true

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
#Schluessel Drop
func _on_interact():
	
	# Überprüft ob man den passenden Schlüssel hat
	if !PlayerVariables.flag_dialog_open && is_closed:
		var resource = load("res://dialogs/note_dialog.dialogue")
		Inventory.dialogue_temp_silver_id = id
		if Inventory.check_key(Inventory.Item_Type.SILVER, id):
			# Schlüssel wird benutzt
			Inventory.use_key(Inventory.Item_Type.SILVER)
			# Tür deaktivieren
			is_closed = false
			self.visible = false
			collisionshape.queue_free()
			detecion_area.disabled = true
			PlayerVariables.flag_dialog_open = true
			PlayerVariables.flag_action_after_dialog = 0
			PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource, "Silberne_Tür" )
		else:
			PlayerVariables.flag_dialog_open = true
			PlayerVariables.flag_action_after_dialog = 0
			PlayerVariables.ref_last_dialog = DialogueManager.show_dialogue_balloon(resource, "Silberne_Tür_negative" )
