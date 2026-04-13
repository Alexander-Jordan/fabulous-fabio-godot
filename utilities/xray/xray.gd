class_name XRay extends Sprite2D

@export var area_trigger_visible: Area2D
@export var target_node: Node2D
@export var target_offset: Vector2

func _process(_delta: float) -> void:
	global_position = target_node.global_position + target_offset

func _ready() -> void:
	area_trigger_visible.body_entered.connect(on_body_entered)
	area_trigger_visible.body_exited.connect(on_body_exited)
	if target_node.has_signal('died'):
		target_node.died.connect(on_target_died)
	if target_node.has_signal('respawned'):
		target_node.respawned.connect(on_target_respawned)

func on_body_entered(body: Node2D) -> void:
	if body == target_node:
		var alpha_tween = create_tween()
		var scale_tween = create_tween()
		alpha_tween.tween_property(material, 'shader_parameter/alpha_value', 1.0, 0.1)
		scale_tween.tween_property(material, 'shader_parameter/scale_value', 1.0, 0.2)

func on_body_exited(body: Node2D) -> void:
	if body == target_node:
		var alpha_tween = create_tween()
		var scale_tween = create_tween()
		alpha_tween.tween_property(material, 'shader_parameter/alpha_value', 0.0, 0.1)
		scale_tween.tween_property(material, 'shader_parameter/scale_value', 0.0, 0.2)

func on_target_died() -> void:
	process_mode = PROCESS_MODE_DISABLED

func on_target_respawned() -> void:
	process_mode = PROCESS_MODE_INHERIT
