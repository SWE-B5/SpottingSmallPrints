extends CharacterBody2D
class_name Player

enum Direction { UP, DOWN, LEFT, RIGHT, IDLE }
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
var last_direction_state = Direction.IDLE
var damage_player = true

func _ready():
	set_zoom_niveau()
	fade_out()
	
func _process(delta):
	PlayerVariables.global_position = self.global_position
	handle_movement_input()
	if PlayerVariables.immunity_frames > 0:
		PlayerVariables.immunity_frames -= delta
		if(!damage_player):
			damage_player = true
			damage_animation()
	else:
		damage_player = false

func handle_movement_input():
	if PlayerVariables.immobile:
		velocity = Vector2.ZERO
		play_animation(MovementState.IDLE, velocity)
		move_and_slide()
		return

	var dir = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		direction = Direction.UP
		dir.y -= 1
	if Input.is_action_pressed("down"):
		direction = Direction.DOWN
		dir.y += 1
	if Input.is_action_pressed("left"):#
		direction = Direction.LEFT
		dir.x -= 1
	if Input.is_action_pressed("right"):
		direction = Direction.RIGHT
		dir.x += 1

	velocity = dir.normalized() * PlayerVariables.speed
	move_and_slide()
	
	play_animation(MovementState.WALK if velocity != Vector2.ZERO else MovementState.IDLE, dir)

func play_animation(movement: MovementState, dir: Vector2):
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
	if PlayerVariables.flag_dialog_open:
		return false
	if PlayerVariables.flag_raetsel_open:
		return false
	
	if PlayerVariables.difficulty == PlayerVariables.Difficulty.EASY || PlayerVariables.difficulty == PlayerVariables.Difficulty.MEDIUM:
		return true
	return false


func set_zoom_niveau():
	follow_camera.zoom = Vector2(PlayerVariables.zoom_niveau, PlayerVariables.zoom_niveau)

func switch_level(level: String):
	if FileAccess.file_exists("user://fog_level.save"):
		var dir = DirAccess.open("user://")
		dir.remove("user://fog_level.save")
	
	currently_fading = true
	PlayerVariables.immobile = true
	fade_player.play("fade_to_black")
	
	await to_black_fade_finished
	if level == "outro" || level == "Outro":
		get_tree().change_scene_to_file("res://scenes/ui/OutroCredits.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/level/" + level + ".tscn")
	
func damage_animation():
	while(damage_player):
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

