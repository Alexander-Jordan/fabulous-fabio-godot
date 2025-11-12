class_name Hud extends Control

@export var fabio: Fabio

@onready var label_score: Label = $MarginContainer/VBoxContainer/HBoxContainer/label_score
@onready var label_timer: Label = $MarginContainer/VBoxContainer/HBoxContainer2/label_timer
@onready var texturerect_health: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/texturerect_health
@onready var texturerect_health_2: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/texturerect_health2
@onready var texturerect_health_3: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/texturerect_health3
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
	SS.stats.score_changed.connect(on_score_changed)
	timer.timeout.connect(on_timer_timeout)
	
	timer.start()

func on_health_changed(health: int) -> void:
	texturerect_health.visible = health >= 1
	texturerect_health_2.visible = health >= 2
	texturerect_health_3.visible = health >= 3

func on_score_changed(score: int) -> void:
	label_score.text = '%07d' % score

func on_timer_timeout() -> void:
	fabio.destructable_2d.destruct(3)
