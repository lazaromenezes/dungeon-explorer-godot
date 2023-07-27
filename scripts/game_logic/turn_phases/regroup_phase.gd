extends RefCounted
class_name RegroupPhase

const NAME: String = "Reagrupar"

signal completed()
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
	pass
	
func complete():
	completed.emit()
