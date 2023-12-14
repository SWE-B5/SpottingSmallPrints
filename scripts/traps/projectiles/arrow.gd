extends StaticBody2D

#speed should be calculated by player speed to allow for evasion
const SPEED = 100
const PLAYER_LAYER = 16 as int
const WALL_LAYER = 1 as int
var TILEMAP: TileMap
var ROTATION: float
var DISPENSER_POS: Vector2i
var PARENT: StaticBody2D

func init(parent: StaticBody2D, dispenser_pos: Vector2i):
	PARENT = parent
	ROTATION = parent.rotation
	DISPENSER_POS = dispenser_pos

func _ready():
	TILEMAP = get_parent().get_node("TileMap")
	self.rotate(ROTATION)

func _process(delta):
	if(self.global_position.distance_squared_to(DISPENSER_POS)  >= 128):
		collision_mask = WALL_LAYER
	var result = move_and_collide(Vector2(cos(self.rotation), sin(self.rotation)) * SPEED * delta)
	if(result != null):
		if(result.get_collider() == get_parent().find_child("Player")):
			Health.damage_player()
		queue_free()
		PARENT.ARROW_ACTIVE = false
