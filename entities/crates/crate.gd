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

func animate_crate_bump(gravity_shifted: bool) -> void:
	var tween = create_tween()
	var final_val: float = 5 if gravity_shifted else -5
	tween.tween_property(animated_sprite_2d, 'position:y', final_val, 0.02)
	tween.tween_property(animated_sprite_2d, 'position:y', 0, 0.1)

func on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Fabio:
		return
	
	# super complicated way of determining if fabio is "below" the crate
	# depending on the up_direction of fabio (influenced by gravity direction)
	var gravity_shifted = body.up_direction.y > 0
	var fabio_below = global_position.y > body.global_position.y if gravity_shifted else global_position.y < body.global_position.y
	if !fabio_below:
		return
	
	AS.spawn(global_position, audio_bump)
	animate_crate_bump(gravity_shifted)
	var y_position: float = global_position.y + 10 if gravity_shifted else global_position.y - 10
	spawn_item(Vector2(global_position.x, y_position))

func spawn_item(spawn_point: Vector2) -> void:
	if items_count <= 0:
		return
	
	var direction: Vector2 = Vector2(randf_range(-100, 100), randf_range(-300, -100))
	CS.call_deferred('spawn', spawn_point, direction)
	
	items_count -= 1
#endregion
