extends RefCounted
class_name RegroupPhase

const NAME: String = "Fase de Reagrupar"

signal completed()
signal started(name: String)

var start_func: Callable
var _dungeon

func _init(dungeon):
	_dungeon = dungeon

func start():
	start_func.call()
	started.emit(NAME)
	
func check_completion():
	pass
	
func complete():
	completed.emit()
