extends Node2D

@onready var player = $Player
@onready var fog = $Fog
@onready var tilemap = $TileMap

@onready var skeletons = $Gegner/Skeletons

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

func _ready():
	fog.init(tilemap, player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!

