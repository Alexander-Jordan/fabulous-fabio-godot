class_name Fabio extends CharacterBody2D

#region CONSTANTS
## Greatest fall speed.
const FALL_SPEED_MAX: int = 1200
## The force applied when jumping.
const JUMP_FORCE: int = 1800
## How long the player can increase their jump by holding down the jump button.
const JUMP_TIME: float = 0.25
## Speed value to add every frame.
const RUN_SPEED_AMPLIFIER: int = 600
## Greatest running speed.
const RUN_SPEED_MAX: int = 150
#endregion

#region VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var destructable_2d: Destructable2D = $Destructable2D
@onready var destructor_2d: Destructor2D = $Destructor2D
@onready var timer_stunned: Timer = $timer_stunned
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var animation: String = 'idle':
	set(a):
		if a == animation or !['crouch', 'die', 'idle', 'jump', 'run', 'slide'].has(a):
			return
		animation = a
		animated_sprite_2d.animation = a
var crouching: bool = false:
	set(c):
		if c == crouching:
			return
		crouching = c
		if c:
			direction = 0.0
var dead: bool = false
var direction: float = 0.0:
	set(d):
		if d == direction:
			return
		direction = d
		if d != 0.0:
			animated_sprite_2d.flip_h = d < 0.0
var finished: bool = false:
	set(f):
		if f == finished:
			return
		finished = f
		direction = 1.0
		crouching = false
var jump_time: float = 0.0
var stunned: bool = false:
	set(s):
		if s == stunned:
			return
		stunned = s
		var shader_material: ShaderMaterial = animated_sprite_2d.material
		shader_material.set_shader_parameter('stunned', s)
		if s:
			crouching = false
			direction = 0.0
			destructable_2d.process_mode = PROCESS_MODE_DISABLED
			destructor_2d.process_mode = PROCESS_MODE_DISABLED
			timer_stunned.start()
#endregion

#region FUNCTIONS
func _process(delta: float) -> void:
	if finished or dead:
		return
	
	if Input.is_action_pressed('down'):
		crouching = true
		return
	
	if Input.is_action_just_released('down') and is_on_floor():
		crouching = false
	
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
		if velocity.x < 10.0 and velocity.x > -10.0:
			velocity.x = 0.0
	
	if crouching:
		animation = 'crouch'
		if !is_on_floor() and velocity.y < FALL_SPEED_MAX:
			velocity.y += (get_gravity().y * 3) * delta
		var crouch_collision = move_and_collide(velocity * delta)
		if crouch_collision:
			on_crouch_collision(crouch_collision)
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
		animation = 'jump' if !stunned else 'die'
		if velocity.y < FALL_SPEED_MAX:
			velocity.y += get_gravity().y * delta
	
	move_and_slide()

func _ready() -> void:
	destructable_2d.destroyed.connect(on_destroyed)
	destructable_2d.destructed.connect(on_destructed)
	timer_stunned.timeout.connect(on_timer_stunned_timeout)
	visible_on_screen_notifier_2d.screen_exited.connect(on_screen_exited)

func on_crouch_collision(collision: KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	crouching = false
	if collider is Crate:
		collider.disabled = true

func on_destroyed() -> void:
	set_collision_mask_value(1, false)

func on_destructed(_amount: int, from: Vector2) -> void:
	stunned = true
	var from_direction: Vector2 = from.direction_to(global_position)
	velocity = Vector2(from_direction.x * 200, -200)
	jump_time = 0.0 # prevent jumping mid-stunned

func on_screen_exited() -> void:
	dead = true
	direction = 0.0
	await get_tree().create_timer(1.0).timeout
	process_mode = PROCESS_MODE_DISABLED

func on_timer_stunned_timeout() -> void:
	stunned = false
	destructor_2d.process_mode = PROCESS_MODE_INHERIT
	destructable_2d.process_mode = PROCESS_MODE_INHERIT
#endregion
