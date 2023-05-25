extends Node3D

@export var hireling_stats: HirelingStats

signal hireling_selected(id: int)

func _ready():
	$StaticBody3D.input_event.connect(_handle_input)

func define_health(health_dict: Dictionary):
	if hireling_stats in health_dict.keys():
		hireling_stats.set_current_health(health_dict[hireling_stats])
		$HealthBar.call("set_progress_bar", hireling_stats.current_health)

func _handle_input(_camera: Node, event: InputEvent, _position: Vector3,
_normal: Vector3, _shape_idx: int):
	if event.is_action_pressed("select_hireling"):
		hireling_selected.emit(get_instance_id())

func handle_selection(selected_id: int):
	$Indicator.visible = selected_id == get_instance_id()
