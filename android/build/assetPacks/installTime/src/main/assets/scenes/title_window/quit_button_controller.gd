extends Button

func _ready():
	pressed.connect(_quit)

func _quit():
	get_tree().quit()
