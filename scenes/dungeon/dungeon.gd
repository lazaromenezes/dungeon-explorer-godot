extends Node3D

const MAX_HAZARDS: int = 7
const DUNGEON_LEVEL_LABEL: String = "Nível da Dungeon: %s"
const DRAGON_AWERENESS: String = "Alerta de Dragão: %d"

@export var rollable_hazards: Array[Enemy]

var _selected_hireling: Hireling

var _dungeon_state: DungeonState
var _combat_phase: CombatPhase

func _ready():
	_dungeon_state = DungeonState.new($Dragon)
	_dungeon_state.dragon_alerted.connect(_update_dragon_awareness)
	_dungeon_state.level_changed.connect(_update_level)
	
	_combat_phase = CombatPhase.new()
	_combat_phase.completed.connect(_combat_phase_completed)
	
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
	_combat_phase.check_completion(_dungeon_state) 

func _check_remaining_moves():
	var total_hirelings = 0
	
	for hireling in $Hirelings.get_children():
		total_hirelings += hireling.hireling_stats.current_health
		
	if total_hirelings == 0:
		$HUD/GameOver.show()

func _update_level(current_level: int):
	$HUD/DungeonLevelText.text = DUNGEON_LEVEL_LABEL % current_level
	
func _update_dragon_awareness(dragon_awareness: int):
	$HUD/DragonAwereness.text = DRAGON_AWERENESS % dragon_awareness
	
func _combat_phase_completed():
	$HUD/NextWaveDialog.show()

func _on_next_wave_confirmed():
	next_wave()

func _on_next_wave_cancelled():
	_run_away()

func _run_away(): 
	get_tree().change_scene_to_file("res://scenes/tavern/tavern.tscn")
	
class DungeonState extends RefCounted:
	const MAX_ROLLS: int = 7
	
	var _dragon_node: Enemy
	
	signal dragon_alerted(times: int)
	signal level_changed(level: int)
	
	var current_enemies: Array: 
		set(value):
			current_enemies = value
			if _dragon_node in current_enemies.map(func(e): return e as Enemy):
				dragon_awareness += 1
	
	var dragon_awareness: int = 0:
		set(value):
			dragon_awareness = value
			dragon_alerted.emit(dragon_awareness)
			
	var level: int = 0:
		set(value):
			level = value
			level_changed.emit(level)
	
	func _init(dragon_node: Node):
		_dragon_node = dragon_node
			
	func has_living_enemies():
		return current_enemies.any(func(e: Enemy): return e.is_alive())
		
	func max_allowed_rolls():
		return min(level, MAX_ROLLS) - dragon_awareness
		
	func advance_level():
		level += 1
	
class CombatPhase extends RefCounted:
	signal completed
	
	func check_completion(dungeon_state: DungeonState):
		
		if not dungeon_state.has_living_enemies():
			completed.emit()
			
	
#	func _check_remaining_moves():
#		var total_hirelings = 0
#
#		for hireling in $Hirelings.get_children():
#			total_hirelings += hireling.hireling_stats.current_health
#
#		if total_hirelings == 0:
#			$HUD/GameOver.show()
