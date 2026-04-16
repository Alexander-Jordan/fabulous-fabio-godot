class_name Hud extends Control

@export var fabio: Fabio
@export var star_texture_empty: Texture
@export var star_texture_default: Texture
@export var star_texture_taken: Texture

@onready var label_score: Label = $MarginContainer/VBoxContainer/HBoxContainer/label_score
@onready var label_timer: Label = $MarginContainer/VBoxContainer/HBoxContainer2/label_timer
@onready var texturerect_health: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer2/texturerect_health
@onready var texturerect_health_2: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer2/texturerect_health2
@onready var texturerect_health_3: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer2/texturerect_health3
@onready var texturerect_star_1: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/texturerect_star1
@onready var texturerect_star_2: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/texturerect_star2
@onready var texturerect_star_3: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/texturerect_star3
@onready var timer: Timer = $Timer

func _process(_delta: float) -> void:
	if fabio == null or fabio.dead or timer.is_stopped():
		return
	
	if fabio.finished:
		SS.stats.score += int(timer.time_left) * 50
		timer.stop()
	
	label_timer.text = '%03d' % timer.time_left

func _ready() -> void:
	if fabio == null:
		return
	
	on_health_changed(fabio.destructable_2d.health)
	on_score_changed(SS.stats.score)
	
	fabio.destructable_2d.health_changed.connect(on_health_changed)
	setup_stars()
	SS.stats.score_changed.connect(on_score_changed)
	SS.stats.star_collected.connect(on_star_collected)
	timer.timeout.connect(on_timer_timeout)
	
	timer.start()

func on_health_changed(health: int) -> void:
	texturerect_health.visible = health >= 1
	texturerect_health_2.visible = health >= 2
	texturerect_health_3.visible = health >= 3

func on_score_changed(score: int) -> void:
	label_score.text = '%07d' % score

func on_star_collected(star: int) -> void:
	match star:
		1:
			texturerect_star_1.texture = star_texture_default
		2:
			texturerect_star_2.texture = star_texture_default
		3:
			texturerect_star_3.texture = star_texture_default

func on_timer_timeout() -> void:
	fabio.destructable_2d.destruct(3)

func setup_stars() -> void:
	texturerect_star_1.texture = star_texture_taken if SS.stats.star_1 else star_texture_empty
	texturerect_star_2.texture = star_texture_taken if SS.stats.star_2 else star_texture_empty
	texturerect_star_3.texture = star_texture_taken if SS.stats.star_3 else star_texture_empty
