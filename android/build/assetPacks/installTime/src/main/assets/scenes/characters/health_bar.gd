extends Node
class_name HealthBar

@export var texture: AtlasTexture
@export_color_no_alpha var modulate
@onready var _separation: int = $SubViewport/HBoxContainer.get_theme_constant("separation")

func _ready():
	if modulate != null:
		$Sprite3D.modulate = modulate

func set_progress_bar(current: int):
	for image in $SubViewport/HBoxContainer.get_children():
		image.queue_free()
	
	for i in current:
		var image = TextureRect.new()
		image.texture = texture
		$SubViewport/HBoxContainer.add_child(image)
	
	var width = texture.region.size.x
	
	$SubViewport.size.x = current * (width + _separation)
