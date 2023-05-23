extends Node3D

const MAX_HIRELINGS: int = 7

var _available_hirelings: Array[HirelingStats]

func _ready():	
	$HUD/GoButton.disabled = true
	$HUD/GoButton.pressed.connect(_enter_dungeon)
	$HUD/HireButton.pressed.connect(_roll_hirelings)
	$HUD/BackButton.pressed.connect(_back_to_title)	
	
	for hireling in $Hirelings.get_children():
		_available_hirelings.append(hireling.hireling_stats)

func _roll_hirelings():
	var rolled: Array[HirelingStats] = []

	for i in range(MAX_HIRELINGS):
		rolled.append(_available_hirelings.pick_random())

	var rolled_group: Dictionary = {}

	for hireling in _available_hirelings:
		var count = rolled.count(hireling)
		if count > 0:
			rolled_group[hireling] = count
			
	$HUD/HireButton.disabled = true
	$HUD/GoButton.disabled = false

	get_tree().call_group("hirelings_group", "define_health", rolled_group)
	Party.current_party = rolled_group
	
func _back_to_title():	
	get_tree().change_scene_to_file("res://scenes/title_window/main_menu.tscn")
	
func _enter_dungeon():
	get_tree().change_scene_to_file("res://scenes/dungeon/dungeon.tscn")
