extends Resource
class_name EnemyStats

@export var current_health: int
@export var max_health: int

func set_current_health(new_health: int):
	if new_health > max_health:
		max_health = new_health
	
	current_health = new_health
