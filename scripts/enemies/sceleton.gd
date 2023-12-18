extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var hitbox : Area2D = $Path2D/PathFollow2D/CharacterBody2D/hitbox
@onready var collision_shape : CollisionShape2D = $Path2D/PathFollow2D/CharacterBody2D/CollisionShape2D
@onready var timer : Timer = $timer
@export var speed = 100


func _process(delta):
	path_follow.progress += speed * delta


func _on_hitbox_area_entered(area):
	if area.is_in_group("hitbox_player") && PlayerVariables.immunity_frames <= 0:
		PlayerVariables.immunity_frames = PlayerVariables.immunity_duration
		get_tree().get_first_node_in_group('Player').damage_animation()
		await get_tree().create_timer(0.2).timeout
		hitbox.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", true)
		timer.start()
		Health.damage_player(1)
		print("Damage dealt to player:")

func _on_hitbox_timer_timeout():
	hitbox.set_deferred("disabled", false)
	collision_shape.set_deferred("disabled", false)

