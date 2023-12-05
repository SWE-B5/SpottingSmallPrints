extends Node

#Falls mein Menü-Einblendungen über Spieler HUD noch sichbar ist, dann
#bei Menü-Aufruf Hud.queue_overlay() aufrufen
#wenn Menüfenster geschlossen wird, Hud.dequeue-overlay() aufrufen
#verschachtelbar wenn Menüfenster über Menüfenster
func queue_overlay():
	overlay_cnt += 1
	
func dequeue_overlay():
	overlay_cnt += -1
	
const HUB_NAME = "Level"
#HUD shown if equal to 0
static var overlay_cnt: int = 0
#true, when current scene is HUB
static var is_Hub
