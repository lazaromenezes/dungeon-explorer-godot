extends Node3D
class_name Enemy

@export var enemy_stats: EnemyStats

signal enemy_selected(enemy_stats: Enemy)

func _ready():
	$StaticBody3D.input_event.connect(_handle_input)

func define_health(health_dict: Dictionary):
	if enemy_stats in health_dict.keys():
		_set_current_health(health_dict[enemy_stats])
		
func _handle_input(_camera: Node, event: InputEvent, _position: Vector3,
_normal: Vector3, _shape_idx: int):
	if event.is_action_pressed("select_item") and enemy_stats.current_health > 0:
		enemy_selected.emit(self)
		
func take_damage():
	_set_current_health(enemy_stats.current_health - 1)
	
func take_full_damage():
	_set_current_health(0)

func _set_current_health(health: int):
	enemy_stats.set_current_health(health)
	$HealthBar.call("set_progress_bar", health)
	visible = health > 0
