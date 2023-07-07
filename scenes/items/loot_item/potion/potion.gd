extends LootItem
class_name Potion

func _ready():
	super._ready()
	used.connect(_on_used)
	
func _on_used(_amount: int):
	await get_tree().create_timer(0.5).timeout
	resolved.emit(null)
