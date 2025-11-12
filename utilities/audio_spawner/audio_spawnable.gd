class_name AudioSpawnable extends AudioStreamPlayer2D

#region VARIABLES
@onready var spawnable_2d: Spawnable2D = $Spawnable2D
#endregion

#region FUNCTIONS
func _ready() -> void:
	spawnable_2d.spawned.connect(on_spawned)
	spawnable_2d.spawn_callable_early = spawn_callable_early
	self.finished.connect(on_finished)

func on_finished() -> void:
	spawnable_2d.despawn()

func on_spawned(_spawn_point: Vector2) -> void:
	play()

func spawn_callable_early() -> void:
	if spawnable_2d.data is not AudioStream:
		return
	stream = spawnable_2d.data
#endregion
