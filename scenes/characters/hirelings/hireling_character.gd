extends Node3D

@export var hireling_stats: HirelingStats

func define_health(health_dict: Dictionary):
	if hireling_stats in health_dict.keys():
		hireling_stats.set_current_health(health_dict[hireling_stats])
		$HealthBar.call("set_progress_bar", hireling_stats.current_health)
