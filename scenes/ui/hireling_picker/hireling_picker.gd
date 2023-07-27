extends Control

const HIRED_AVAILABLE_LABEL = "%d/%d"

var _available: int = 0
var _selected: int = 0: 
	set(value):
		_selected = value
		_update()

var _selection: Dictionary

@onready var _hiredAvailableLabel = $PanelContainer/VBoxContainer/HiredAvailable

signal finished(selection: Dictionary)

func _ready():
	for button in $PanelContainer/VBoxContainer/HirelingsContainer.get_children():
		button.chosen.connect(_on_hireling_chosen)

func show_picker(amount: int):
	_available = amount
	_selected = 0

func _on_button_pressed():
	finished.emit(_selection)
	hide()
	queue_free()

func _update():
	_hiredAvailableLabel.text = HIRED_AVAILABLE_LABEL % [_selected, _available]
	
	for button in $PanelContainer/VBoxContainer/HirelingsContainer.get_children():
		button.disabled = _selected == _available
	
	$PanelContainer/VBoxContainer/Button.disabled = _selected < _available

func _on_hireling_chosen(hireling: HirelingStats):	
	if hireling in _selection:
		_selection[hireling] += 1
	else:
		_selection[hireling] = 1
		
	_selected = _selection.values().reduce(_sum)

func _sum(total, additional):
	return total + additional
