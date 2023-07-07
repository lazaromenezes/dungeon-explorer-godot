extends LootItem
class_name Chest

const OpenChest = preload("res://scenes/ui/open_chest/open_chest.tscn")

func _ready():
	super._ready()
	used.connect(_on_used)
	
func _on_used(amount: int):
	var looted_items = _draw_loot(amount)
	await _show_loot(looted_items)
	resolved.emit(looted_items)

func _draw_loot(amount: int):
	var looted_items = Array()
	
	for item in amount:
		var looted_item = GameConstants.Item.keys().pick_random()
		looted_items.append(looted_item)
	
	return looted_items

func _show_loot(looted_items):
	var open_chest = OpenChest.instantiate()
	get_tree().root.add_child(open_chest)
	open_chest.show_loot(looted_items)
	await open_chest.checked
