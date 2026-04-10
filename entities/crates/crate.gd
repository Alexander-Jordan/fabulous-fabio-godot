class_name Crate extends StaticBody2D

#region FUNCTIONS
@export var audio_bump: AudioStream
@export var audio_crash: AudioStream

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var items_count: int = randi_range(1, 3)

var disabled: bool = false:
	set(d):
		if d == disabled:
			return
		for i in items_count:
			spawn_item(Vector2(global_position.x, global_position.y))
		disabled = d
		process_mode = ProcessMode.PROCESS_MODE_DISABLED if d else ProcessMode.PROCESS_MODE_INHERIT
		visible = !d
		AS.spawn(global_position, audio_crash)
#endregion

#region FUNCTIONS
func _ready() -> void:
	area_2d.body_entered.connect(on_area_2d_body_entered)
	GM.gravity_vector_changed.connect(on_gravity_vector_changed)

func animate_crate_bump() -> void:
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, 'position:y', 5 * -GM.gravity_vector.y, 0.02)
	tween.tween_property(animated_sprite_2d, 'position:y', 0, 0.1)

func on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Fabio:
		return
	
	# super complicated way of determining if fabio is "below" the crate
	# depending on the gravity vector
	var fabio_below = body.global_position.y * GM.gravity_vector.y > global_position.y * GM.gravity_vector.y
	if !fabio_below:
		return
	
	AS.spawn(global_position, audio_bump)
	animate_crate_bump()
	spawn_item(Vector2(global_position.x, global_position.y - (GM.gravity_vector.y * 10)))

func on_gravity_vector_changed(gravity_vector: Vector2) -> void:
	animated_sprite_2d.flip_v = true if gravity_vector.y < 0 else false

func spawn_item(spawn_point: Vector2) -> void:
	if items_count <= 0:
		return
	
	var direction: Vector2 = Vector2(randf_range(-100, 100), randf_range(300, 100) * -GM.gravity_vector.y)
	CS.call_deferred('spawn', spawn_point, direction)
	
	items_count -= 1
#endregion
