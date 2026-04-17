class_name Destructor2D
extends Area2D
## A simple component to make anything a destructor.

#region VARIABLES
## The audio streams to choose from when hitting a destructable.
@export var audio_streams: Array[AudioStream] = []
## The amount of destruction.
@export_range(1, 10) var destruct_amount: int = 1
@export var destructable_identifiers: Array[String] = []

## The collision shape for the destructor.
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#endregion

#region SIGNALS
signal destructable_entered
signal destructable_exited
#endregion

#region FUNCTIONS
func _ready() -> void:
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)

func on_area_entered(area: Area2D) -> void:
	var destructable := get_destructable_from_area(area)
	if destructable is not Destructable2D:
		return
	destructable.destruct(destruct_amount, global_position, get_audio())
	destructable_entered.emit()

func on_area_exited(area: Area2D) -> void:
	if get_destructable_from_area(area) is not Destructable2D:
		return
	destructable_exited.emit()

func get_destructable_from_area(area: Area2D) -> Destructable2D:
	if area is not Destructable2D:
		return null
	if area.identifier not in destructable_identifiers:
		return null
	return area

func get_audio() -> AudioStream:
	if audio_streams.is_empty():
		return null
	return audio_streams.pick_random()
#endregion
