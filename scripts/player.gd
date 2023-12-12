extends CharacterBody2D
class_name Player

enum Direction { UP, DOWN, LEFT, RIGHT }
enum MovementState { WALK, IDLE }

@onready var anim = $AnimatedSprite2D
@onready var follow_camera = $FollowCamera
var direction: Direction = Direction.DOWN

var is_zooming_in: bool = false
var is_zooming_out: bool = true

func _ready():
	$FollowCamera.make_current()

func _process(delta):
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
	if PlayerVariables.difficulty == PlayerVariables.Difficulty.EASY || PlayerVariables.difficulty == PlayerVariables.Difficulty.MEDIUM:
		return true
	return false

func set_zoom_niveau():
	follow_camera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)

func switch_level(level: Level):
	pass

func zoom_in():
	is_zooming_in = true
	is_zooming_out = false

func zoom_out():
	is_zooming_out = true
	is_zooming_in = false

func stop_zoom():
	is_zooming_in = false
	is_zooming_out = false
	
func handle_zoom():
	if is_zooming_in:
		PlayerVariables.immobile = true
		PlayerVariables.zoom_niveau += 0.005

		if PlayerVariables.zoom_niveau >= 5.0:  # Adjust this value based on your desired maximum zoom level
			is_zooming_in = false
			PlayerVariables.immobile = false

	elif is_zooming_out:
		PlayerVariables.immobile = true
		PlayerVariables.zoom_niveau -= 0.005

		if PlayerVariables.zoom_niveau <= 2.0:  # Adjust this value based on your desired minimum zoom level
			is_zooming_out = false
			PlayerVariables.immobile = false

	# Ensure that zoom_niveau stays within a reasonable range
	PlayerVariables.zoom_niveau = clamp(PlayerVariables.zoom_niveau, 2, 5)
	set_zoom_niveau()
