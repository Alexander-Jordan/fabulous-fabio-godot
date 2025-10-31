class_name Destructable2D
extends Area2D
## A simple component to make anything a destructable.

#region VARIABLES
## Amount of health before being being destroyed.
@export_range(1, 10) var health: int = 1 :
	set(h):
		if h == health and h < 0:
			return
		health = h
		health_changed.emit(h)
		if h == 0:
			destroyed.emit()
## The identifier for this collectable.
@export var identifier: String = ''

## To play audio when hit.
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
#endregion

#region SIGNALS
## Emitted when destroyed.
signal destroyed
## Emitted when destructed/hit.
signal destructed(amount: int, from: Vector2)
signal health_changed(health: int)
#endregion

#region FUNCTIONS
## Called by a destructor to make this destructable take damage.
func destruct(amount: int = health, from: Vector2 = Vector2.ZERO, audio_stream: AudioStream = null) -> void:
	health -= amount
	destructed.emit(amount, from)
	if audio_stream != null:
		audio_stream_player_2d.stream = audio_stream
		audio_stream_player_2d.play()
#endregion
