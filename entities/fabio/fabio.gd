class_name Fabio extends CharacterBody2D

#region CONSTANTS
## Greatest fall speed.
const FALL_SPEED_MAX = 1200
const JUMP_FORCE_MAX = 1000
## Speed value to add every frame.
const RUN_SPEED_AMPLIFIER = 200
## Greatest running speed.
const RUN_SPEED_MAX = 100
#endregion

#region VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: float = 0.0:
	set(d):
		if d == direction:
			return
		direction = d
		if d != 0.0:
			animated_sprite_2d.flip_h = d < 0.0
var jump_force: float = 0.0
#endregion

#region FUNCTIONS
func _process(_delta: float) -> void:
	direction = Input.get_axis('left', 'right')
	
	if is_on_floor() and Input.is_action_just_pressed('jump'):
		print('test')
		jump_force = JUMP_FORCE_MAX
	if Input.is_action_just_released('jump'):
		jump_force = 0.0

func _physics_process(delta: float) -> void:
	if (direction > 0.0 and velocity.x < RUN_SPEED_MAX) or (direction < 0.0 and velocity.x > -RUN_SPEED_MAX):
		velocity.x += direction * RUN_SPEED_AMPLIFIER * delta
	if direction == 0.0:
		velocity.x -= signf(velocity.x) * RUN_SPEED_AMPLIFIER * delta
		if velocity.x < 0.01 and velocity.x > -0.01:
			velocity.x = 0.0
	
	if is_on_floor():
		if velocity.x != 0.0:
			if direction != 0.0 and signf(direction) != signf(velocity.x) and absf(velocity.x) > 0.1:
				animated_sprite_2d.animation = 'slide'
			else:
				animated_sprite_2d.animation = 'run'
				animated_sprite_2d.speed_scale = (absf(velocity.x) / RUN_SPEED_MAX) * 2.0
				animated_sprite_2d.speed_scale = clampf(animated_sprite_2d.speed_scale, 0.0, 2.0)
		else:
			animated_sprite_2d.animation = 'idle'
	
	velocity.y -= jump_force * delta
	if jump_force != 0.0:
		jump_force -= jump_force * delta
	if not is_on_floor() and velocity.y < FALL_SPEED_MAX and jump_force <= 0.0:
		velocity.y += get_gravity().y * delta
	
	move_and_slide()
#endregion
