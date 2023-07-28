extends LootItem
class_name Potion

const HirelingPicker = preload("res://scenes/ui/hireling_picker/hireling_picker.tscn")

func _ready():
	super._ready()
	used.connect(_on_used)
	
func _on_used(amount: int):
	await _show_picker(amount)

func _show_picker(amount):
	var hireling_picker = HirelingPicker.instantiate()
	get_tree().root.add_child(hireling_picker)
	hireling_picker.show_picker(amount)
	hireling_picker.finished.connect(_on_selection_finished)
	await hireling_picker.finished
	
func _on_selection_finished(selection):
	resolved.emit(selection)
