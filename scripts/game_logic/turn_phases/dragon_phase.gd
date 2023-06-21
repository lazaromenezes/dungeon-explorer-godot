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
		
	started.emit(NAME)
	
func check_completion():
	if _dungeon.dragon_awareness < 3:
		complete()
		
func complete():
	completed.emit()
