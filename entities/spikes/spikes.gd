class_name Spikes extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var destructor_2d: Destructor2D = $Destructor2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	destructor_2d.destructable_entered.connect(on_destructable_entered)
	destructor_2d.destructable_exited.connect(on_destructable_exited)
	timer.timeout.connect(on_timeout)

func on_destructable_entered() -> void:
	timer.stop()
	animated_sprite_2d.play('up')

func on_destructable_exited() -> void:
	timer.start()

func on_timeout() -> void:
	animated_sprite_2d.play('down')
