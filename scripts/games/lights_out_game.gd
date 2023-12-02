extends Node2D
class_name LightsOutGame

func _process(delta):
	print(is_finished())

func is_finished():
	var finished = true
	for plate in [$"0", $"1", $"2", $"3", $"4", $"5", $"6", $"7", $"8"]:
		if plate.current_mode != PressurePlateLO.Mode.ACTIVATED:
			finished = false
	return finished
	

func _on__mode_manually_changed_0(new_mode):
	$"1".toggle()
	$"3".toggle()

func _on__mode_manually_changed_1(new_mode):
	$"0".toggle()
	$"2".toggle()
	$"4".toggle()

func _on__mode_manually_changed_2(new_mode):
	$"1".toggle()
	$"5".toggle()

func _on__mode_manually_changed_3(new_mode):
	$"0".toggle()
	$"4".toggle()
	$"6".toggle()
	
func _on__mode_manually_changed_4(new_mode):
	$"1".toggle()
	$"3".toggle()
	$"5".toggle()
	$"7".toggle()

func _on__mode_manually_changed_5(new_mode):
	$"2".toggle()
	$"4".toggle()
	$"8".toggle()

func _on__mode_manually_changed_6(new_mode):
	$"3".toggle()
	$"7".toggle()

func _on__mode_manually_changed_7(new_mode):
	$"4".toggle()
	$"6".toggle()
	$"8".toggle()

func _on__mode_manually_changed_8(new_mode):
	$"5".toggle()
	$"7".toggle()
