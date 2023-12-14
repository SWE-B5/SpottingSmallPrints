extends Node

# fyi: C:\Users\UserName\AppData\Roaming\Godot\app_userdata\Spotting Small Prints\spotting_small_prints.save
# Linux: /home/UserName/.local/share/godot/app_userdata/Spooting Small Prints/spotting_small_prints.save
# falls man löschen will oder sowas
# todo: bei end game auch löschen
const SAVE_PATH = SAVE_DIRECTORY + SAVE_FILE_NAME
const SAVE_DIRECTORY = "user://"
const SAVE_FILE_NAME = "spotting_small_prints.save"
const START_HP = 100

const DAMAGE_X = 1

const HUB_SPAWN = Vector2(0, 0)

const LEVEL_1_SPAWN = Vector2(0, 0)
const LEVEL_1_MAP_OFFSET = Vector2(0, 0)
const LEVEL_1_MAP_ZOOM = Vector2(0.5, 0.5)

const EASY_SPEED = 140
const MEDIUM_SPEED = 90
const HARD_SPEED = 60

#muss aktualisiert werden, wenn Level eingefügt werden
const LEVEL_PATHS = [HUB_PATH, LEVEL_1_PATH, LEVEL_2_PATH, LEVEL_3_PATH, LEVEL_4_PATH]
const HUB_PATH = "res://scenes/level/level_3.tscn"
const LEVEL_1_PATH = ""
const LEVEL_2_PATH = ""
const LEVEL_3_PATH = ""
const LEVEL_4_PATH = ""
