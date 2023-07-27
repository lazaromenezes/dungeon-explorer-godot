extends Control

@export var message: String = "":
	set(value):
		message = value
		_update_ui()
		
@export var ok_button: String = "OK":
	set(value):
		ok_button = value
		_update_ui()

signal confirmed()

func _ready():
	$Dialog/VBoxContainer/HBoxContainer/OkButton.pressed.connect(_on_ok_pressed)
	_update_ui()
	
func _on_ok_pressed():
	confirmed.emit()
	hide()

func _update_ui():
	$Dialog/VBoxContainer/Label.text = message
	$Dialog/VBoxContainer/HBoxContainer/OkButton.text = ok_button	
