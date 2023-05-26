extends Panel

@export var message: String = ""
@export var yes_button: String = "Yes"
@export var no_button: String = "No"

signal confirmed_action()
signal cancelled_action()

func _ready():
	$Dialog/VBoxContainer/Label.text = message
	$Dialog/VBoxContainer/HBoxContainer/YesButton.text = yes_button
	$Dialog/VBoxContainer/HBoxContainer/NoButton.text = no_button
	
	$Dialog/VBoxContainer/HBoxContainer/YesButton.pressed.connect(_on_yes)
	$Dialog/VBoxContainer/HBoxContainer/NoButton.pressed.connect(_on_no)
	
func _on_yes():
	confirmed_action.emit()
	hide()
	
func _on_no():
	cancelled_action.emit()
	hide()
