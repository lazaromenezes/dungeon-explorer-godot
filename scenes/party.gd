extends Node

var current: Dictionary = {}

func sign_up(hireling: Hireling):
	var clazz = hireling.stats.character_class
	
	current[clazz] = current[clazz] + 1 if clazz in current else 1
