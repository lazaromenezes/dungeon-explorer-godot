extends Button

@export var available_hirelings: Array[HirelingStats]

const MAX_HIRELINGS: int = 7

func _ready():
	pressed.connect(_roll_hirelings)

func _roll_hirelings():
	
	var rolled: Array[HirelingStats] = []
	
	for i in range(MAX_HIRELINGS):
		rolled.append(available_hirelings.pick_random())
	
	var d: Dictionary = {}
	
	for h in available_hirelings:
		var c = rolled.count(h)
		if c > 0:
			d[h] = c
	
	get_tree().call_group("hirelings_group", "define_health", d)
