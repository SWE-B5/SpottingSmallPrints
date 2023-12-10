extends CharacterBody2D
class_name Player

enum Direction { UP, DOWN, LEFT, RIGHT }
enum MovementState { WALK, IDLE }
enum Level { HUB, L1, L2, L3, A_TEST, B_TEST }

@onready var anim = $AnimatedSprite2D
@onready var follow_camera = $FollowCamera
var direction: Direction = Direction.DOWN

func _ready():
	PlayerVariables.load_easy_game()
	follow_camera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)

func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		switch_level(Level.B_TEST)
		return
	
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

func get_target_level(level: Level):
	match level:
		Level.HUB:
			return "res://scenes/level/hub.tscn"
		Level.L1:
			return "res://scenes/level/level_1.tscn"
		Level.L2:
			return "res://scenes/level/level_2.tscn"
		Level.L3:
			return "res://scenes/level/level_2.tscn"
		Level.A_TEST:
			return "res://scenes/level/testing/a.tscn"
		Level.B_TEST:
			return "res://scenes/level/testing/b.tscn"
		_:
			return "res://scenes/level/hub.tscn"
		
func switch_level(level: Level):
	var target = get_target_level(level)
	print(target)
	get_tree().change_scene_to_file(target)
	
