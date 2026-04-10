class_name MysteryCrate extends Crate

var item_type: int = randi_range(0, 1)

func spawn_item(spawn_point: Vector2) -> void:
	if items_count <= 0:
		return
	
	var direction: Vector2 = Vector2(randf_range(-100, 100), randf_range(-300, -100) * -GM.gravity_vector.y)
	if item_type == 0:
		CS.call_deferred('spawn', spawn_point, direction)
	else:
		HS.call_deferred('spawn', spawn_point, direction)
	
	items_count -= 1
