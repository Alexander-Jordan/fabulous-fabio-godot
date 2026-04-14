class_name Checkpoints extends Node2D

func _ready() -> void:
	add_checkpoints_to_system_from_children()

func add_checkpoints_to_system_from_children() -> void:
	var children: Array[Node] = get_children()
	for index in children.size():
		var checkpoint: Checkpoint = children[index]
		if checkpoint is not Checkpoint:
			assert(false, 'Only Checkpoint nodes are allowed as children to Checkpoints node.')
			return
		checkpoint.triggered.connect(CPS.set_checkpoint)
		CPS.checkpoints.append(checkpoint)
