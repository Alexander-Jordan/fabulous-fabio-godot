class_name Slim extends PathFollow2D

#region CONSTANTS
const SPEED_AMPLIFIER: float = 50.0
#endregion

#region VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $RigidBody2D/AnimatedSprite2D
@onready var destructable_2d: Destructable2D = $RigidBody2D/Destructable2D
@onready var rigid_body_2d: RigidBody2D = $RigidBody2D

var direction: float = 1.0
var dead: bool = false
var next_patrol_point: Vector2
#endregion

#regiond FUNCTIONS
func _ready() -> void:
	destructable_2d.destroyed.connect(on_destroyed)

func _process(delta: float) -> void:
	if !dead:
		progress += direction * SPEED_AMPLIFIER * delta
	if progress_ratio >= 1.0 or progress_ratio <= 0.0:
		change_direction()

func change_direction() -> void:
	direction = 1.0 if direction == -1.0 else -1.0

func on_destroyed() -> void:
	rigid_body_2d.set_collision_layer_value(1, false)
	rigid_body_2d.set_collision_mask_value(1, false)
	dead = true
	animated_sprite_2d.animation = 'dead'
	rigid_body_2d.apply_central_impulse(Vector2(direction * 100, -100))
	await get_tree().create_timer(2.0).timeout
	process_mode = PROCESS_MODE_DISABLED
#endregion
