class_name CheckpointSystem extends Node2D

var checkpoints: Array[Checkpoint] = []
var next_checkpoint_index: int = 0

func _ready() -> void:
	set_checkpoints_from_children()

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

func set_checkpoints_from_children() -> void:
	var children: Array[Node] = get_children()
	for index in children.size():
		var checkpoint: Checkpoint = children[index]
		if checkpoint is not Checkpoint:
			assert(false, 'Only Checkpoint nodes are allowed as children to Checkpoints node.')
			return
		checkpoint.triggered.connect(set_checkpoint)
		checkpoints.append(checkpoint)
