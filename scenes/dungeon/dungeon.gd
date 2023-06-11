extends Node3D

const MAX_HAZARDS: int = 7
const DUNGEON_LEVEL_LABEL: String = "Nível da Dungeon: %s"
const DRAGON_AWERENESS: String = "Alerta de Dragão: %d"

@export var dungeon_level: int = 0
@export var rollable_hazards: Array[Enemy]

var _selected_hireling: Hireling
var _dragon_awereness: int = 0

func _ready():
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
		_check_remaining_moves()
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
	var max_allowed_hazards = min(dungeon_level, MAX_HAZARDS) - _dragon_awereness;

	var rolled : Array[EnemyStats] = []

	for i in range(max_allowed_hazards):
		rolled.append(rollable_hazards.pick_random().enemy_stats);

	var rolled_group: Dictionary = {}

	for hazard in rolled:
		var count = rolled.count(hazard)
		if count > 0:
			rolled_group[hazard] = count

	get_tree().call_group("enemies_group", "define_health", rolled_group)
	
	if $Dragon.enemy_stats in rolled_group:
		_dragon_awereness += rolled_group[$Dragon.enemy_stats]
		$HUD/DragonAwereness.text = DRAGON_AWERENESS % _dragon_awereness

func _check_remaining_enemies():
	if $Enemies.get_children().all(func(enemy:Enemy): return not enemy.is_alive()):
		$HUD/NextWaveDialog.show()

func _check_remaining_moves():
	var total_hirelings = 0
	
	for hireling in $Hirelings.get_children():
		total_hirelings += hireling.hireling_stats.current_health
		
	if total_hirelings == 0:
		$HUD/GameOver.show()

func _update_hud():
	$HUD/DungeonLevelText.text = DUNGEON_LEVEL_LABEL % dungeon_level

func _on_next_wave_confirmed():
	next_wave()

func _on_next_wave_cancelled():
	_run_away()

func _run_away(): 
	get_tree().change_scene_to_file("res://scenes/tavern/tavern.tscn")
