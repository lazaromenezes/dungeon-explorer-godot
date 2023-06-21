extends RefCounted
class_name RollPhase

const NAME: String = "Rolagem da Dungeon"

signal completed
signal started(name: String)

var start_func: Callable
var _dungeon

func _init(dungeon):
	_dungeon = dungeon

func start():
	start_func.call()
	started.emit(NAME)

func check_completion():
	complete()
		
func complete():
	completed.emit()
