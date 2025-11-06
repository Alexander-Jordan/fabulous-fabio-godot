class_name Menu extends Control

@onready var button_start: Button = $MarginContainer/VBoxContainer/VBoxContainer/button_start
@onready var button_quit: Button = $MarginContainer/VBoxContainer/VBoxContainer/button_quit

func _ready() -> void:
	button_start.pressed.connect(on_button_start_pressed)
	button_quit.pressed.connect(on_button_quit_pressed)
	SS.save_stats()

func on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/main/main.tscn")

func on_button_quit_pressed() -> void:
	get_tree().quit()
