extends Node3D

const DUNGEON_LEVEL_LABEL: String = "Nível da Dungeon: %s"
const DRAGON_AWARENESS_LABEL: String = "Alerta de Dragão: %d"
const CURRENT_PHASE_LABEL: String = "Fase do Turno: %s"
const TURN_PHASES_PATH = "res://scripts/game_logic/turn_phases"

const DungeonState = preload("res://scripts/game_logic/dungeon_state.gd")
const RollPhase = preload("%s/roll_phase.gd" % TURN_PHASES_PATH)
const CombatPhase = preload("%s/combat_phase.gd" % TURN_PHASES_PATH)
const DragonPhase = preload("%s/dragon_phase.gd" % TURN_PHASES_PATH)
const RegroupPhase = preload("%s/regroup_phase.gd" % TURN_PHASES_PATH)

@export var rollable_hazards: Array[Enemy]

var _selected_hireling: Hireling
var _dungeon_state: DungeonState
var _turn_order: Array
var _current_phase = null

func _ready():
	_dungeon_state = DungeonState.new($Dragon)
	_dungeon_state.dragon_alerted.connect(_update_dragon_awareness)
	_dungeon_state.level_changed.connect(_update_level)
	
	var combat_phase = CombatPhase.new(_dungeon_state)
	
	var roll_phase = RollPhase.new(_dungeon_state)
	roll_phase.start_func = next_wave
	
	var dragon_phase = DragonPhase.new(_dungeon_state)
	
	var regroup_phase = RegroupPhase.new(_dungeon_state)
	regroup_phase.start_func = _regroup_phase_start
	
	_start_party()
	_start_dungeon()
	
	_turn_order = [roll_phase, combat_phase, dragon_phase, regroup_phase]
	
	for phase in _turn_order:
		phase.started.connect(_on_phase_started)
	
	_start_turn()

func _start_turn():
	for phase in _turn_order:
		_current_phase = phase
		phase.start()
		await phase.completed
		print_debug("PHASE COMPLETED")

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
	_dungeon_state.advance_level()
	
	_roll_hazards()

func _roll_hazards():
	var rolled : Array[Enemy] = []

	for i in range(_dungeon_state.max_allowed_rolls()):
		rolled.append(rollable_hazards.pick_random());

	var rolled_group: Dictionary = {}

	for enemy in rolled:
		var count = rolled.count(enemy)
		if count > 0:
			rolled_group[enemy] = count

	get_tree().call_group("enemies_group", "define_health", rolled_group)
	
	_dungeon_state.current_enemies = rolled_group.keys()

func _check_remaining_enemies():
	_current_phase.check_completion()

func _check_remaining_moves():
	var total_hirelings = 0
	
	for hireling in $Hirelings.get_children():
		total_hirelings += hireling.hireling_stats.current_health
		
	if total_hirelings == 0:
		$HUD/GameOver.show()

func _update_level(current_level: int):
	$HUD/DungeonLevelText.text = DUNGEON_LEVEL_LABEL % current_level

func _update_dragon_awareness(dragon_awareness: int):
	$HUD/DragonAwereness.text = DRAGON_AWARENESS_LABEL % dragon_awareness

func _regroup_phase_start():
	$HUD/NextWaveDialog.show()

func _on_phase_started(phase_name: String):
	$HUD/CurrentPhase.text = phase_name
	await get_tree().create_timer(0.5).timeout
	_current_phase.check_completion()

func _on_next_wave_confirmed():
	_current_phase.complete()
	_start_turn()

func _on_next_wave_cancelled():
	_current_phase.complete()
	_run_away()

func _run_away(): 
	get_tree().change_scene_to_file("res://scenes/tavern/tavern.tscn")
