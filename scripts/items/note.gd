extends StaticBody2D

#Speichert die ID der Notiz
@export var note_id = 0

@onready var interaction_area: InteractionArea = $InteractionArea

@onready var sprite = $AnimatedSprite2D

@onready var detecion_area = $InteractionArea/DetectionArea

@onready var collected = false

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
#Notiz aufsammeln
func _on_interact():
	if !collected:
		#Hier muss noch der Dialog abgespielt werden
		collected = true
		# Interaktion mit Truhe deaktivieren
		detecion_area.disabled = true
		# Textur der offenen Truhe laden 
		self.hide()
		Inventory.collect_item(Inventory.Item_Type.NOTE, note_id)
		print(Inventory.inventory)
		
		
