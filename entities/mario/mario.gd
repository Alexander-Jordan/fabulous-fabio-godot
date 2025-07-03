class_name Mario extends CharacterBody2D

#region CONSTANTS
## Greatest fall speed.
const FALL_SPEED_MAX = 1200
#endregion

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor() and velocity.y < FALL_SPEED_MAX:
		velocity.y += get_gravity().y * delta
	
	move_and_slide()
