extends Sprite3D

func _ready():
	texture = $SubViewport.get_texture()

func set_progress_bar(current: int, max: int):
	$SubViewport/ProgressBar.min_value = 0
	$SubViewport/ProgressBar.max_value = max
	$SubViewport/ProgressBar.value = current
