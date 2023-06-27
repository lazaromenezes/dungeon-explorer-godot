extends Enemy
class_name Dragon

signal alerted(awareness: int)

var awareness: int = 0:
	set(value):
		awareness = value
		alerted.emit(value)

func _on_rolled(_item):
	awareness += 1
	
	if awareness >= 3:
		stats.current_health = 3

func _handle_input(_camera: Node, event: InputEvent, _position: Vector3,
_normal: Vector3, _shape_idx: int):
	if event.is_action_pressed("select_item") and stats.current_health > 0:
		selected.emit(self)
		
func take_damage():
	stats.current_health -= 1
	
func take_full_damage():
	stats.current_health = 0
	awareness = 0

func is_alive():
	return stats.current_health > 0
	
func _on_health_changed(health: int):
	if health == 0:
		visible = false
		awareness = 0

func summon():
	visible = true
