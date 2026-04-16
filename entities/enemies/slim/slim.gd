class_name Slim extends CharacterBody2D

#region CONSTANTS
## Greatest fall speed.
const FALL_SPEED_MAX: int = 1200
const SPEED_AMPLIFIER: float = 50.0
#endregion

#region VARIABLES
@export var path_follow: PathFollow2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var destructable_2d: Destructable2D = $Destructable2D
@onready var destructor_2d: Destructor2D = $Destructor2D

var direction: float = 1.0
var dead: bool = false
var next_patrol_point: Vector2
#endregion

#regiond FUNCTIONS
func _ready() -> void:
	destructable_2d.destroyed.connect(on_destroyed)

func _process(delta: float) -> void:
	if velocity.y < FALL_SPEED_MAX:
		velocity.y += get_gravity().y * delta
	move_and_slide()
	
	if dead:
		return
	
	if path_follow == null:
		return
	
	if path_follow.progress_ratio >= 1.0 or path_follow.progress_ratio <= 0.0:
		change_direction()
	path_follow.progress += direction * SPEED_AMPLIFIER * delta
	global_position = path_follow.global_position

func change_direction() -> void:
	direction = 1.0 if direction == -1.0 else -1.0

func on_destroyed() -> void:
	destructor_2d.process_mode = PROCESS_MODE_DISABLED
	dead = true
	animated_sprite_2d.animation = 'dead'
	velocity = Vector2(direction * 100, -200)
	await get_tree().create_timer(2.0).timeout
	process_mode = PROCESS_MODE_DISABLED
#endregion
