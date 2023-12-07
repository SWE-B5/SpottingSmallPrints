extends Area2D
class_name InteractionArea

@export var action_name : String = "Tür öffnen"

var interact : Callable = func ():
	pass


func _on_body_entered(body):
	print("Body entered:")
	print(body)
	InteractionManager.register_area(self)
	


func _on_body_exited(body):
	InteractionManager.unregister_area(self)
