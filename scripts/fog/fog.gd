extends TileMap
# Benutzung: Am Anfang der Level Generation $Fog.draw() laden, bei _process: Fog.tick(player.position)

const BLACK_ID = 1 # ID von unserer TileMap
const FOG_RADIUS = 2 * 16

var first_drawn = true

func draw():	
	for i in range(-255, 255):
		for j in range(-255, 255):
			set_cell(0, Vector2i(i, j), BLACK_ID, Vector2i(0, 0))

func tick(position: Vector2):
	remove_circle(position)
	
func remove_circle(center: Vector2):
	# Ein Kreis Umfang erstellen und deren Tiles entfernen
	# TODO: Kreisinnere löscht sich am Anfang des Spieles nicht!
	for i in range(0, 361):
		# Convert degrees to radians
		var angle = deg_to_rad(i)
		
		# Calculate the position on the circle using trigonometry
		var x = center.x + FOG_RADIUS * cos(angle)
		var y = center.y + FOG_RADIUS * sin(angle)
		
		# Erase the cell at the calculated position
		erase_cell(0, local_to_map(Vector2(x, y)))
	
func remove_standart_circle(center: Vector2):
	var lowest_x: int
	var highest_x: int
	var lowest_y: int
	var highest_y: int
	
	for i in range(0, 361):
		var angle = deg_to_rad(i)
		
		# Calculate the position on the circle using trigonometry
		var x = center.x + FOG_RADIUS * cos(angle)
		var y = center.y + FOG_RADIUS * sin(angle)
		
		if x < lowest_x:
			lowest_x = x
		if x > highest_x:
			highest_x = x
		if y < lowest_y:
			lowest_y = y
		if y > highest_y:
			highest_y = y

		# Erase the cell at the calculated position
		erase_cell(0, local_to_map(Vector2(x, y)))
	
	for i in range(lowest_x, highest_x):
		for j in range(lowest_y, highest_y):
			erase_cell(0, local_to_map(Vector2(i, j)))
