extends Control

signal checked()

func show_loot(looted_items):
	for item in looted_items:
		_show_item(item)

func _show_item(item):
	var label = Label.new()
	label.text = item
	$PanelContainer/VBoxContainer/ItemContainer.add_child(label)

func _on_button_pressed():
	checked.emit()
	hide()
	queue_free()
