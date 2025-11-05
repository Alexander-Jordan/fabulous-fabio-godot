class_name StatsData extends Resource
## All game stats data.

#region VARIABLES
## How many times has the game been booted?
@export var game_booted_count: int = 0
## The health of the player.
@export var health: int = 1:
	set(h):
		if h < 0 or h == health:
			return
		
		health = h
		health_changed.emit(h)
## The total collected score.
@export var score: int = 0:
	set(s):
		if s < 0 or s == score:
			return
		
		score = s
		score_changed.emit(s)

signal health_changed(health: int)
signal score_changed(score: int)
#endregion
