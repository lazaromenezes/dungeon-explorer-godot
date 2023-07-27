extends Button

signal chosen(hireling: HirelingStats)

@export var hireling_stats: HirelingStats

func _pressed():
	chosen.emit(hireling_stats)
