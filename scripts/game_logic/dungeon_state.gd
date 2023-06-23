extends RefCounted
class_name DungeonState

const MAX_ROLLS: int = 7

signal dragon_alerted(times: int)
signal level_changed(level: int)

var current_enemies: Array: 
	set(value):
		current_enemies = value

var dragon_awareness: int = 0:
	set(value):
		dragon_awareness = value
		dragon_alerted.emit(dragon_awareness)

var available_dungeon_items: Array[RollableItem]

var level: int = 0:
	set(value):
		level = value
		level_changed.emit(level)

func _init(dungeon_items: Array[RollableItem]):
	available_dungeon_items = dungeon_items

func has_living_enemies():
	return current_enemies.filter(_remove_dragon).any(_is_alive)
	
func advance_level():
	level += 1
	
func _remove_dragon(e: Enemy):
	return e.enemy_stats.race != GameConstants.Race.DRAGON
	
func _is_alive(e: Enemy):
	return e.is_alive()
