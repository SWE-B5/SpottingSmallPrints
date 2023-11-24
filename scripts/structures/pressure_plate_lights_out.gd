extends Node2D
class_name PressurePlateLO

enum Mode {
	ACTIVATED,
	DEFAULT,
	PRESSED_ACTIVATED,
	PRESSED_DEFAULT
}

@onready var sprite = $Area2D/Sprite2D

@onready var ACTIVATED_PRESSURE_PLATE_TEXTURE = load("res://assets/lights_out/activated_pressure_plate.png")
@onready var DEFAULT_PRESSURE_PLATE_TEXTURE = load("res://assets/lights_out/default_pressure_plate.png")
@onready var ACTIVATE_ACTIVATED_PRESSURE_PLATE_TEXTURE = load("res://assets/lights_out/activated_activated_pressure_plate.png")
@onready var ACTIVATE_DEFAULT_PRESSURE_PLATE_TEXTURE = load("res://assets/lights_out/default_activated_pressure_plate.png")

var current_mode = Mode.DEFAULT

signal mode_manually_changed(new_mode)

func _on_area_2d_body_entered(body):
	if body is Player:
		if current_mode == Mode.DEFAULT:
			sprite.texture = ACTIVATE_DEFAULT_PRESSURE_PLATE_TEXTURE
			current_mode = Mode.PRESSED_DEFAULT
		elif current_mode == Mode.ACTIVATED:
			sprite.texture = ACTIVATE_ACTIVATED_PRESSURE_PLATE_TEXTURE
			current_mode = Mode.PRESSED_ACTIVATED

func _on_area_2d_body_exited(body):
	if body is Player:
		if current_mode == Mode.PRESSED_ACTIVATED:
			sprite.texture = DEFAULT_PRESSURE_PLATE_TEXTURE
			current_mode = Mode.DEFAULT
		elif current_mode == Mode.PRESSED_DEFAULT:
			sprite.texture = ACTIVATED_PRESSURE_PLATE_TEXTURE
			current_mode = Mode.ACTIVATED
		
		mode_manually_changed.emit(current_mode)

func toggle():
	if current_mode == Mode.ACTIVATED:
		sprite.texture = DEFAULT_PRESSURE_PLATE_TEXTURE
		current_mode = Mode.DEFAULT
	elif current_mode == Mode.DEFAULT:
		sprite.texture = ACTIVATED_PRESSURE_PLATE_TEXTURE
		current_mode = Mode.ACTIVATED
