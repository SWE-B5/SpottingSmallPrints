extends StaticBody2D

#Speichert die ID der Notiz
@export var note_id = 0

enum note_type {LEVEL, HUB}
@export var type : note_type = note_type.LEVEL
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var sprite = $AnimatedSprite2D

@onready var detecion_area = $InteractionArea/DetectionArea

@onready var collected = false

const lines : Array[String]= ["Du hast eine Note gefunden", "Das ist die zweite Line"]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
#Notiz aufsammeln
func _on_interact():
	if !collected:
		if type == note_type.LEVEL:
			var note_String = "Note" + str(note_id)
			var resource = load("res://dialogs/note_dialog.dialogue")
			DialogueManager.show_dialogue_balloon(resource, note_String)
			#Hier muss noch der Dialog abgespielt werden
			collected = true
			# Interaktion mit Truhe deaktivieren
			detecion_area.disabled = true
			# Textur der offenen Truhe laden 
			self.hide()
			Inventory.collect_item(Inventory.Item_Type.NOTE, note_id)
			print(Inventory.inventory)
		elif type == note_type.HUB:
			var note_String = "Note" + str(note_id)
			var resource = load("res://dialogs/note_dialog.dialogue")
			DialogueManager.show_dialogue_balloon(resource, note_String)
		
		
