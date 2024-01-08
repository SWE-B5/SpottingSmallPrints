# fyi: C:\Users\UserName\AppData\Roaming\Godot\app_userdata\Spotting Small Prints\spotting_small_prints.save
# Linux: /home/UserName/.local/share/godot/app_userdata/Spooting Small Prints/spotting_small_prints.save
# falls man löschen will oder sowas
# todo: bei end game auch löschen
const SAVE_PATH = SAVE_DIRECTORY + SAVE_FILE_NAME
const SAVE_DIRECTORY = "user://"
const SAVE_FILE_NAME = "spotting_small_prints.save"
const CHEATS_SAFE_FILE_NAME = "cheat_settings.save"
const CHEATS_SAVE_PATH = SAVE_DIRECTORY + CHEATS_SAFE_FILE_NAME
const START_HP = 100

const DAMAGE_X = 1

const EASY_SPEED = 120
const MEDIUM_SPEED = 100
const HARD_SPEED = 80

const EASY_MAX_HEALTH = 6
const MEDIUM_MAX_HEALTH = 4
const HARD_MAX_HEALTH = 2

#muss aktualisiert werden, wenn Level eingefügt werden
const LEVEL_PATHS = [HUB_PATH, LEVEL_1_PATH, LEVEL_2_PATH, LEVEL_3_PATH, LEVEL_4_PATH]
const HUB_PATH = "res://scenes/level/hub.tscn"
const LEVEL_1_PATH = "res://scenes/level/level_1.tscn"
const LEVEL_2_PATH = "res://scenes/level/level_2.tscn"
const LEVEL_3_PATH = "res://scenes/level/level_3.tscn"
const LEVEL_4_PATH = "res://scenes/level/level_end.tscn"

const DEFAULT_ZOOM_NIVEAU = 5
const HEAD_ZOOM_NIVEAU = 10
const ZOOM_TICK = 0.01

const FADE_SPEED = 1

const SPEED_SKULL_EASY = 80
const SPEED_SKULL_MEDIUM = 100
const SPEED_SKULL_HARD = 100

const SPEED_SKELETON_EASY = 80
const SPEED_SKELETON_MEDIUM = 100
const SPEED_SKELETON_HARD = 100
