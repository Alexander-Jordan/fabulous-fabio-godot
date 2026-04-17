class_name FinishArea extends Area2D

@export var audio_finished: AudioStream
@export var audio_music: AudioStream
@export var audio_points: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(on_body_entered)
	
	audio_stream_player.stream = audio_music
	audio_stream_player.volume_db = -12.0
	audio_stream_player.play()

func on_body_entered(body: Node2D) -> void:
	if body is Fabio:
		# award 100 points for every 10px the player jumped
		var from: Vector2 = Vector2(body.global_position.x, 0)
		var to: Vector2 = Vector2(global_position.x, 0)
		var distance: float = from.distance_to(to)
		var points: int = int(distance / 10) * 100
		if points > 0:
			SS.stats.score += points
			AS.spawn(global_position, audio_points)
			FTS.call_deferred('spawn', body.global_position, str(points))
		
		audio_stream_player.stream = audio_finished
		audio_stream_player.volume_db = 0.0
		audio_stream_player.play()
		
		body.finished = true
