extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	fog.init($TileMap, $Player)
	Health.reset_health() #muss drin bleiben!
	Inventory.update_after_death() #muss drin bleiben!
	
