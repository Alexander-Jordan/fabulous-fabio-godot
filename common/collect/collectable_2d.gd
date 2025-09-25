class_name Collectable2D
extends Area2D
## A simple component to make anything a collectable.

#region VARIABLES
## The audio stream to be played when this collectable is collected.
@export var audio_streams: Array[AudioStream] = []
@export var disabled: bool = false:
	set(d):
		if d == disabled:
			return
		disabled = d
		process_mode = ProcessMode.PROCESS_MODE_DISABLED if d else ProcessMode.PROCESS_MODE_INHERIT
## The identifier for this collectable.
@export var identifier: String = ''

## The collision shape for the collectable.
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#endregion

#region SIGNALS
## Emitted when the collectable has been collected.
signal collected
#endregion

#region FUNCTIONS
func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_DISABLED if disabled else ProcessMode.PROCESS_MODE_INHERIT

## To be called by a collector when this collectable is to be collected.
func collect() -> void:
	collected.emit()

## To be called by a collector that plays an audio when this collectable is collected.
func get_audio() -> AudioStream:
	if audio_streams.is_empty():
		return null
	return audio_streams.pick_random()

func get_next_audio(previous: AudioStream) -> AudioStream:
	if audio_streams.is_empty():
		return null
	var previous_index: int = audio_streams.find(previous)
	var next_index: int = previous_index + 1 if previous_index + 1 == audio_streams.size() - 1 else 0
	return audio_streams[next_index]
#endregion
