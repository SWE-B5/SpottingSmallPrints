extends Node2D

@onready var player = $Player
@onready var fog = $Fog

# Called when the node enters the scene tree for the first time.
func _ready():
	fog.init($TileMap, $Player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fog.update_pos(player.position)
