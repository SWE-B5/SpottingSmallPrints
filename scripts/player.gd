extends CharacterBody2D
class_name Player

enum Direction { UP, DOWN, LEFT, RIGHT }
enum MovementState { WALK, IDLE }

@onready var anim = $AnimatedSprite2D
@onready var follow_camera = $FollowCamera
var direction: Direction = Direction.DOWN

var is_zooming_in: bool = false
var is_zooming_out: bool = true
signal is_zooming_in_finished
signal is_zooming_out_finished

func _ready():
	$FollowCamera.make_current()
	zoom_out()

func _process(delta):
	PlayerVariables.global_position = self.global_position
	
	handle_zoom()
	handle_movement_input()
	if PlayerVariables.immunity_frames > 0:
		PlayerVariables.immunity_frames -= delta

func handle_movement_input():
	if PlayerVariables.immobile:
		velocity = Vector2.ZERO
		play_animation(MovementState.IDLE)
		move_and_slide()
		return
	
	if Input.is_action_pressed("up"):
		velocity = Vector2(0, -PlayerVariables.speed)
		play_animation(MovementState.WALK)
		direction = Direction.UP
	elif Input.is_action_pressed("down"):
		velocity = Vector2(0, PlayerVariables.speed)
		play_animation(MovementState.WALK)
		direction = Direction.DOWN
	elif Input.is_action_pressed("left"):
		velocity = Vector2(-PlayerVariables.speed, 0)
		play_animation(MovementState.WALK)
		direction = Direction.LEFT
	elif Input.is_action_pressed("right"):
		velocity = Vector2(PlayerVariables.speed, 0)
		play_animation(MovementState.WALK)
		direction = Direction.RIGHT
	else:
		velocity = Vector2.ZERO
		play_animation(MovementState.IDLE)
	move_and_slide()

func play_animation(movement: MovementState):
	match direction:
		Direction.UP:
			anim.flip_h = false # Flip H => Horizontal den Charachter rotieren
			
			if movement == MovementState.WALK:
				anim.play("up_walk")
			else:
				anim.play("up_idle")
			
		Direction.DOWN:
			anim.flip_h = false # Flip H => Horizontal den Charachter rotieren
			
			if movement == MovementState.WALK:
				anim.play("down_walk")
			else:
				anim.play("down_idle")
		Direction.LEFT:
			anim.flip_h = true # Flip H => Horizontal den Charachter rotieren
			
			if movement == MovementState.WALK:
				anim.play("side_walk")
			else:
				anim.play("side_idle")
		Direction.RIGHT:
			anim.flip_h = false # Flip H => Horizontal den Charachter rotieren
			
			if movement == MovementState.WALK:
				anim.play("side_walk")
			else:
				anim.play("side_idle")	

func can_open_map():
	# check if nicht in der hub noch machen
	if is_zooming_in || is_zooming_out:
		return false
	
	if PlayerVariables.difficulty == PlayerVariables.Difficulty.EASY || PlayerVariables.difficulty == PlayerVariables.Difficulty.MEDIUM:
		return true
	return false

func set_zoom_niveau():
	follow_camera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)

func switch_level(level: String):
	zoom_in()
	
	await is_zooming_in_finished
	var scene_name = "res://scenes/level/" + level + ".tscn"
	get_tree().change_scene_to_file(scene_name)

func zoom_in():
	PlayerVariables.zoom_niveau = Constants.DEFAULT_ZOOM_NIVEAU
	is_zooming_in = true
	is_zooming_out = false

func zoom_out():
	PlayerVariables.zoom_niveau = Constants.HEAD_ZOOM_NIVEAU
	is_zooming_out = true
	is_zooming_in = false

func handle_zoom():
	if is_zooming_in:
		PlayerVariables.immobile = true
		PlayerVariables.zoom_niveau += Constants.ZOOM_TICK

		if PlayerVariables.zoom_niveau >= Constants.HEAD_ZOOM_NIVEAU:  
			is_zooming_in = false
			PlayerVariables.immobile = false
			is_zooming_in_finished.emit()

	elif is_zooming_out:
		PlayerVariables.immobile = true
		PlayerVariables.zoom_niveau -= Constants.ZOOM_TICK

		if PlayerVariables.zoom_niveau <= Constants.DEFAULT_ZOOM_NIVEAU:  
			is_zooming_out = false
			PlayerVariables.immobile = false
			is_zooming_out_finished.emit()

	# Ensure that zoom_niveau stays within a reasonable range
	PlayerVariables.zoom_niveau = clamp(PlayerVariables.zoom_niveau, Constants.DEFAULT_ZOOM_NIVEAU, Constants.HEAD_ZOOM_NIVEAU)
	set_zoom_niveau()
 
func damage_animation():
	for i in 4:
		anim.self_modulate = Color(1,0,0,0.5)
		await get_tree().create_timer(0.15).timeout
		anim.self_modulate = Color(1,1,1,1)
		await get_tree().create_timer(0.15).timeout
