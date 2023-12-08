extends StaticBody2D

const SPEED = 120
var TILEMAP: TileMap
var ROTATION: float

func init(rotation: float):
	ROTATION = rotation

func _ready():
	TILEMAP = get_parent().get_node("TileMap")
	self.rotate(ROTATION)

func _process(delta):
	var result = move_and_collide(Vector2(cos(self.rotation), sin(self.rotation)) * SPEED * delta)
	if(result != null):
		if(result.get_collider() == get_parent().find_child("Player")):
			Health.damage_player()
		queue_free()
