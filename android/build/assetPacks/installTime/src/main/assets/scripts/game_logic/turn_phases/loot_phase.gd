extends RefCounted
class_name LootPhase

const NAME: String = "Saque"

signal completed
signal started(name: String)

var _dungeon: DungeonState

func _init(dungeon: DungeonState):
	_dungeon = dungeon

func check_completion():
	if not _dungeon.has_remaining_items():
		complete()
		
func complete():
	completed.emit()
	
func start():
	started.emit(NAME)
