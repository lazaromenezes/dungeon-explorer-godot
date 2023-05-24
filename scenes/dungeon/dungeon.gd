extends Node3D

const MAX_HAZARDS: int = 7
const DUNGEON_LEVEL_LABEL: String = "Nível da Dungeon: %s"

@export var dungeon_level = 0

func _ready():
	get_tree().call_group("hirelings_group", "define_health", Party.current_party)
	next_wave()
	
func next_wave():
	dungeon_level += 1
	_roll_hazards()
	_update_hud()
	
func _roll_hazards():
	var max_allowed_hazards = min(dungeon_level, MAX_HAZARDS);

	var rolled = [EnemyStats]

	for i in range(max_allowed_hazards):
		rolled.append($Enemies.get_children().pick_random().enemy_stats);

	var rolled_group: Dictionary = {}
	
	for enemy in rolled:
		var count = rolled.count(enemy)
		if count > 0:
			rolled_group[enemy] = count
			
	get_tree().call_group("enemies_group", "define_health", rolled_group)
	
func _update_hud():
	$HUD/DungeonLevelText.text = DUNGEON_LEVEL_LABEL % dungeon_level
