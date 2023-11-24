extends TileMap

const FOG_ID = 1
const FOG_LAYER = 0
const RAY_LENGTH = 60
const WALL_ID = 1
const COLLISION_ID = 1
const NUM_RAYS = 360
const RAYS_INC = (360 / NUM_RAYS)
const RAY_OFFSET = 10
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
			set_cell(0, Vector2i(pos.x + i, pos.y + j), FOG_ID, Vector2i(0, 0))

func update_pos(pos):
	PLAYER_POS = pos

func _physics_process(delta):
	var position = PLAYER_POS
	var space_state = get_world_2d().direct_space_state

	if(PLAYER_POS == null):
		return

	for i in range(NUM_RAYS):
		var angle = deg_to_rad(RAYS_INC * i)
		var ray_direction = Vector2(cos(angle), sin(angle))
		var query = PhysicsRayQueryParameters2D.create(PLAYER_POS - ray_direction * RAY_OFFSET, PLAYER_POS + ray_direction * RAY_LENGTH, COLLISION_ID, [PLAYER_RID])
		var ray = space_state.intersect_ray(query)

		if ray:
			position = TILEMAP.local_to_map(ray.position)
			#print("wall hit: ", position)
			#if(position.x < PLAYER_POS.x || position.y < PLAYER_POS.y):
				#position = Vector2(position.x - 1, position.y - 1)
		else:
			position = TILEMAP.local_to_map(PLAYER_POS + ray_direction * RAY_LENGTH)
			#print("not max length: ", position)
		if(TILEMAP.get_cell_tile_data(WALL_ID, position)):
			#erase_cell(FOG_LAYER, position)
			scatter_erase(position)

func scatter_erase(pos: Vector2):
	"""
	var trace = pos
	print("Collision Position: ", pos)
	print("Player Position: ", PLAYER_POS)
	for i in range(0, ceil(pos.distance_to(PLAYER_POS))):
		trace = trace.move_toward(PLAYER_POS, 0.5)
		if TILEMAP.get_cell_tile_data(WALL_ID, trace):
			print("Trace: ", trace)
			return
	"""
	for i in TILEMAP.get_surrounding_cells(pos):
		if(TILEMAP.get_cell_tile_data(WALL_ID, i)):
			erase_cell(FOG_LAYER, i)
