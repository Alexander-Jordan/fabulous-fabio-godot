class_name Star extends Node2D

#region VARIABLES
@export_enum('First:1', 'Second:2', 'Third:3') var star_order: int = 1
@export var particle_texture_default: Texture
@export var particle_texture_taken: Texture

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collectable_2d: Collectable2D = $Collectable2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var spawnable_2d: Spawnable2D = $Spawnable2D

var taken: bool = false:
	set(t):
		taken = t
		animated_sprite_2d.animation = 'taken' if t else 'default'
		cpu_particles_2d.texture = particle_texture_taken if taken else particle_texture_default
#endregion

#region FUNCTIONS
func _ready() -> void:
	collectable_2d.collected.connect(on_collected)
	GM.gravity_vector_changed.connect(on_gravity_vector_changed)
	spawnable_2d.is_spawned = true
	match star_order:
		1:
			taken = SS.stats.star_1
		2:
			taken = SS.stats.star_2
		3:
			taken = SS.stats.star_3

func on_collected() -> void:
	FTS.call_deferred('spawn', global_position, '200')
	SS.stats.score += 200
	
	cpu_particles_2d.emitting = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(animated_sprite_2d, 'scale', Vector2(0, 0), 0.3)
	
	await tween.finished
	
	match star_order:
		1:
			SS.stats.star_1 = true
		2:
			SS.stats.star_2 = true
		3:
			SS.stats.star_3 = true
	
	spawnable_2d.despawn()

func on_gravity_vector_changed(gravity_vector: Vector2) -> void:
	animated_sprite_2d.flip_v = true if gravity_vector.y < 0 else false
#endregion
