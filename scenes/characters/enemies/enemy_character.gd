extends Node3D

@export var enemy_stats: EnemyStats

func define_health(health_dict: Dictionary):
	if enemy_stats in health_dict.keys():
		enemy_stats.set_current_health(health_dict[enemy_stats])
		$HealthBar.call("set_progress_bar", enemy_stats.current_health)
		
		visible = enemy_stats.current_health > 0
