extends RollableItem
class_name Hireling

@export var stats: HirelingStats

signal selected(hireling: Hireling)

func _ready():
	$StaticBody3D.input_event.connect(_handle_input)
	rolled.connect(_on_rolled)
	
	stats.health_changed.connect($HealthBar.set_progress_bar)
	stats.condition_changed.connect(_on_condition_changed)
	
	if stats.character_class in Party.current:
		stats.current_health = Party.current[stats.character_class]

func _on_rolled(item):
	Party.sign_up(item)
	stats.current_health += 1

func _handle_input(_camera: Node, event: InputEvent, _position: Vector3,
_normal: Vector3, _shape_idx: int):
	if event.is_action_pressed("select_item") and _is_available():
		selected.emit(self)

func handle_selection(hireling: Hireling):
	$SelectedIndicator.visible = hireling == self

func attack(enemy: Enemy):
	if enemy.stats in stats.preferred_enemies:
		enemy.take_full_damage()
	else:
		enemy.take_damage()
	
	if enemy is Dragon:
		_exhaust()
	
	_take_damage()

func use(item: LootItem):
	item.use()
	
	_take_damage()

func _take_damage():
	stats.current_health -= 1

func _exhaust():
	stats.condition = GameConstants.Condition.EXHAUSTED

func rest():
	stats.condition = GameConstants.Condition.READY

func _is_available():
	return stats.current_health > 0 and stats.condition != GameConstants.Condition.EXHAUSTED

func _on_condition_changed(condition: GameConstants.Condition):
	match(condition):
		GameConstants.Condition.READY:
			$ExhaustedIndicator.visible = false
		GameConstants.Condition.EXHAUSTED:
			$ExhaustedIndicator.visible = true
