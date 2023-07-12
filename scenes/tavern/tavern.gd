extends Node3D
class_name Tavern

const MAX_HIRELINGS: int = 10

func _init():
	Party.current.clear()

func _ready():
	$HUD/GoButton.disabled = true
	$HUD/GoButton.pressed.connect(_enter_dungeon)
	$HUD/HireButton.pressed.connect(_roll_hirelings)
	$HUD/BackButton.pressed.connect(_back_to_title)

func _roll_hirelings():
	for i in MAX_HIRELINGS:
		$Hirelings.get_children().pick_random().notify_roll()

	$HUD/HireButton.disabled = true
	$HUD/GoButton.disabled = false

func _back_to_title():
	get_tree().change_scene_to_file("res://scenes/title_window/main_menu.tscn")
	
func _enter_dungeon():
	get_tree().change_scene_to_file("res://scenes/dungeon/dungeon.tscn")
