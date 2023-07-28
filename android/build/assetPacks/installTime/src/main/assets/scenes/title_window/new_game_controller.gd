extends Button

func _ready():
	pressed.connect(self._to_tavern)

func _to_tavern():
	get_tree().change_scene_to_file("res://scenes/tavern/tavern.tscn")
