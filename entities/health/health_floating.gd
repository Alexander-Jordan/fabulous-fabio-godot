class_name HealthFloating extends Node2D

#region VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collectable_2d: Collectable2D = $Collectable2D
@onready var spawnable_2d: Spawnable2D = $Spawnable2D
#endregion

#region FUNCTIONS
func _ready() -> void:
	collectable_2d.collected.connect(on_collected)
	spawnable_2d.is_spawned = true
	GM.gravity_vector_changed.connect(on_gravity_vector_changed)

func on_gravity_vector_changed(gravity_vector: Vector2) -> void:
	animated_sprite_2d.flip_v = true if gravity_vector.y < 0 else false

func on_collected() -> void:
	spawnable_2d.despawn()
#endregion
