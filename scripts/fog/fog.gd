# Benutzung: Am Anfang der Level Generation $Fog.draw() laden, bei _process: Fog.tick(player.position)
extends TileMap

const BLACK_ID = 1 # ID von unserer TileMap

func draw():	
	for i in range(-255, 255):
		for j in range(-255, 255):
			set_cell(0, Vector2i(i, j), BLACK_ID, Vector2i(0, 0))
func tick(position: Vector2):
	remove_circle(position, 2)
	
func remove_circle(center: Vector2, radius: float):
	radius *= 16 # Damit wir richtig skalieren

	# Ein Kreis Umfang erstellen und deren Tiles entfernen
	# TODO: Kreisinnere löscht sich am Anfang des Spieles nicht!
	for i in range(0, 360):
		# Convert degrees to radians
		var angle = deg_to_rad(i)
		
		# Calculate the position on the circle using trigonometry
		var x = center.x + radius * cos(angle)
		var y = center.y + radius * sin(angle)
		
		# Erase the cell at the calculated position
		erase_cell(0, local_to_map(Vector2(x, y)))
