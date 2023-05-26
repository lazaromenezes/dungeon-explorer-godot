extends Node3D

const MAX_HAZARDS: int = 7
const DUNGEON_LEVEL_LABEL: String = "Nível da Dungeon: %s"

@export var dungeon_level = 0

var _selected_hireling: Hireling

func _ready():
	$HUD/RunAwayButton.pressed.connect(_run_away)
	
	_start_party()
	_start_dungeon()
	
	next_wave()
	
func _start_party():
	get_tree().call_group("hirelings_group", "define_health", Party.current_party)
	
	for hireling in $Hirelings.get_children():
		hireling.hireling_selected.connect(_select_hireling)
		
func _start_dungeon():
	for enemy in $Enemies.get_children():
		enemy.enemy_stats.current_health = 0
		enemy.enemy_selected.connect(_select_enemy)
	
func _select_hireling(selected_hireling: Hireling):
	_selected_hireling = selected_hireling
	_notify_hireling_group()
	
func _select_enemy(enemy: Enemy):
	if(_selected_hireling != null):
		_selected_hireling.attack(enemy)
		_unselect_current_hireling()
		_check_remaining_enemies()
	else:
		print("Choose attacker first")
		
func _unselect_current_hireling():
	_selected_hireling = null
	_notify_hireling_group()

func _notify_hireling_group():
	get_tree().call_group("hirelings_group", "handle_selection", _selected_hireling)

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

func _check_remaining_enemies():
	if $Enemies.get_children().all(func(enemy:Enemy): return not enemy.is_alive()):
		$HUD/NextWaveDialog.show()

func _update_hud():
	$HUD/DungeonLevelText.text = DUNGEON_LEVEL_LABEL % dungeon_level

func _on_next_wave_confirmed():
	next_wave()

func _on_next_wave_cancelled():
	_run_away()
	
func _run_away(): 
	get_tree().change_scene_to_file("res://scenes/tavern/tavern.tscn")
