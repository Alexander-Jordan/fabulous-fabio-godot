class_name Camera extends Camera2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('left'):
		drag_left_margin = -0.3
		drag_right_margin = 0.7
	if event.is_action_pressed('right'):
		drag_left_margin = 0.7
		drag_right_margin = -0.3
