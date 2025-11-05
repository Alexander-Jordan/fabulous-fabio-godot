class_name Spawnable2D extends Node2D
## A spawnable component.

#region VARIABLES
## The root node of this game node.
@export var root_node: Node2D = self

## Callable to run before despawning.
var despawn_callable_early: Callable = func(): pass
## Callable to run after despawning, but before the despawned signal is emitted.
var despawn_callable_late: Callable = func(): pass
## Optional extra data.
var data: Variant
## Has this spawnable been spawned?
var is_spawned: bool = false :
	set(s):
		if s == is_spawned:
			return
		is_spawned = s
## Callable to run before spawning.
var spawn_callable_early: Callable = func(): pass
## Callable to run after spawning, but before the spawned signal is emitted.
var spawn_callable_late: Callable = func(): pass
#endregion

#region SIGNALS
## Emitted when spawned.
signal spawned(spawn_point: Vector2)
## Emitted when despawned.
signal despawned(new_position: Vector2)
#endregion

#region FUNCTIONS
## Used to spawn the spawnable.
func spawn(spawn_point: Vector2 = Vector2.ZERO) -> void:
	if is_spawned:
		return
	
	spawn_callable_early.call()
	
	root_node.visible = true
	root_node.process_mode = ProcessMode.PROCESS_MODE_INHERIT
	root_node.position = spawn_point
	is_spawned = true
	
	spawn_callable_late.call()
	# emit signal AFTER late callback
	spawned.emit(spawn_point)

## Used to despawn/disable the spawnable.
func despawn(new_position: Vector2 = Vector2.ZERO) -> void:
	if !is_spawned:
		return
	
	despawn_callable_early.call()
	
	root_node.visible = false
	root_node.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	root_node.position = new_position
	is_spawned = false
	
	despawn_callable_late.call()
	# emit signal AFTER late callback
	despawned.emit(new_position)
#endregion
