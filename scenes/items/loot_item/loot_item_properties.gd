extends Resource
class_name LootItemProperties

signal count_changed(count)

var count: int:
	set(value):
		count = value
		count_changed.emit(count)

