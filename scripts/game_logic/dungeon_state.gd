extends RefCounted
class_name DungeonState

const MAX_ROLLS: int = 7

var dragon: Enemy

signal dragon_alerted(times: int)
signal level_changed(level: int)

var current_enemies: Array: 
	set(value):
		current_enemies = value
		if dragon in current_enemies.map(func(e): return e as Enemy):
			dragon_awareness += 1

var dragon_awareness: int = 0:
	set(value):
		dragon_awareness = value
		dragon_alerted.emit(dragon_awareness)
		
var level: int = 0:
	set(value):
		level = value
		level_changed.emit(level)

func _init(dragon_node: Node):
	dragon = dragon_node
		
func has_living_enemies():
	return current_enemies.any(func(e: Enemy): return (e.is_alive() and e != dragon))
	
func max_allowed_rolls():
	return min(level, MAX_ROLLS) - dragon_awareness
	
func advance_level():
	level += 1
