class_name Camera extends Camera2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('left'):
		var tween = create_tween().set_parallel(true)
		tween.tween_property(self, 'drag_left_margin', -0.3, 1)
		tween.tween_property(self, 'drag_right_margin', 0.7, 1)
	if event.is_action_pressed('right'):
		var tween = create_tween().set_parallel(true)
		tween.tween_property(self, 'drag_left_margin', 0.7, 1)
		tween.tween_property(self, 'drag_right_margin', -0.3, 1)
