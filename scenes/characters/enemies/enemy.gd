extends RollableItem
class_name Enemy

@export var stats: EnemyStats

signal selected(stats: Enemy)

func _ready():
	$StaticBody3D.input_event.connect(_handle_input)
	rolled.connect(_on_rolled)
	stats.health_changed.connect(_on_health_changed)
	stats.health_changed.connect($HealthBar.set_progress_bar)

func _on_rolled(_item):
	stats.current_health += 1

func _handle_input(_camera: Node, event: InputEvent, _position: Vector3,
_normal: Vector3, _shape_idx: int):
	if event.is_action_pressed("select_item") and stats.current_health > 0:
		selected.emit(self)
		
func take_damage():
	stats.current_health -= 1
	
func take_full_damage():
	stats.current_health = 0

func is_alive():
	return stats.current_health > 0
	
func _on_health_changed(health: int):
	visible = health > 0
