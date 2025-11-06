class_name Crate extends StaticBody2D

#region FUNCTIONS
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
#endregion

#region FUNCTIONS
func _ready() -> void:
	area_2d.body_entered.connect(on_area_2d_body_entered)

func animate_crate_bump() -> void:
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, 'position:y', -5, 0.02)
	tween.tween_property(animated_sprite_2d, 'position:y', 0, 0.1)

func on_area_2d_body_entered(body: Node2D) -> void:
	if body is Fabio:
		animate_crate_bump()
		spawn_item(Vector2(global_position.x, global_position.y - 10))

func spawn_item(spawn_point: Vector2) -> void:
	if items_count <= 0:
		return
	
	var direction: Vector2 = Vector2(randf_range(-100, 100), randf_range(-300, -100))
	CS.call_deferred('spawn', spawn_point, direction)
	
	items_count -= 1
#endregion
