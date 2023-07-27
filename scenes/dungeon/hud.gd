extends Control
class_name ExplorationHud

const DUNGEON_LEVEL_LABEL: String = "Nível da Dungeon: %s"
const DRAGON_AWARENESS_LABEL: String = "Alerta de Dragão: %d"
const CURRENT_PHASE_LABEL: String = "Fase do Turno: %s"

const IventoryButton = preload("res://scenes/ui/item_button/item_button.tscn")

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
	$Header/TopPanel/CurrentPhase.text = CURRENT_PHASE_LABEL % phase_name
	
func on_level_changed(current_level: int):
	$Header/TopPanel/DungeonLevelText.text = DUNGEON_LEVEL_LABEL % current_level

func on_dragon_alerted(dragon_awareness: int):
	$Header/TopPanel/DragonAwereness.text = DRAGON_AWARENESS_LABEL % dragon_awareness
	
func add_to_inventory(item):
	var button = IventoryButton.instantiate()
	button.item = item
	$Footer/BottomPanel.add_child(button)
