extends Sprite3D

func _ready():
	texture = $SubViewport.get_texture()

func set_progress_bar(current: int, max_value: int):
	$SubViewport/ProgressBar.min_value = 0
	$SubViewport/ProgressBar.max_value = max_value
	$SubViewport/ProgressBar.value = current
	
	$SubViewport/Label.text = "%d/%d" % [current, max_value]
