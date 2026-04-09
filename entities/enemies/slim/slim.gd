class_name Slim extends CharacterBody2D

#region CONSTANTS
## Greatest fall speed.
const FALL_SPEED_MAX: int = 1200
const SPEED_AMPLIFIER: float = 2000.0
#endregion

#region VARIABLES
@onready var direction_handler: DirectionHandler = $DirectionHandler
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var destructable_2d: Destructable2D = $Destructable2D
@onready var destructor_2d: Destructor2D = $Destructor2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var visible_on_screen: bool = false
var dead: bool = false
#endregion

#regiond FUNCTIONS
func _ready() -> void:
	destructable_2d.destroyed.connect(on_destroyed)
	GM.gravity_vector_changed.connect(on_gravity_vector_changed)
	visible_on_screen_notifier_2d.screen_entered.connect(on_screen_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(on_screen_exited)

func _process(delta: float) -> void:
	if velocity.y < FALL_SPEED_MAX:
		velocity.y += get_gravity().y * delta
	
	if visible_on_screen and !dead:
		velocity.x = direction_handler.direction.x * SPEED_AMPLIFIER * delta
	
	move_and_slide()

func on_destroyed() -> void:
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)
	destructable_2d.process_mode = PROCESS_MODE_DISABLED
	destructor_2d.process_mode = PROCESS_MODE_DISABLED
	dead = true
	animated_sprite_2d.animation = 'dead'
	velocity = Vector2(direction_handler.direction.x * 100, 200) * -GM.gravity_vector
	await get_tree().create_timer(2.0).timeout
	process_mode = PROCESS_MODE_DISABLED

func on_gravity_vector_changed(_gravity_vector: Vector2) -> void:
	animated_sprite_2d.flip_v = !animated_sprite_2d.flip_v

func on_screen_entered() -> void:
	visible_on_screen = true

func on_screen_exited() -> void:
	visible_on_screen = false
#endregion
