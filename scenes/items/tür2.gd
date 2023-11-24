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
	if is_closed && PlayerVariables.collected_keys.find(id) != -1:
		#Sucht nach dem passenden Schlüssel
		is_closed = false
		self.visible = false
		collisionshape.queue_free()
		detecion_area.disabled = true
