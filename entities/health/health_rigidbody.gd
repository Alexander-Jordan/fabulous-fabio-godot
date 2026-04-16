class_name HealthRigidbody extends RigidBody2D

#region VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collectable_2d: Collectable2D = $Collectable2D
@onready var spawnable_2d: Spawnable2D = $Spawnable2D
#endregion

#region FUNCTIONS
func _ready() -> void:
	collectable_2d.collected.connect(on_collected)
	GM.gravity_vector_changed.connect(on_gravity_vector_changed)
	spawnable_2d.despawned.connect(on_despawned)
	spawnable_2d.spawned.connect(on_spawned)

func on_collected() -> void:
	FTS.call_deferred('spawn', global_position, '100')
	SS.stats.score += 100
	spawnable_2d.despawn()

func on_gravity_vector_changed(gravity_vector: Vector2) -> void:
	animated_sprite_2d.flip_v = true if gravity_vector.y < 0 else false

func on_despawned(_new_position: Vector2) -> void:
	collectable_2d.disabled = true

func on_spawned(_spawn_point: Vector2) -> void:
	if spawnable_2d.data is Vector2:
		apply_central_impulse(spawnable_2d.data)
	await get_tree().create_timer(0.5).timeout
	collectable_2d.disabled = false
#endregion
