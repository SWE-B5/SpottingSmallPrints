extends Node2D

@onready var player = $Player
@onready var fog = $Fog

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.load_easy_game()
	fog.init($TileMap, $Player)
	Health.reset_health() #muss bleiben
	Inventory.update_after_death() #muss bleiben
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
static var cnt = 299 #zum testen
static var temp_save_health #zum testen
static var temp_save_inventory #zum testen
func _process(_delta):
	fog.update_pos(player.position)
	cnt += 1
	match cnt:
		#Health
		1:
			Health.reset_health(3, Health.INACTIVE)
		2:
			print(Health.check_shield_possible())
		3:
			Health.apply_shield()
		4:
			Health.reset_health()
		5:
			Health.apply_shield()
		6:
			print(Health.check_shield_possible())
		7:
			Health.damage_player()
		8:
			Health.damage_player()
		9:
			Health.damage_player(2)
		10: 
			Health.reset_health(4, Health.ACTIVE)
		11:
			print(Health.check_shield_possible())
		12:
			Health.damage_player(100)
		13:
			Health.damage_player()
		14:
			Health.reset_health()
		15:
			Health.reset_health(10)
		16: 
			Health.damage_player(100)
		17:
			temp_save_health = Health.get_for_save()
		18:
			Health.reset_health(0, Health.ACTIVE)
		19:
			Health.set_for_load(temp_save_health)
		20:
			cnt = 99
		#Inventory
		100:
			Inventory.update_new_game()
		101:
			print(Inventory.check_key(Inventory.GOLD, 2))
		102:
			print(Inventory.check_all_notes_current_level())
		103:
			Inventory.collect_item(Inventory.SILVER, 2)
			Inventory.collect_item(Inventory.NOTE, 1)
			Inventory.collect_item(Inventory.GOLD, 14)
		104:
			Inventory.update_after_death()
		105:
			Inventory.update_new_game()
		106:
			Inventory.collect_item(Inventory.SILVER, 2)
			Inventory.collect_item(Inventory.SILVER, 2)
			print(Inventory.check_key(Inventory.SILVER, 2))
			print(Inventory.check_key(Inventory.SILVER, 1))
		107:
			Inventory.collect_item(Inventory.NOTE, 1)
			print(Inventory.check_key(Inventory.NOTE, 2))
		108:
			Inventory.use_key(Inventory.NOTE)
		109:
			Inventory.use_key(Inventory.GOLD)
		110:
			Inventory.use_key(Inventory.SILVER)
		111:
			Inventory.use_key(Inventory.SILVER)
		112:
			Inventory.use_key(Inventory.SILVER)
		113:
			Inventory.collect_item(Inventory.SILVER, 3)
		114:
			print(Inventory.check_key(Inventory.SILVER, 3))
		115:
			print(Inventory.check_key(Inventory.SILVER, 2))
		116:
			Inventory.collect_item(Inventory.NOTE, 10)
		117:
			print(Inventory.check_all_notes_current_level())
		118:
			Inventory.collect_item(Inventory.NOTE, 11)
			Inventory.collect_item(Inventory.NOTE, 13)
		119:
			print(Inventory.check_all_notes_current_level())
		120:
			Inventory.update_after_level_completed()
		121:
			Inventory.collect_item(Inventory.DIAMOND, 1)
		122:
			temp_save_inventory = Inventory.get_for_save()
		123:
			Inventory.update_new_game()
		124:
			Inventory.set_for_load(temp_save_inventory)
		125:
			Inventory.use_key(Inventory.GOLD)
		126:
			print(Inventory.number_of_notes_found())
		127:
			print(Inventory.number_of_opened_gold_doors())
		128:
			cnt = 199
		#inventory part 2 (HUB-MODE)
		200:
			Inventory.update_new_game()
		201:
			Inventory.collect_item(Inventory.GOLD, 1)
		202:
			Inventory.collect_item(Inventory.GOLD, 2)
		203:
			Inventory.use_key(Inventory.GOLD)
		204:
			Inventory.use_key(Inventory.GOLD)
		205:
			Inventory.collect_item(Inventory.DIAMOND, 1)
		206:
			Inventory.use_key(Inventory.DIAMOND)
		207:
			cnt = 299
		#HUD (Level-Mode)
		300:
			Health.reset_health(3, Health.INACTIVE)
			Inventory.update_new_game()
			Inventory.collect_item(Inventory.SILVER, 9)
			Inventory.collect_item(Inventory.SILVER, 9)
			Inventory.collect_item(Inventory.SILVER, 9)
		301:
			Hud.queue_overlay()
		302:
			Hud.queue_overlay()
		303:
			Hud.dequeue_overlay()
		304:
			Hud.queue_overlay()
		305:
			Hud.dequeue_overlay()
		306:
			Hud.dequeue_overlay()
		307:
			Hud.queue_overlay()
		#308:
		#	Hud.dequeue_overlay()
