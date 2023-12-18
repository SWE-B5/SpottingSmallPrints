extends Area2D

var ACTIVE: bool
var ACTIVATION_TIME: float
var DEVIATION: float
var SPEED_FACTOR = 0.005 - (PlayerVariables.speed - 80) * 0.000075
const DEVIATION_FACTOR = 0.4
var RANDOMIZER = RandomNumberGenerator.new()

func _on_body_entered(body):
	randomize_timer()
	$Timer.start()

func _on_body_exited(body):
	ACTIVE = false
	$Timer.stop()

func _on_animation_player_animation_finished(anim_name):
	$AnimationPlayer.stop()
	if ACTIVE:
		randomize_timer()
		$Timer.start()

func _on_timer_timeout():
	ACTIVE = true
	$AnimationPlayer.play("flamethrower_trap")
	
func randomize_timer():
	ACTIVATION_TIME = PlayerVariables.speed * SPEED_FACTOR
	DEVIATION = ACTIVATION_TIME * DEVIATION_FACTOR
	$Timer.wait_time = ACTIVATION_TIME + RANDOMIZER.randf_range(0, DEVIATION)
