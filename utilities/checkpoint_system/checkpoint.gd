class_name Checkpoint extends Area2D

signal triggered(checkpoint: Checkpoint)

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area is not CheckpointTrigger:
		return
	triggered.emit(self)
	area.last_checkpoint = self
