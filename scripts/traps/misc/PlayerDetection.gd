extends Area2D

var ACTIVE: bool
var ACTIVATION_TIME: float
var DEVIATION: float
const SPEED_FACTOR = 0.004
const DEVIATION_FACTOR = 0.5
var RANDOMIZER = RandomNumberGenerator.new()

func _on_body_entered(body):
	ACTIVATION_TIME = PlayerVariables.speed * SPEED_FACTOR
	DEVIATION = ACTIVATION_TIME * DEVIATION_FACTOR
	$Timer.wait_time = ACTIVATION_TIME + RANDOMIZER.randf_range(0, DEVIATION)
	$Timer.start()

func _on_body_exited(body):
	ACTIVE = false
	$Timer.stop()

func _on_animation_player_animation_finished(anim_name):
	if !ACTIVE:
		$AnimationPlayer.stop()
	if ACTIVE:
		$AnimationPlayer.play()

func _on_timer_timeout():
	ACTIVE = true
	$AnimationPlayer.play("flamethrower_trap")
