
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

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	sprite.animation =  "closed"
#Schluessel Drop
func _on_interact():
	if is_closed:
		#Hier muss noch der Dialog abgespielt werden
		is_closed = false
		# Interaktion mit Truhe deaktivieren
		detecion_area.disabled = true
		# Textur der offenen Truhe laden 
		sprite.animation =  "open"
		if type == rätsel_typ.SIMONSAYS:
			# Hier Simon Says Rätsel starten
			# Schluessel wird nach erfolgreichem Raetsel eingesammelt
			Inventory.collect_item(Inventory.Item_Type.GOLD, schlüssel_id)
		if type == rätsel_typ.MEMORY:
			# Hier Memory Rätsel starten
			# Schluessel wird nach erfolgreichem Raetsel eingesammelt
			Inventory.collect_item(Inventory.Item_Type.GOLD, schlüssel_id)
		print(Inventory)
		
		