extends CharacterBody2D


@export var speed: float = 100
@export var markerid : String
@onready var sprite = $sprite
var destination_points: Array = []  # Array to store Marker2D points
var current_destination: Vector2  # Current destination point

func _ready():
	sprite.play()
	# Populate the array with Marker2D points
	for marker in get_tree().get_nodes_in_group(markerid):
		if marker is Marker2D:
			destination_points.append(marker.global_position)

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
	if area.is_in_group("hitbox_player"):
		choose_random_destination()
		# Hier werden die Leben abgezogen und Immunity frames berechnet
		print("Damage dealt to player:")
