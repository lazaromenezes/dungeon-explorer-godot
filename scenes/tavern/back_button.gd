extends Button

func _ready():
	pressed.connect(_back_to_title)
	
func _back_to_title():
	get_tree().change_scene_to_file("res://scenes/title_window/main_menu.tscn")
