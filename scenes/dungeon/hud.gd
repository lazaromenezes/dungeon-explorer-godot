extends Control
class_name ExplorationHud

const DUNGEON_LEVEL_LABEL: String = "Nível da Dungeon: %s"
const DRAGON_AWARENESS_LABEL: String = "Alerta de Dragão: %d"
const CURRENT_PHASE_LABEL: String = "Fase do Turno: %s"

func show_alert(message: String):
	$Alert.visible = false
	$Alert.message = message
	$Alert.show()
	await $Alert.confirmed
	$Alert.hide()

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
