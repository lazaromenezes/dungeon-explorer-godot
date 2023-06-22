extends RefCounted
class_name DragonPhase

const NAME: String = "Fase do Dragão"
	
signal completed
signal started(name: String)

var _dungeon

func _init(dungeon):
	_dungeon = dungeon

func start():
	if _dungeon.dragon_awareness >= 3:
		_dungeon.dragon.visible = true
		_dungeon.dragon.set_current_health(3)
		
	started.emit(NAME)
	
func check_completion():
	if _dungeon.dragon_awareness < 3:
		complete()
	elif not _dungeon.dragon.is_alive():
		complete()
		
func complete():
	if _dungeon.dragon_awareness >= 3:
		_dungeon.dragon_awareness = 0
		
	completed.emit()
