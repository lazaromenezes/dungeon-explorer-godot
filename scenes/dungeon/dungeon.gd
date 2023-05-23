extends Node3D

var hirelings: Array[HirelingStats]

func _ready():
	get_tree().call_group("hirelings_group", "define_health", Party.current_party)
