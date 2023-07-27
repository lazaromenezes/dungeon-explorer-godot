extends Button
class_name ItemButton

@export var item: ItemDefinition

func _ready():
	icon = item.icon
	tooltip_text = item.description
