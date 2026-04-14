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
@export var audio_jump: AudioStream

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var checkpoint_trigger: CheckpointTrigger = $CheckpointTrigger
@onready var collector_2d: Collector2D = $Collector2D
@onready var destructable_2d: Destructable2D = $Destructable2D
@onready var destructor_2d_bottom: Destructor2D = $destructor2d_bottom
@onready var destructor_2d_top: Destructor2D = $destructor2d_top
@onready var timer_stunned: Timer = $timer_stunned

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
		await get_tree().create_timer(3.0).timeout
		load_menu()
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
			destructor_2d_bottom.process_mode = PROCESS_MODE_DISABLED
			destructor_2d_top.process_mode = PROCESS_MODE_DISABLED
			timer_stunned.start()
#endregion

#region SIGNALS
signal died
signal respawned
#endregion

#region FUNCTIONS
func _process(_delta: float) -> void:
	if finished or dead:
		return
	
	if Input.is_action_pressed('down'):
		crouching = true
		return
	
	if Input.is_action_just_released('down') and is_on_floor():
		crouching = false
	
	direction = Input.get_axis('left', 'right')

func _physics_process(delta: float) -> void:
	if direction != 0.0 and !crouching:
		velocity.x += direction * RUN_SPEED_AMPLIFIER * delta
		velocity.x = clampf(velocity.x, -RUN_SPEED_MAX, RUN_SPEED_MAX)
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
		# initial jump force, applied only when grounded:
		if Input.is_action_just_pressed('jump'):
			audio_stream_player_2d.stream = audio_jump
			audio_stream_player_2d.play()
			velocity.y += (up_direction.y * JUMP_FORCE) * delta
			jump_time = JUMP_TIME
	else:
		animation = 'jump' if !stunned else 'die'
	
	# always apply gravity force (for now at least)
	if velocity.y < FALL_SPEED_MAX:
		velocity.y += get_gravity().y * delta
	
	# jump force applied every frame as long as the jump button is held down:
	if Input.is_action_pressed('jump') and jump_time > 0:
		velocity.y += (up_direction.y * JUMP_FORCE) * delta
		jump_time -= delta
	# kill jump time when the jump button is released:
	if Input.is_action_just_released('jump'):
		jump_time = 0.0
	
	move_and_slide()

func _ready() -> void:
	collector_2d.collected.connect(on_collected)
	destructable_2d.destroyed.connect(on_destroyed)
	destructable_2d.destructed.connect(on_destructed)
	GM.gravity_vector_changed.connect(on_gravity_vector_changed)
	timer_stunned.timeout.connect(on_timer_stunned_timeout)
	
	if SS.stats.health < 1:
		SS.stats.health = destructable_2d.health

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('gravity') and is_on_floor() and !finished:
		GM.gravity_vector = -GM.gravity_vector
	if event.is_action_pressed('dev_checkpoint_1'):
		teleport_to_position(CPS.checkpoints[0].global_position)
	if event.is_action_pressed('dev_checkpoint_2'):
		teleport_to_position(CPS.checkpoints[1].global_position)
	if event.is_action_pressed('dev_checkpoint_3'):
		teleport_to_position(CPS.checkpoints[2].global_position)
	if event.is_action_pressed('dev_checkpoint_4'):
		teleport_to_position(CPS.checkpoints[3].global_position)

func load_menu() -> void:
	CS.despawn_all()
	HS.despawn_all()
	FTS.despawn_all()
	CPS.checkpoints.clear()
	get_tree().change_scene_to_file("res://stages/menu/menu.tscn")

func on_collected(collectable: Collectable2D) -> void:
	if collectable.identifier == 'health':
		if destructable_2d.health < 3:
			destructable_2d.health += 1
			SS.stats.health += 1
		FTS.call_deferred('spawn', global_position, '100')
		SS.stats.score += 100
	if collectable.identifier == 'coin':
		FTS.call_deferred('spawn', global_position, '100')
		SS.stats.score += 100

func on_crouch_collision(collision: KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	crouching = false
	if collider is Crate:
		collider.disabled = true

func on_destroyed() -> void:
	set_collision_mask_value(1, false)
	dead = true
	direction = 0.0
	collector_2d.process_mode = PROCESS_MODE_DISABLED
	died.emit()
	await get_tree().create_timer(1.0).timeout
	respawn()

func on_destructed(amount: int, from: Vector2) -> void:
	SS.stats.health -= amount
	stunned = true
	var from_direction: Vector2 = from.direction_to(global_position)
	velocity = Vector2(from_direction.x * 200, 200) * -GM.gravity_vector
	jump_time = 0.0 # prevent jumping mid-stunned

func on_gravity_vector_changed(gravity_vector: Vector2) -> void:
	up_direction = -gravity_vector
	animated_sprite_2d.flip_v = !animated_sprite_2d.flip_v
	if up_direction.y > 0:
		destructor_2d_top.process_mode = PROCESS_MODE_INHERIT
		destructor_2d_bottom.process_mode = PROCESS_MODE_DISABLED
	else:
		destructor_2d_top.process_mode = PROCESS_MODE_DISABLED
		destructor_2d_bottom.process_mode = PROCESS_MODE_INHERIT

func on_timer_stunned_timeout() -> void:
	stunned = false
	destructor_2d_bottom.process_mode = PROCESS_MODE_INHERIT
	destructor_2d_top.process_mode = PROCESS_MODE_INHERIT
	destructable_2d.process_mode = PROCESS_MODE_INHERIT

func respawn() -> void:
	teleport_to_position(checkpoint_trigger.last_checkpoint.global_position)
	dead = false
	destructable_2d.health = 1
	SS.stats.health = 1
	set_collision_mask_value(1, true)
	collector_2d.process_mode = PROCESS_MODE_INHERIT
	respawned.emit()

func teleport_to_position(position: Vector2) -> void:
	velocity = Vector2.ZERO
	GM.gravity_vector = Vector2.DOWN # reset gravity
	global_position = position
#endregion
