extends Node2D

# VARIABLEN HIER ANPASSEN UND ENTSPRECHENDE METHODEN UNTEN AUSKOMMENTIEREN
var memory_scene_path = "res://scenes/memory/memory.tscn"
var next_scene_path = "res://path/to/your_next_scene.tscn"

var max_game_moves


var isActive = false
signal memorySuccessful
signal memoryCanceled

#Goldene Truhe implementation
func _on_goldene_truhe_start_memory():
	isActive = true
	visible = isActive
	$CanvasLayer.visible = isActive
	startGame()

func closeMemory():
	isActive = false
	visible = false
	$CanvasLayer.visible = false
###################

func set_difficulty():
	if (PlayerVariables.difficulty == PlayerVariables.Difficulty.EASY):
		max_game_moves = 50
	elif (PlayerVariables.difficulty == PlayerVariables.Difficulty.MEDIUM):
		max_game_moves = 30
	elif (PlayerVariables.difficulty == PlayerVariables.Difficulty.HARD):
		max_game_moves = 20

func _ready():
	#_on_goldene_truhe_start_memory()
	pass

# lade memory karten assets
var card = preload("res://scenes/memory/card.tscn")
var Textures = [
	preload("res://assets/memory/memory_card0.png"),
	preload("res://assets/memory/memory_card1.png"),
	preload("res://assets/memory/memory_card2.png"),
	preload("res://assets/memory/memory_card3.png"),
	preload("res://assets/memory/memory_card4.png"),
	preload("res://assets/memory/memory_card5.png"),
	preload("res://assets/memory/memory_card6.png"),
	preload("res://assets/memory/memory_card7.png"),
	preload("res://assets/memory/memory_card8.png"),
	preload("res://assets/memory/memory_card9.png")
]
var cards = []
var open_cards = []
var ROW = 4
var COL = 5
var PairsToBeFound = (ROW * COL) / 2

# HUD variablen
var gameMoves = 0
var gameMovesLabel

func startGame():
	set_difficulty()
	#max_game_moves = 2
	var cards_container = get_node("CanvasLayer/Panel/cards") # pfad zum sprite an dem die karten spawnen
	PairsToBeFound = (ROW * COL) / 2
	gameMoves = 0
	cards = []
	open_cards = []
	setupHUD()
	# instanziiere memory karten
	for t in Textures:
		var newCard = card.instantiate()
		newCard.get_node("obverse").texture = t
		cards.append(newCard)
		var newCard_match = card.instantiate()
		newCard_match.get_node("obverse").texture = t
		cards.append(newCard_match)
		
	cards.shuffle() # mische karten
		
	# erzeuge memory karten am 'cards' sprite
	for row in ROW:
		for col in COL:
			var c = cards[col + row * 5]
			c.position = Vector2(125 * col, 125 * row)
			cards_container.add_child(c)

# instanziiert/aktualisiert HUD
func setupHUD():
	gameMovesLabel = get_node("CanvasLayer/Panel/PanelContainerTop/VBoxContainer/HBoxContainer/counter")
	gameMovesLabel.text = str(max_game_moves - gameMoves)

# prüft memory karten
func check():
	# wenn zwei karten gewählt wurden
	if len(open_cards) >= 2:
		for card in cards:
			if card != null:
				card.can_control = false
		increase_move_count()
		# prüfe ob selbe karte
		if open_cards[0] == open_cards[1]:
			$TurnBackTimer.start()
			return
		# match
		if open_cards[0].get_node("obverse").texture == \
			open_cards[1].get_node("obverse").texture:
			$DeleteTimer.start()
			PairsToBeFound -= 1
			# prüfe ob alle karten gefunden
			if PairsToBeFound == 0:
				on_all_pairs_found()
		# unmatch
		else:
			$TurnBackTimer.start()

# clear array
func continue_control():
	if success:
		for card in cards:
			if card != null:
				card.can_control = true
		open_cards = []

# timer: wenn karten ein match waren -> karten werden gelöscht
func _on_delete_timer_timeout():
	for card in open_cards:
		if card != null:
			card.queue_free()
			cards.erase(card)
	continue_control()

# timer: karten werden wieder umgedreht
func _on_turn_back_timer_timeout():
	for card in open_cards:
		if card != null:
			card.get_node("AnimationPlayer").play("turn_back")
	continue_control()

var success = true
# timer: wenn spiel gelöst -> scenen wechsel, falls verloren -> Neustarten
func _on_scene_change_timer_timeout():
	if success:
		memorySuccessful.emit()
		closeMemory()
	else:
		for card in cards:
			if card != null:
				card.queue_free()
		startGame()
		success = true

# funktion für timer start nach ende
func on_all_pairs_found():
	success = true
	gameMovesLabel.text = "Memory erfolgreich bestanden"
	$SceneChangeTimer.start()

# funktion fängt <q> tastendruck ab -> scenen wechsel
var is_scene_changing = false
func _process(delta):
	if Input.is_key_pressed(KEY_Q) and not is_scene_changing:
		is_scene_changing = true
		#var oldCards = $CanvasLayer/Panel/cards.get_children()
		for card in cards:
			if card != null:
				card.queue_free()
		memoryCanceled.emit()
		closeMemory()
		is_scene_changing = false


# inkrementiert 'gameMoves', aktualiert HUD 
# und prüft ob 'max_game_moves' erreicht -> neue memory scene wird geladen
func increase_move_count():
	gameMoves += 1
	setupHUD()
	if gameMoves >= max_game_moves:
		load_new_memory_game()

# lädt neue memory scene
func load_new_memory_game():
	for card in cards:
		if card != null:
			card.can_control = false
	gameMovesLabel.text = "Keine Moves mehr, Memory wird resettet"
	success = false
	$SceneChangeTimer.start()
	#startGame()

# ruft check() methode auf
func card_selected(card):
	open_cards.append(card)
	card.can_control = false
	check()
