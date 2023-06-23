extends RefCounted
class_name DragonPhase

const NAME: String = "Fase do Dragão"
	
signal completed
signal started(name: String)

var _dungeon: DungeonState

func _init(dungeon: DungeonState):
	_dungeon = dungeon

func start():
	if _dungeon.dragon_awareness >= 3:
		_dungeon.dragon.summon()
		
	started.emit(NAME)
	
func check_completion():
	if _dungeon.dragon_awareness < 3:
		complete()
	elif not _dungeon.dragon.is_alive():
		complete()
		
func complete():
#	if _dungeon.dragon_awareness >= 3:
#		_dungeon.dragon_awareness = 0
		
	completed.emit()
