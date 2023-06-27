extends Node3D
class_name  RollableItem

signal rolled(item: RollableItem)

func notify_roll():
	rolled.emit(self)
