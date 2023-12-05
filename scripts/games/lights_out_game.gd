extends Node2D
class_name LightsOutGame

@onready var plates = [$"0", $"1", $"2", $"3", $"4", $"5", $"6", $"7", $"8"]

signal finish()

func is_finished():
	var finished = true
	for plate in plates:
		if plate.current_mode != PressurePlateLO.Mode.ACTIVATED:
			finished = false
	print(finished)
	return finished

func block_all_changes():
	for plate in [$"0", $"1", $"2", $"3", $"4", $"5", $"6", $"7", $"8"]:
		plate.disable()

func check_game():
	if is_finished():
		block_all_changes()
		finish.emit()

func _on__change_mode0(new_mode):
	$"1".toggle()
	$"3".toggle()
	check_game()

func _on__change_mode1(new_mode):
	$"0".toggle()
	$"2".toggle()
	$"4".toggle()
	check_game()
	
func _on__change_mode2(new_mode):
	$"1".toggle()
	$"5".toggle()
	check_game()
	
func _on__change_mode3(new_mode):
	$"0".toggle()
	$"4".toggle()
	$"6".toggle()
	check_game()
	
func _on__change_mode4(new_mode):
	$"1".toggle()
	$"3".toggle()
	$"5".toggle()
	$"7".toggle()
	check_game()
	
func _on__change_mode5(new_mode):
	$"2".toggle()
	$"4".toggle()
	$"8".toggle()
	check_game()
	
func _on__change_mode6(new_mode):
	$"3".toggle()
	$"7".toggle()
	check_game()
	
func _on__change_mode7(new_mode):
	$"4".toggle()
	$"6".toggle()
	$"8".toggle()
	check_game()
	
func _on__change_mode8(new_mode):
	$"5".toggle()
	$"7".toggle()
	check_game()
