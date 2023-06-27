extends RefCounted
class_name CombatPhase

const NAME: String = "Combate"

signal completed
signal started(name: String)

var _dungeon: DungeonState

func _init(dungeon: DungeonState):
	_dungeon = dungeon

func check_completion():
	if not _dungeon.has_living_enemies():
		complete()
		
func complete():
	completed.emit()
	
func start():
	started.emit(NAME)
