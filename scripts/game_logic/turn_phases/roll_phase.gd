extends RefCounted
class_name RollPhase

const NAME: String = "Rolagem da Dungeon"

signal completed
signal started(name: String)

var _on_start: Callable
var _dungeon: DungeonState

func _init(dungeon: DungeonState, on_start: Callable):
	_dungeon = dungeon
	_on_start = on_start

func start():
	_on_start.call()
	started.emit(NAME)

func check_completion():
	complete()
		
func complete():
	completed.emit()
	
