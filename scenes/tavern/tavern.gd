extends Node3D
class_name Tavern

const MAX_HIRELINGS: int = 7

var _available_hirelings: Array[HirelingStats]

func _ready():	
	$HUD/GoButton.disabled = true
	$HUD/GoButton.pressed.connect(_enter_dungeon)
	$HUD/HireButton.pressed.connect(_roll_hirelings)
	$HUD/BackButton.pressed.connect(_back_to_title)	
	
	for hireling in $Hirelings.get_children():
		_available_hirelings.append(hireling.stats)

func _roll_hirelings():
	for i in MAX_HIRELINGS:
		$Hirelings.get_children().pick_random().rolled.emit()

	$HUD/HireButton.disabled = true
	$HUD/GoButton.disabled = false

	Party.current_party = _available_hirelings
	
func _back_to_title():	
	get_tree().change_scene_to_file("res://scenes/title_window/main_menu.tscn")
	
func _enter_dungeon():
	get_tree().change_scene_to_file("res://scenes/dungeon/dungeon.tscn")
