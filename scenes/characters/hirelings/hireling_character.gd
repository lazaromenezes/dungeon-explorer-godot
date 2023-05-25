extends Node3D
class_name Hireling

@export var hireling_stats: HirelingStats

signal hireling_selected(hireling_stats: Hireling)

func _ready():
	$StaticBody3D.input_event.connect(_handle_input)

func define_health(health_dict: Dictionary):
	if hireling_stats in health_dict.keys():
		_set_current_health(health_dict[hireling_stats])

func _set_current_health(health: int):
	hireling_stats.set_current_health(health)
	$HealthBar.call("set_progress_bar", hireling_stats.current_health)

func _handle_input(_camera: Node, event: InputEvent, _position: Vector3,
_normal: Vector3, _shape_idx: int):
	if event.is_action_pressed("select_item") and hireling_stats.current_health > 0:
		hireling_selected.emit(self)

func handle_selection(selected: Hireling):
	$Indicator.visible = selected == self

func attack(enemy: Enemy):
	if enemy.enemy_stats in hireling_stats.preferred_enemies:
		enemy.take_full_damage()
	else:
		enemy.take_damage()
	
	_take_damage()
	
func _take_damage():
	_set_current_health(hireling_stats.current_health - 1)
