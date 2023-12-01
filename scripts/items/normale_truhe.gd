
extends StaticBody2D

enum truhen_typ {SCHLÜSSEL, TRANK}

@export var type : truhen_typ
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
		if type == truhen_typ.SCHLÜSSEL:
			# Silbernen schluessel zu den gesammelten schluesseln hinzufuegen
			PlayerVariables.collected_silver_keys.push_back(schlüssel_id)
			print(PlayerVariables.collected_silver_keys)
		if type == truhen_typ.TRANK:
			# Fuellt den Trank des Spielers auf
			PlayerVariables.shield = true
		
		
