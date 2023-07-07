extends LootItem
class_name Potion

const HirelingPicker = preload("res://scenes/ui/hireling_picker/hireling_picker.tscn")

func _ready():
	super._ready()
	used.connect(_on_used)
	
func _on_used(amount: int):
	await _show_picker(amount)
	resolved.emit(null)

func _show_picker(amount):
	var hireling_picker = HirelingPicker.instantiate()
	get_tree().root.add_child(hireling_picker)
	hireling_picker.show_picker(amount)
	await hireling_picker.checked
