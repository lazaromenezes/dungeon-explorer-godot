extends LootItem
class_name Chest

const OpenChest = preload("res://scenes/ui/open_chest/open_chest.tscn")

func _ready():
	super._ready()
	used.connect(_on_used)
	
func _on_used(amount: int):
	var open_chest = OpenChest.instantiate()
	get_tree().root.add_child(open_chest)
	open_chest.show_loot(amount)
	await open_chest.checked
	checked.emit()
