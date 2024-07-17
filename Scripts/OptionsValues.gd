extends Node

enum PLATFORM {PC, CONSOLE}

@export var platform:PLATFORM

func get_platform_as_string() -> String:
	return PLATFORM.keys()[platform]
