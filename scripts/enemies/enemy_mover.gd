extends CharacterBody2D
class_name enemy_movement
@export var speed = 100
@onready var sprite = $sprite
var current_state : enemy_state
enum enemy_state {MOVERIGHT, MOVELEFT, MOVEUP, MOVEDOWN}

func _physics_process(delta):
	
	match current_state:
		enemy_state.MOVERIGHT:
			sprite.animation = "move_right"
			move_right()
		enemy_state.MOVELEFT:
			sprite.animation = "move_left"
			move_left()
		enemy_state.MOVEUP:
			sprite.animation = "move_up"
			move_up()
		enemy_state.MOVEDOWN:
			sprite.animation = "move_down"
			move_down()
	move_and_slide()

func random_generation():
	var dir = randi() % 4
	match dir:
		0:
			current_state=enemy_state.MOVERIGHT
		1:
			current_state=enemy_state.MOVELEFT
		2:
			current_state=enemy_state.MOVEUP
		3:
			current_state=enemy_state.MOVEDOWN

func move_right():
	velocity = Vector2.RIGHT * speed
	sprite.animation = "move_right"
func move_left():
	velocity = Vector2.LEFT * speed
	sprite.animation = "move_left"
func move_up():
	velocity = Vector2.UP * speed
	sprite.animation = "move_up"
func move_down():
	velocity = Vector2.DOWN * speed
	sprite.animation = "move_down"
