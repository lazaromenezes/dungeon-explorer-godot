extends RefCounted
class_name RollPhase

const NAME: String = "Rolagem da Dungeon"

signal completed
signal started(name: String)

var _dungeon: DungeonState

func _init(dungeon: DungeonState):
	_dungeon = dungeon

func start():
	_dungeon.advance_level()
	
	for roll in _max_allowed_rolls():
		_dungeon.available_dungeon_items.pick_random().rolled.emit()
	
	started.emit(NAME)

func check_completion():
	complete()
		
func complete():
	completed.emit()
	
func _max_allowed_rolls():
	return min(_dungeon.level, GameConstants.MAX_ROLLS_ALLOWED - _dungeon.dragon_awareness)
