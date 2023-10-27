extends TileMap

const BLACK_ID = 1
const BLACK_BIG_ID = 2

func _ready():
	draw()

func draw():
	for i in range(-255, 255):
		for j in range(-255, 255):
			set_cell(0, Vector2i(i, j), 2, Vector2i(0, 0))
	
func tick(position: Vector2):
	var factor = 1
	var tmp: Vector2
	
	for i in range(-16 * factor, 16 * factor):
		for j in range(-16 * factor, 16 * factor):
			tmp = position
			tmp.x += i
			tmp.y += j
			
			erase_cell(0, local_to_map(tmp))
	
func _process(delta):
	pass
