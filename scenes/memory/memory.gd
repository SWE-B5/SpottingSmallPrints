extends Node2D

var card = preload("res://scenes/memory/card.tscn")
var Textures = [
	preload("res://assets/memory/000.png"),
	preload("res://assets/memory/001.png"),
	preload("res://assets/memory/002.png"),
	preload("res://assets/memory/003.png"),
	preload("res://assets/memory/004.png"),
	preload("res://assets/memory/005.png"),
	preload("res://assets/memory/006.png"),
	preload("res://assets/memory/007.png"),
	preload("res://assets/memory/008.png"),
	preload("res://assets/memory/009.png")
]
var cards = []
var open_cards = []
var ROW = 4
var COL = 5

func _ready():
	for t in Textures:
		var newCard = card.instantiate()
		newCard.get_node("obverse").texture = t
		cards.append(newCard)
		var newCard_match = card.instantiate()
		newCard_match.get_node("obverse").texture = t
		cards.append(newCard_match)
		
	cards.shuffle()
		
	for row in ROW:
		for col in COL:
			var c = cards[col + row * 5]
			c.position = Vector2(100, 100) + Vector2(100 * col, 100 * row)
			add_child(c)

func check():
	print(open_cards)
	
	if len(open_cards) >= 2:
		for card in cards:
			card.can_control = false
		# match
		if open_cards[0].get_node("obverse").texture == \
			open_cards[1].get_node("obverse").texture:
			$DeleteTimer.start()
		# unmatch
		else:
			print("turnback timer start")
			$TurnBackTimer.start()
			
func continue_control():
	for card in cards:
		card.can_control = true
	open_cards = []
	
func _on_delete_timer_timeout():
	for card in open_cards:
		card.queue_free()
		cards.erase(card)
	continue_control()

func _on_turn_back_timer_timeout():
	for card in open_cards:
		card.get_node("AnimationPlayer").play("turn_back")
	continue_control()

