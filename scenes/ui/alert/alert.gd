extends Panel

@export var message: String = ""
@export var ok_button: String = "OK"

signal confirmed()

func _ready():
	$Dialog/VBoxContainer/Label.text = message
	$Dialog/VBoxContainer/HBoxContainer/OkButton.text = ok_button
	$Dialog/VBoxContainer/HBoxContainer/OkButton.pressed.connect(_on_ok_pressed)
	
func _on_ok_pressed():
	confirmed.emit()
	hide()
