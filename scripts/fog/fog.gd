extends TileMap

const FOG_ID = 1
const FOG_LAYER = 0
const FOG_START = 3
const WALL_ID = 1
const COLLISION_ID = 1
const NUM_RAYS = (360 / 4) * 0.4 # 0.35
const RAYS_INC = (360 / NUM_RAYS)
#RAY_OFFSET very delicate and is related to collision box sizes
const RAY_OFFSET = 10
const RAY_LENGTH = 64
const PATH_ERASE_ACC = RAY_LENGTH * 0.1
const PATH_ERASE_INTERVAL = RAY_LENGTH / PATH_ERASE_ACC
const TILE_SIZE = 16
var TILEMAP: TileMap
var PLAYER_RID: RID
var PLAYER_POS: Vector2
var PLAYER: CharacterBody2D

const FOG_PATH = "fog_level.save"
var revealed_tiles = {}

#var timer: Timer

func init(tilemap: TileMap, player: CharacterBody2D):
	PLAYER = player
	TILEMAP = tilemap
	PLAYER_RID = PLAYER.get_rid()
	var canvas = TILEMAP.get_used_rect()
	var pos = Vector2(canvas.position.x - 50, canvas.position.y - 50)
	var size = Vector2(canvas.size.x + 100, canvas.size.y + 100)
	
	for i in range(int(size.x)):
		for j in range(int(size.y)):
			set_cell(FOG_LAYER, Vector2i(pos.x + i, pos.y + j), FOG_ID, Vector2i(0, 0))
	
	if FileAccess.file_exists(get_file_path()):
		if not PlayerVariables.flag_is_new_game:
			load_fog()
		else:
			PlayerVariables.flag_is_new_game = false
		DirAccess.open("user://").remove(get_file_path())
	#init_timer()

func _physics_process(delta):
	if(PLAYER == null):
		return
	
	PLAYER_POS = PLAYER.global_position
	var pos = PLAYER_POS
	var space_state = TILEMAP.get_world_2d().direct_space_state

	for i in range(NUM_RAYS):
		var angle = deg_to_rad(RAYS_INC * i)
		var ray_direction = Vector2(cos(angle), sin(angle))
		var query = PhysicsRayQueryParameters2D.create(PLAYER_POS - ray_direction * RAY_OFFSET, PLAYER_POS + ray_direction * RAY_LENGTH, COLLISION_ID, [PLAYER_RID])
		var ray = space_state.intersect_ray(query)

		if ray:
			pos = TILEMAP.local_to_map(ray.position)
		else:
			pos = TILEMAP.local_to_map(PLAYER_POS + ray_direction * RAY_LENGTH)
		
		if(TILEMAP.get_cell_tile_data(WALL_ID, pos)):
			path_erase(pos)

func path_erase(pos: Vector2):
	var player_pos = Vector2(PLAYER_POS.x / TILE_SIZE, PLAYER_POS.y / TILE_SIZE)
	var start_distance = pos.distance_to(player_pos)
	var delta = start_distance / PATH_ERASE_INTERVAL
	var start = pos
	#for all wall tiles
	scatter_erase(pos)
	
	#if(pos.distance_squared_to(Vector2(-38, -1)) < 4):
	#	print("close to corner", pos)
	
	while(pos.distance_to(player_pos) <= start_distance && !is_zero_approx(pos.distance_to(player_pos))):
		#security
		if(TILEMAP.get_cell_tile_data(WALL_ID, pos)):
			#erase_cell less processing power, but less accurate
			erase_cell(FOG_LAYER, pos)
			revealed_tiles[stringify_vector(pos)] = ''
			#scatter_erase more processing power, but more accurate
			#scatter_erase(pos)
		pos = pos.move_toward(player_pos, delta)

func get_cardinals(pos: Vector2i): 
	var cardinals = [
		Vector2i(pos.x, pos.y - 1),
		Vector2i(pos.x, pos.y + 1),
		Vector2i(pos.x - 1, pos.y),
		Vector2i(pos.x + 1, pos.y)
	]
	return cardinals

func scatter_erase(pos: Vector2):
	for i in TILEMAP.get_surrounding_cells(pos):
	#for i in get_cardinals(pos):
		if(TILEMAP.get_cell_tile_data(WALL_ID, i)):
			erase_cell(FOG_LAYER, i)
			revealed_tiles[stringify_vector(i)] = ''
	var bottom_left_corner = Vector2i(pos.x - 1, pos.y + 1)
	if(TILEMAP.get_cell_tile_data(WALL_ID, bottom_left_corner) && !TILEMAP.get_cell_tile_data(WALL_ID, Vector2i(pos.x - 2, pos.y + 2))):
		erase_cell(FOG_LAYER, bottom_left_corner)
		revealed_tiles[stringify_vector(bottom_left_corner)] = ''
	var top_left_corner = Vector2i(pos.x - 1, pos.y - 1)
	if(TILEMAP.get_cell_tile_data(WALL_ID, top_left_corner) && !TILEMAP.get_cell_tile_data(WALL_ID, Vector2i(pos.x - 2, pos.y - 2))):
		erase_cell(FOG_LAYER, top_left_corner)
		revealed_tiles[stringify_vector(top_left_corner)] = ''

func save_fog():
	var file = FileAccess.open(get_file_path(), FileAccess.WRITE)
	var data = JSON.stringify(revealed_tiles)
	file.store_line(data)
	
func load_fog():
	var file = FileAccess.open(get_file_path(), FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	revealed_tiles = data

	for pos in revealed_tiles.keys():
		erase_cell(FOG_LAYER, parse_vector(pos))

func get_file_path():
	return "user://" + FOG_PATH

"""
func init_timer():
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", save_fog)
	timer.set_wait_time(10)
	timer.set_one_shot(false)
	timer.start()
"""

func stringify_vector(vec: Vector2i):
	return "{x}:{y}".format({ "x": vec.x, "y": vec.y })
	
func parse_vector(vec: String) -> Vector2i:
	var arr = vec.split(':')
	var x = float(arr[0])
	var y = float(arr[1])
	return Vector2i(x, y)
