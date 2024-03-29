extends Node3D

signal current_phase_completed()

const TURN_PHASES_PATH = "res://scripts/game_logic/turn_phases"

const DungeonState = preload("res://scripts/game_logic/dungeon_state.gd")
const RollPhase = preload("%s/roll_phase.gd" % TURN_PHASES_PATH)
const CombatPhase = preload("%s/combat_phase.gd" % TURN_PHASES_PATH)
const LootPhase = preload("%s/loot_phase.gd" % TURN_PHASES_PATH)
const DragonPhase = preload("%s/dragon_phase.gd" % TURN_PHASES_PATH)
const RegroupPhase = preload("%s/regroup_phase.gd" % TURN_PHASES_PATH)

@export var rollable_items: Array[RollableItem]

var _selected_hireling: Hireling
var _dungeon_state: DungeonState
var _turn_order: Array
var _current_phase = null

func _ready():
	_initialize_state()
	_initialize_phases()
	_start_party()
	_start_enemies()
	_start_loot_items()
	_start_dragon()
	_start_turn()

func _initialize_state():
	_dungeon_state = DungeonState.new(rollable_items)
	_dungeon_state.level_changed.connect($ExplorationHUD.on_level_changed)

func _initialize_phases():
	var roll_phase = RollPhase.new(_dungeon_state)
	var combat_phase = CombatPhase.new(_dungeon_state)
	var loot_phase = LootPhase.new(_dungeon_state)
	var dragon_phase = DragonPhase.new(_dungeon_state)
	var regroup_phase = RegroupPhase.new(_dungeon_state, _regroup_phase_start)
	
	_turn_order = [roll_phase, combat_phase, loot_phase, dragon_phase, regroup_phase]
	
	for phase in _turn_order:
		phase.started.connect(_on_phase_started)
		phase.started.connect($ExplorationHUD.on_phase_started)
		phase.completed.connect(_on_phase_completed)

func _start_turn():
	for phase in _turn_order:
		_current_phase = phase
		_current_phase.start()
		await current_phase_completed

func _start_party():
	for hireling in $Hirelings.get_children():
		hireling.selected.connect(_on_hireling_selected)

func _start_enemies():
	for enemy in $Enemies.get_children():
		enemy.stats.current_health = 0
		enemy.selected.connect(_on_enemy_selected)
		
	$Dragon.alerted.connect($ExplorationHUD.on_dragon_alerted)

func _start_loot_items():
	for item in $Loot.get_children():
		item.properties.count = 0
		item.selected.connect(_on_loot_selected)
		
	$Loot/Chest.resolved.connect(_on_chest_resolved)
	$Loot/Potion.resolved.connect(_on_potion_resolved)

func _start_dragon():
	$Dragon.selected.connect(_on_dragon_selected)

func _on_hireling_selected(selected_hireling: Hireling):
	_selected_hireling = selected_hireling
	_notify_hireling_group()

func _on_enemy_selected(enemy: Enemy):
	if _selected_hireling != null:
		_selected_hireling.attack(enemy)
		_finish_hireling_action()
	else:
		$ExplorationHUD.show_alert("Escolha o aventureiro primeiro")

func _on_loot_selected(item: LootItem):
	if not _current_phase is LootPhase:
		$ExplorationHUD.show_alert("Aguarde a fase de saque")
		return

	if _selected_hireling != null:
		_selected_hireling.use(item)
		await item.resolved
		_finish_hireling_action()
	else:
		$ExplorationHUD.show_alert("Escolha o aventureiro primeiro")

func _on_dragon_selected(enemy: Enemy):
	if(_selected_hireling != null):
		_selected_hireling.attack(enemy)
		_finish_hireling_action()
	else:
		$ExplorationHUD.show_alert("Escolha o aventureiro primeiro")

func _finish_hireling_action():
	_unselect_current_hireling()
	_check_remaining_moves()
	_current_phase.check_completion()

func _unselect_current_hireling():
	_selected_hireling = null
	_notify_hireling_group()

func _notify_hireling_group():
	get_tree().call_group("hirelings_group", "handle_selection", _selected_hireling)

func _check_remaining_moves():
	var total_hirelings = 0
	
	for hireling in $Hirelings.get_children():
		total_hirelings += hireling.stats.current_health
		
	if total_hirelings == 0:
		$ExplorationHUD.show_game_over()

func _regroup_phase_start():
	get_tree().call_group("hirelings_group", "rest")
	$ExplorationHUD.ask_for_next_wave()

func _on_phase_started(_phase_name: String):
	await get_tree().create_timer(0.1).timeout
	_current_phase.check_completion()

func _on_phase_completed():
	current_phase_completed.emit()

func _on_next_wave_confirmed(): # next wave
	_current_phase.complete()
	_start_turn()

func _on_next_wave_cancelled(): # wave canceled
	_current_phase.complete()
	_on_run_away()

func _on_run_away(): # game over
	get_tree().change_scene_to_file("res://scenes/tavern/tavern.tscn")

func _on_chest_resolved(looted_items):
	for item in looted_items:
		$ExplorationHUD.add_to_inventory(item)

func _on_potion_resolved(selection: Dictionary):
	for hireling in $Hirelings.get_children():
		if hireling.stats in selection:
			hireling.heal(selection[hireling.stats])
