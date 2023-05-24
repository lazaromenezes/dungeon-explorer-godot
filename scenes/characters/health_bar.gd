extends Node

@export var symbol: String = ""

func _ready():
	$Sprite3D.texture = $SubViewport.get_texture()

func set_progress_bar(current: int):
	$SubViewport/Label.text = ""
	
	for i in range(current):
		$SubViewport/Label.text += symbol
	
