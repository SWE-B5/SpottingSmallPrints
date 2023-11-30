extends Node2D

var can_control = true

func _on_control_gui_input(event):
	if event is InputEventMouseButton and can_control:
		if event.is_action_pressed("click"):
			$AnimationPlayer.play("turn_over")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "turn_over":
		get_parent().get_parent().get_parent().get_parent().card_selected(self)
