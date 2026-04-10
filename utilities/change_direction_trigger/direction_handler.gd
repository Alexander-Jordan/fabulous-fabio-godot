class_name DirectionHandler extends Area2D

var direction: Vector2 = Vector2(-1, 0):
	set(d):
		if d == direction:
			return
		direction = d
		direction_changed.emit(d)

signal direction_changed(direction: Vector2)

func change_direction(suggested_direction: Vector2 = Vector2.ZERO) -> void:
	# default behavior: just mirror current direction
	if suggested_direction == Vector2.ZERO:
		direction = -direction.normalized()
		return
	
	direction = suggested_direction.normalized()
