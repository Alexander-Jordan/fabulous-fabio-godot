class_name StatsData extends Resource
## All game stats data.

#region VARIABLES
## How many times has the game been booted?
@export var game_booted_count: int = 0
## The health of the player.
@export var health: int = 1:
	set(h):
		if h == health:
			return
		
		health = h if h > 0 else 0
		health_changed.emit(health)
## The total collected score.
@export var score: int = 0:
	set(s):
		if s < 0 or s == score:
			return
		
		score = s
		score_changed.emit(s)
@export var star_1: bool = false:
	set(s1):
		star_1 = s1
		star_collected.emit(1)
@export var star_2: bool = false:
	set(s2):
		star_2 = s2
		star_collected.emit(2)
@export var star_3: bool = false:
	set(s3):
		star_3 = s3
		star_collected.emit(3)

signal health_changed(health: int)
signal score_changed(score: int)
signal star_collected(star: int)
#endregion
