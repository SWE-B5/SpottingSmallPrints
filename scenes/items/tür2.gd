extends StaticBody2D
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
	if is_closed:
		is_closed = false
		self.visible = false
		collisionshape.queue_free()
		detecion_area.disabled = true
