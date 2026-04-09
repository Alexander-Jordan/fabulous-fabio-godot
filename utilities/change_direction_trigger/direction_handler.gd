class_name DirectionHandler extends Area2D

var direction: Vector2 = Vector2(-1, 0):
	set(d):
		if d == direction:
			return
		direction = d
		direction_changed.emit(d)

signal direction_changed(direction: Vector2)

func change_direction() -> void:
	direction = -direction
