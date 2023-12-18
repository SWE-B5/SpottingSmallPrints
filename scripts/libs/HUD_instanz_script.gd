extends CanvasLayer

###########################################
# Alles hier drunter nur intern verwendet #
###########################################


#used for instantiating Hud_panels
@onready var NoteGuiClass = preload("res://scenes/HUD/parts (don't add to level)/Note_panel.tscn")
@onready var HeartGuiClass = preload("res://scenes/HUD/parts (don't add to level)/Heart_panel.tscn")
@onready var ShieldGuiClass = preload("res://scenes/HUD/parts (don't add to level)/Shield_panel.tscn")

#Kindknoten sollten folgende Reihenfolge haben
#0.silver
#1.gold
#2.diamond
#3.notes
#4.health

#fügt neue HUD Nodes zu Gruppe hinzu
#sonst Probleme sie einzeln aufzurufen
func _ready():
	#print("group self")
	#print(self)
	add_to_group("Group HUDs")
	Hud.is_Hub = PlayerVariables.current_level == 2
	Hud.reset_queue_overlay()
	#print(get_tree().get_current_scene().name)
	#print(Hud.is_Hub)

#passt Sichtbarkeit der einzelnen HUD-Elemente den aktuellen Einstellungen an
func _process(_delta):
	self.visible = Hud.overlay_cnt <= 0
	#print(get_tree().get_current_scene().name)
	#print("process self")
	#print(self)
	if Hud.is_Hub:
		self.get_child(0).visible = false
		self.get_child(1).visible = true
		self.get_child(2).visible = true
		self.get_child(3).visible = true
		self.get_child(4).visible = false
	else:
		self.get_child(0).visible = true
		self.get_child(1).visible = false
		self.get_child(2).visible = false
		self.get_child(3).visible = true
		self.get_child(4).visible = true

#updatet Note-Leiste inhaltlich
#löscht alle Note-Panals und fügt richtige Anzahl wieder hinzu
func update_note_hud(number_of_notes: int):
	#print("update")
	#print(number_of_notes)
	var node = self.get_child(3)
	for n in node.get_child_count():
		node.get_child(n).queue_free()
	for i in number_of_notes:
		var note = NoteGuiClass.instantiate()
		node.add_child(note)

#updatet Health-Leiste inhaltlich
#löscht alle Heart-Panals/Shield-Panels und fügt richtige Anzahl wieder hinzu
func update_health_hud(number_of_lives: int, shield_active: Health.Shield_States):
	var node = self.get_child(4)
	for n in node.get_child_count():
		node.get_child(n).hide()
		node.get_child(n).queue_free()
	for i in number_of_lives:
		var heart = HeartGuiClass.instantiate()
		node.add_child(heart)
	if shield_active:
		var shield = ShieldGuiClass.instantiate()
		node.add_child(shield)

#updatet Key-Leiste inhaltlich
#updated den Frame des Zahl-panels
#falls Anzahl == 0, dann Schlüsselanzeige nicht sichtbar
func update_key_hud(key_type:Inventory.Item_Type, number_of_keys: int):
	if(key_type <= 2):
		var node = self.get_child(key_type)
		if number_of_keys >= 0 && number_of_keys <= 9:
			node.get_child(2).get_child(0).frame = number_of_keys
			var not_zero = number_of_keys > 0
			for i in 3:
				node.get_child(i).visible = not_zero
