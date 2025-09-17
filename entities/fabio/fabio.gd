class_name Fabio extends CharacterBody2D

#region CONSTANTS
## Greatest fall speed.
const FALL_SPEED_MAX = 1200
## The force applied when jumping.
const JUMP_FORCE = 1800
## How long the player can increase their jump by holding down the jump button.
const JUMP_TIME: float = 0.25
## Speed value to add every frame.
const RUN_SPEED_AMPLIFIER = 600
## Greatest running speed.
const RUN_SPEED_MAX = 150
#endregion

#region VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var animation: String = 'idle':
	set(a):
		if a == animation or !['crouch', 'die', 'idle', 'jump', 'run', 'slide'].has(a):
			return
		animation = a
		animated_sprite_2d.animation = a
var crouching: bool = false
var direction: float = 0.0:
	set(d):
		if d == direction:
			return
		direction = d
		if d != 0.0:
			animated_sprite_2d.flip_h = d < 0.0
var jump_time: float = 0.0
#endregion

#region FUNCTIONS
func _process(delta: float) -> void:
	crouching = Input.is_action_pressed('down')
	if crouching:
		direction = 0.0
		return
	
	direction = Input.get_axis('left', 'right')
	
	# initial jump force, applied only when grounded:
	if is_on_floor() and Input.is_action_just_pressed('jump'):
		velocity.y -= JUMP_FORCE * delta
		jump_time = JUMP_TIME
	# jump force applied every frame as long as the jump button is held down:
	if Input.is_action_pressed('jump') and jump_time > 0:
		velocity.y -= JUMP_FORCE * delta
		jump_time -= delta
	# kill jump time when the jump button is released:
	if Input.is_action_just_released('jump'):
		jump_time = 0.0

func _physics_process(delta: float) -> void:
	if !crouching and (direction > 0.0 and velocity.x < RUN_SPEED_MAX) or (direction < 0.0 and velocity.x > -RUN_SPEED_MAX):
		velocity.x += direction * RUN_SPEED_AMPLIFIER * delta
	if direction == 0.0:
		velocity.x -= signf(velocity.x) * RUN_SPEED_AMPLIFIER * delta
		if velocity.x < 0.01 and velocity.x > -0.01:
			velocity.x = 0.0
	
	if crouching:
		animation = 'crouch'
		if !is_on_floor() and velocity.y < FALL_SPEED_MAX:
			velocity.y += (get_gravity().y * 3) * delta
		move_and_slide()
		return
	
	if is_on_floor():
		if velocity.x != 0.0:
			if direction != 0.0 and signf(direction) != signf(velocity.x):
				animation = 'slide'
			else:
				animation = 'run'
		else:
			animation = 'idle'
	else:
		animation = 'jump'
		if velocity.y < FALL_SPEED_MAX:
			velocity.y += get_gravity().y * delta
	
	move_and_slide()
#endregion
