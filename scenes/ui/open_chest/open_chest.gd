extends Control

signal checked()

func show_loot(looted_items: Array[ItemDefinition]):
	for item in looted_items:
		_show_item(item)

func _show_item(item: ItemDefinition):
	
	var sprite = TextureRect.new()
	sprite.texture = item.icon
	
	#var label = Label.new()
	#label.text = item.name
	$PanelContainer/VBoxContainer/ItemContainer.add_child(sprite)

func _on_button_pressed():
	checked.emit()
	hide()
	queue_free()
