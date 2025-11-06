class_name FinishArea extends Area2D

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body is Fabio:
		# award 100 points for every 10px the player jumped
		var distance: float = body.global_position.distance_to(global_position)
		var points: int = int(distance / 10) * 100
		SS.stats.score += points
		FTS.spawn(body.global_position, str(points))
		
		body.finished = true
