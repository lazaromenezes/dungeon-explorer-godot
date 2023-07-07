extends Control

const HIRED_AVAILABLE_LABEL = "%d/%d"

var _available: int = 0
var _selected: int = 0

@onready var _hiredAvailableLabel = $PanelContainer/VBoxContainer/HiredAvailable

signal checked()

func _ready():
	for button in $PanelContainer/VBoxContainer/HirelingsContainer.get_children():
		button.pressed.connect(_on_hireling_selected)

func show_picker(amount: int):
	_available = amount
	_selected = 0
	_update()

func _on_button_pressed():
	checked.emit()
	hide()
	queue_free()

func _update():
	_hiredAvailableLabel.text = HIRED_AVAILABLE_LABEL % [_selected, _available]

func _on_hireling_selected():
	_selected += 1
	_update()
