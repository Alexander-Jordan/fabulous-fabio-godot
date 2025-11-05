class_name CoinFloating extends Node2D

#region VARIABLES
@onready var collectable_2d: Collectable2D = $Collectable2D
@onready var spawnable_2d: Spawnable2D = $Spawnable2D
#endregion

#region FUNCTIONS
func _ready() -> void:
	collectable_2d.collected.connect(on_collected)
	spawnable_2d.is_spawned = true

func on_collected() -> void:
	spawnable_2d.despawn()
#endregion
