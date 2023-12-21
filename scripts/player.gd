extends CharacterBody2D
class_name Player

enum Direction { UP, DOWN, LEFT, RIGHT }
enum MovementState { WALK, IDLE }

@onready var anim = $AnimatedSprite2D
@onready var follow_camera = $FollowCamera

# Fade in and out related stuff
@onready var fade_screen = $CanvasLayer/FadeScreen
@onready var fade_player = $CanvasLayer/FadeScreen/AnimationPlayer
signal from_black_fade_finished
signal to_black_fade_finished
var currently_fading = false

var direction: Direction = Direction.DOWN

func _ready():
	set_zoom_niveau()
	fade_out()
	
func _process(delta):
	PlayerVariables.global_position = self.global_position

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
	if currently_fading:
		return false
	
	if PlayerVariables.difficulty == PlayerVariables.Difficulty.EASY || PlayerVariables.difficulty == PlayerVariables.Difficulty.MEDIUM:
		return true
	return false


func set_zoom_niveau():
	follow_camera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)

func switch_level(level: String):
	currently_fading = true
	PlayerVariables.immobile = true
	fade_player.play("fade_to_black")
	
	await to_black_fade_finished
	get_tree().change_scene_to_file("res://scenes/level/" + level + ".tscn")
	
func damage_animation():
	for i in 4:
		anim.self_modulate = Color(1,0,0,0.5)
		await get_tree().create_timer(0.15).timeout
		anim.self_modulate = Color(1,1,1,1)
		await get_tree().create_timer(0.15).timeout


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_from_black":
		from_black_fade_finished.emit()
	elif anim_name == "fade_to_black":
		to_black_fade_finished.emit()

func fade_out():
	currently_fading = true
	PlayerVariables.immobile = true
	fade_player.play("fade_from_black")
	await from_black_fade_finished
	PlayerVariables.immobile = false
	currently_fading = false

		
func alert():
	if($AlertPlayer.is_playing()):
		$AlertPlayer.seek(0.2)
	else:
		$AlertPlayer.play("alert_animation")


func _on_alert_player_animation_finished(anim_name):
	$AlertPlayer.stop()

