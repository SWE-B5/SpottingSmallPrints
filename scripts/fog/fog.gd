extends TileMap

const FOG_ID = 1
const FOG_LAYER = 0
const FOG_START = 3
const WALL_ID = 1
const COLLISION_ID = 1
const NUM_RAYS = (360 / 4) * 0.5
const RAYS_INC = (360 / NUM_RAYS)
#RAY_OFFSET very delicate and is related to collision box sizes
const RAY_OFFSET = 10
const RAY_LENGTH = 75
const PATH_ERASE_ACC = RAY_LENGTH * 0.1
const PATH_ERASE_INTERVAL = RAY_LENGTH / PATH_ERASE_ACC
const TILE_SIZE = 16
var TILEMAP: TileMap
var PLAYER_RID: RID
var PLAYER_POS: Vector2

func init(tilemap: TileMap, player: CharacterBody2D):
	TILEMAP = tilemap
	PLAYER_RID = player.get_rid()
	var canvas = TILEMAP.get_used_rect()
	var pos = Vector2(canvas.position.x - 50, canvas.position.y - 50)
	var size = Vector2(canvas.size.x + 100, canvas.size.y + 100)

	for i in range(int(size.x)):
		for j in range(int(size.y)):
			set_cell(FOG_LAYER, Vector2i(pos.x + i, pos.y + j), FOG_ID, Vector2i(0, 0))

func update_pos(pos):
	PLAYER_POS = pos

func _physics_process(delta):
	var pos = PLAYER_POS
	var space_state = TILEMAP.get_world_2d().direct_space_state

	if(PLAYER_POS == null):
		return

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
	while(pos.distance_to(player_pos) <= start_distance && !is_zero_approx(pos.distance_to(player_pos))):
		#security
		if(TILEMAP.get_cell_tile_data(WALL_ID, pos)):
			#erase_cell way more processing power, but less accurate
			erase_cell(FOG_LAYER, pos)
			#scatter_erase more processing power, but more accurate
			#scatter_erase(pos)
		pos = pos.move_toward(player_pos, delta)

func scatter_erase(pos: Vector2):
	for i in TILEMAP.get_surrounding_cells(pos):
		if(TILEMAP.get_cell_tile_data(WALL_ID, i)):
			erase_cell(FOG_LAYER, i)
