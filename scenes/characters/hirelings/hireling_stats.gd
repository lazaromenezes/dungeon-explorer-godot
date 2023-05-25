extends Resource
class_name HirelingStats

@export var current_health: int
@export var max_health: int

@export var preferred_enemies: Array[EnemyStats]

func set_current_health(new_health: int):
	if new_health > max_health:
		max_health = new_health
	
	current_health = new_health

