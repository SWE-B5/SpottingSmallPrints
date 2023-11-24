
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
		#Sucht nach dem passenden Schlüssel
		is_closed = false
		detecion_area.disabled = true
		sprite.animation =  "open"
