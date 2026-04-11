class_name GameManager extends Node

@onready var world_space_rid: RID = get_viewport().find_world_2d().space
@onready var gravity_vector: Vector2 = PhysicsServer2D.area_get_param(world_space_rid, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR):
	set(gv):
		if gv == gravity_vector:
			return
		gravity_vector = gv
		PhysicsServer2D.area_set_param(world_space_rid, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, gravity_vector)
		gravity_vector_changed.emit(gv)

signal gravity_vector_changed(gravity_vector: Vector2)
