extends RollableItem
class_name LootItem

@export var properties: LootItemProperties

signal selected(item: LootItem)

func _ready():
	$StaticBody3D.input_event.connect(_handle_input)
	rolled.connect(_on_rolled)
	properties.count_changed.connect(_on_count_changed)
	properties.count_changed.connect($HealthBar.set_progress_bar)

func _on_rolled(_item):
	properties.count += 1

func _handle_input(_camera: Node, event: InputEvent, _position: Vector3,
_normal: Vector3, _shape_idx: int):
	if event.is_action_pressed("select_item") and properties.count > 0:
		selected.emit(self)

func _on_count_changed(count: int):
	visible = count > 0
	
func use():
	if properties.count > 0:
		properties.count -= 1
		
func use_all():
	properties.count = 0
