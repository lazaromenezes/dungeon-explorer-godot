extends Resource
class_name EnemyStats

signal health_changed(value: int)

@export var current_health: int:
	set(value):
		if value > max_health:
			max_health = value
	
		current_health = value
		health_changed.emit(value)
	
@export var max_health: int

@export var race: GameConstants.Race
