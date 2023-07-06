extends Control

signal checked()

func show_loot(item_count: int):
	for i in item_count:
		_show_loot()

func _show_loot():
	var label = Label.new()
	label.text = str(_loot())
	$PanelContainer/VBoxContainer/ItemContainer.add_child(label)

func _loot():
	return GameConstants.Item.keys().pick_random()

func _on_button_pressed():
	checked.emit()
	hide()
	queue_free()
