extends CharacterBody2D
class_name Skull

# Hier muss speed nach Schwierigkeitsgrad eingestellt werden
@export var speed: float = 100
@export var markerid : String
@export var cooldown : float = 1
@onready var sprite = $sprite
@onready var hitbox : Area2D = $hitbox
@onready var timer : Timer = $hitbox_timer
var destination_points: Array = []  # Array to store Marker2D points
var current_destination: Vector2  # Current destination point

func _ready():
	sprite.play()
	# Populate the array with Marker2D points
	for marker in get_tree().get_nodes_in_group(markerid):
		if marker is Marker2D:
			destination_points.append(marker.global_position)
	
	match PlayerVariables.difficulty:
		PlayerVariables.Difficulty.EASY:
			speed = Constants.SPEED_SKULL_EASY
		PlayerVariables.Difficulty.MEDIUM:
			speed = Constants.SPEED_SKULL_MEDIUM
		PlayerVariables.Difficulty.HARD:
			speed = Constants.SPEED_SKULL_HARD

	# Start the enemy at a random destination
	choose_random_destination()

func _process(delta):
	# Move towards the current destination
	var direction = (current_destination - global_position).normalized()
	move_and_collide(direction * speed * delta)

	# Check if the enemy has reached its current destination
	if global_position.distance_to(current_destination) < 5.0:
		choose_random_destination()
		
func choose_random_destination():
	# Choose a random destination from the array
	current_destination = destination_points[randi() % destination_points.size()]
	
func _on_hitbox_area_entered(area):
	if area.is_in_group("hitbox_player") && PlayerVariables.immunity_frames <= 0:
		await get_tree().create_timer(0.2).timeout
		hitbox.set_deferred("disabled", true)
		timer.start()
		Health.damage_player(1)
		# Hier werden die Leben abgezogen und Immunity frames berechnet
		choose_random_destination()
		
		print("Damage dealt to player:")
func _on_hitbox_timer_timeout():
	hitbox.set_deferred("disabled", false)
