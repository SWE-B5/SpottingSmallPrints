extends Node2D

@onready var interaction_area: InteractionArea = $Interaction_Area
@onready var sprite = $AnimatedSprite2D


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
#Schluessel Drop
func _on_interact():
	pass
	
