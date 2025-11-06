class_name FloatingText extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label
@onready var spawnable_2d: Spawnable2D = $Spawnable2D

func _ready() -> void:
	spawnable_2d.spawned.connect(on_spawned)
	spawnable_2d.spawn_callable_early = spawn_callable_early

func on_spawned(_spawn_point: Vector2) -> void:
	animation_player.play('float_label')

func spawn_callable_early() -> void:
	if spawnable_2d.data is not String:
		return
	label.text = spawnable_2d.data
