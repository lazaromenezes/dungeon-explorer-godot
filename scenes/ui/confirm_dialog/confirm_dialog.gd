extends Panel

@export var message: String = ""
@export var confirm_button: String = "Confirm"
@export var cancel_button: String = "Cancel"

signal confirmed()
signal cancelled()

func _ready():
	$Dialog/VBoxContainer/Label.text = message
	$Dialog/VBoxContainer/HBoxContainer/ConfirmButton.text = confirm_button
	$Dialog/VBoxContainer/HBoxContainer/CancelButton.text = cancel_button
	
	$Dialog/VBoxContainer/HBoxContainer/ConfirmButton.pressed.connect(_on_confirm_pressed)
	$Dialog/VBoxContainer/HBoxContainer/CancelButton.pressed.connect(_on_cancel_pressed)
	
func _on_confirm_pressed():
	confirmed.emit()
	hide()
	
func _on_cancel_pressed():
	cancelled.emit()
	hide()
