extends Resource
class_name HirelingStats

signal health_changed(value: int)
signal condition_changed(condition: GameConstants.Condition)

@export var preferred_enemies: Array[EnemyStats]
@export var preferred_items: Array[LootItemProperties]

@export var current_health: int:
	set(value):
		if value > max_health:
			max_health = value
	
		current_health = value
		health_changed.emit(value)
	
@export var max_health: int

@export var character_class: GameConstants.Class

@export var condition: GameConstants.Condition:
	set(value):
		if value != condition:
			condition = value
			condition_changed.emit(value)
