class_name Star extends Node2D

#region VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collectable_2d: Collectable2D = $Collectable2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var spawnable_2d: Spawnable2D = $Spawnable2D
#endregion

#region FUNCTIONS
func _ready() -> void:
	collectable_2d.collected.connect(on_collected)
	spawnable_2d.is_spawned = true
	GM.gravity_vector_changed.connect(on_gravity_vector_changed)

func on_collected() -> void:
	cpu_particles_2d.emitting = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(animated_sprite_2d, 'scale', Vector2(0, 0), 0.3)
	await tween.finished
	spawnable_2d.despawn()

func on_gravity_vector_changed(gravity_vector: Vector2) -> void:
	animated_sprite_2d.flip_v = true if gravity_vector.y < 0 else false
#endregion
