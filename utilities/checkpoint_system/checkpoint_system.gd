class_name CheckpointSystem extends Node

var checkpoints: Array[Checkpoint] = []
var next_checkpoint_index: int = 0

func get_checkpoint() -> Checkpoint:
	if next_checkpoint_index == 0:
		return null
	return checkpoints.get(next_checkpoint_index - 1)

func set_checkpoint(new_checkpoint: Checkpoint) -> void:
	if next_checkpoint_index > checkpoints.size():
		return
	var new_index: int = checkpoints.find(new_checkpoint, next_checkpoint_index)
	if new_index == -1:
		return
	next_checkpoint_index = new_index + 1
