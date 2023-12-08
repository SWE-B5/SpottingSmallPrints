extends Node2D

var ARROW = preload("res://scenes/traps/projectiles/arrow.tscn")
var TILEMAP: TileMap
var RAY_LENGTH = 4000
var WALL_FOUND = false
const COLLISION_LAYER = 1
var ACTIVE = false

func _ready():
	TILEMAP = get_parent().get_node("TileMap")

func _on_timer_timeout():
	ACTIVE = false
	var arrowInstance = ARROW.instantiate() as Node2D
	arrowInstance.global_position = Vector2i(self.global_position.x, self.global_position.y + 8)
	arrowInstance.init(self.rotation)
	get_parent().add_child(arrowInstance)
	
func _physics_process(delta):
	var space_state = TILEMAP.get_world_2d().direct_space_state
	var ray_direction = Vector2(cos(self.rotation), sin(self.rotation))
	var query = PhysicsRayQueryParameters2D.create(self.global_position, self.global_position + RAY_LENGTH * ray_direction, COLLISION_LAYER)
	var ray = space_state.intersect_ray(query)
	
	if ray && !ACTIVE:
		if(ray["collider"].get_class() != "TileMap"):
			ACTIVE = true
			$Timer.start()
		elif(ray["collider"].get_class() == "TileMap" && !WALL_FOUND):
			WALL_FOUND = true
			RAY_LENGTH = ray["position"].distance_to(self.global_position)
