class_name ChangeDirectionTrigger extends Area2D

@export var suggested_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area is not DirectionHandler:
		return
	area.change_direction(suggested_direction)
