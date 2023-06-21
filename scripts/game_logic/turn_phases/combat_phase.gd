extends RefCounted
class_name CombatPhase

const NAME: String = "Combate"

signal completed
signal started(name: String)

var _dungeon

func _init(dungeon):
	_dungeon = dungeon

func check_completion():
	if not _dungeon.has_living_enemies():
		complete()
		
func complete():
	completed.emit()
	
func start():
	started.emit(NAME)
