extends CharacterBody2D


enum Direction { UP, DOWN, LEFT, RIGHT }
enum MovementState { WALK, IDLE }

@onready var anim = $AnimatedSprite2D


var direction: Direction = Direction.DOWN

func _ready():
	pass


func _process(delta):
	handle_movement_input()
	handle_map_input()
	handle_camera()

func handle_movement_input():
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

func handle_map_input():
	if Input.is_action_just_pressed("map") && can_open_map():
		PlayerVariables.active_camera = PlayerVariables.CameraTypes.MAP
		get_tree().paused = true

func handle_camera():
	if PlayerVariables.active_camera == PlayerVariables.CameraTypes.FOLLOW:
		$FollowCamera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)
		$FollowCamera.make_current()
	else:
		$MapNode/MapCamera.zoom = Vector2(0.5, 0.5)
		$MapNode/MapCamera.make_current()

func can_open_map():
	return true
