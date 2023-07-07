extends Control
class_name ExplorationHud

const DUNGEON_LEVEL_LABEL: String = "Nível da Dungeon: %s"
const DRAGON_AWARENESS_LABEL: String = "Alerta de Dragão: %d"
const CURRENT_PHASE_LABEL: String = "Fase do Turno: %s"

const Alert = preload("res://scenes/ui/alert/alert.tscn")

func show_alert(message: String):
	var alert = Alert.instantiate()
	alert.visible = false
	alert.message = message
	add_child(alert)
	alert.show()
	await alert.confirmed
	alert.queue_free()

func ask_for_next_wave():
	$NextWaveDialog.show()

func show_game_over():
	$GameOverDialog.show()

func on_phase_started(phase_name: String):
	$CurrentPhase.text = CURRENT_PHASE_LABEL % phase_name
	
func on_level_changed(current_level: int):
	$DungeonLevelText.text = DUNGEON_LEVEL_LABEL % current_level

func on_dragon_alerted(dragon_awareness: int):
	$DragonAwereness.text = DRAGON_AWARENESS_LABEL % dragon_awareness
