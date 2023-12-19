extends Node2D
@onready var path = $path
@onready var sprite = $path/pathfollow/characterbody/sprite
@onready var path_follow : PathFollow2D = $path/pathfollow
@onready var hitbox = $path/pathfollow/characterbody/hitbox
@onready var collision_shape  = $path/pathfollow/characterbody/collisionshape
@onready var timer = $hitbox_timer
@export var speed = 100
@export var export_path : Path2D

func _ready():
	sprite.play()
	path.curve = export_path.curve
	match PlayerVariables.difficulty:
		PlayerVariables.Difficulty.EASY:
			speed = Constants.SPEED_SKULL_EASY
		PlayerVariables.Difficulty.MEDIUM:
			speed = Constants.SPEED_SKULL_MEDIUM
		PlayerVariables.Difficulty.HARD:
			speed = Constants.SPEED_SKULL_HARD
	
	
func _process(delta):
	path_follow.progress += speed * delta
	
	
#func _on_hitbox_timer_timeout():
	#hitbox.set_deferred("disabled", false)
	#collision_shape.set_deferred("disabled", false)
	
#func _on_hitbox_area_entered(area):
	#print("Damage dealt to player:")
	#if area.is_in_group("hitbox_player") && PlayerVariables.immunity_frames <= 0:
		#PlayerVariables.immunity_frames = PlayerVariables.immunity_duration
		#get_tree().get_first_node_in_group('Player').damage_animation()
		#await get_tree().create_timer(0.1).timeout
		#hitbox.set_deferred("disabled", true)
		#collision_shape.set_deferred("disabled", true)
		#timer.start()
		#Health.damage_player(1)


func _on_hitbox_area_entered(area):
	print("Damage dealt to player:")
	if area.is_in_group("hitbox_player") && PlayerVariables.immunity_frames <= 0:
		PlayerVariables.immunity_frames = PlayerVariables.immunity_duration
		get_tree().get_first_node_in_group('Player').damage_animation()
		await get_tree().create_timer(0.1).timeout
		hitbox.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", true)
		timer.start()
		Health.damage_player(1)


func _on_hitbox_timer_timeout():
	hitbox.set_deferred("disabled", false)
	collision_shape.set_deferred("disabled", false)
