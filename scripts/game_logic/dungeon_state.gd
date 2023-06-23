extends RefCounted
class_name DungeonState

signal level_changed(level: int)

var current_enemies: Array[Enemy]
var available_dungeon_items: Array[RollableItem]
var dragon: Dragon

var level: int = 0:
	set(value):
		level = value
		level_changed.emit(level)

var dragon_awareness: int = 0:
	get:
		return dragon.awareness

func _init(dungeon_items: Array[RollableItem]):
	available_dungeon_items = dungeon_items
	
	for item in available_dungeon_items:
		item.rolled.connect(_on_item_rolled)
		if item is Dragon:
			dragon = item

func has_living_enemies():
	return current_enemies.filter(_remove_dragon).any(_is_alive)
	
func advance_level():
	level += 1
	
func _remove_dragon(e: Enemy):
	return not (e is Dragon)
	
func _is_alive(e: Enemy):
	return e.is_alive()
	
func _on_item_rolled(item: RollableItem):
	if item is Enemy:
		if item.stats.race == GameConstants.Race.DRAGON:
			dragon_awareness += 1
		
		if item not in current_enemies:
			current_enemies.append(item)

