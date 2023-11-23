extends TileMap

const FOG_ID = 1
const FOG_RADIUS = 4*12
const BACKGROUND_ID = 0
const WALL_ID = 0
const COLLISION_ID = 1
var TILEMAP: TileMap

func init(tilemap: TileMap):
	TILEMAP = tilemap
	var canvas = TILEMAP.get_used_rect()
	var pos = Vector2(canvas.position.x - 50, canvas.position.y - 50)
	var size = Vector2(canvas.size.x + 100, canvas.size.y + 100)

	for i in range(int(size.x)):
		for j in range(int(size.y)):
			set_cell(0, Vector2i(pos.x + i, pos.y + j), FOG_ID, Vector2i(0, 0))

func remove(pos: Vector2):
	# kann aus FOG_RADIUS berechnet werden
	var num_steps = 36
	var step_size = 10
	var collision_count
	var position

	for i in range(num_steps):
		var angle = deg_to_rad(i * step_size)
		var x = pos.x + FOG_RADIUS * cos(angle)
		var y = pos.y + FOG_RADIUS * sin(angle)
		position = local_to_map(Vector2(x, y))
		erase_cell(0, position)

	var last_angle = deg_to_rad(360)
	var last_x = pos.x + FOG_RADIUS * cos(last_angle)
	var last_y = pos.y + FOG_RADIUS * sin(last_angle)
	position = local_to_map(Vector2(last_x, last_y))
	erase_cell(0, position)
