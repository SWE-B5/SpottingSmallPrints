extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var skeletons

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.initialize_new_game(PlayerVariables.Difficulty.EASY)
	update_skeleton_speed()
	fog.init($TileMap, $Player)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fog.update_pos(player.position)
	
func update_skeleton_speed():
	var speed: float = 100
	
	match PlayerVariables.difficulty:
		PlayerVariables.Difficulty.EASY:
			speed = Constants.SPEED_SKELETON_EASY
		PlayerVariables.Difficulty.MEDIUM:
			speed = Constants.SPEED_SKELETON_MEDIUM
		PlayerVariables.Difficulty.HARD:
			speed = Constants.SPEED_SKELETON_HARD
			
	for skeleton in skeletons.get_children():
		skeleton.speed = speed
