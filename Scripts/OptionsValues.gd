extends Node

enum PLATFORM {PC, CONSOLE}
enum DIFFICULTY {EASY=10, MEDIUM=5, HARD=1}

@export var platform:PLATFORM
@export var difficulty:DIFFICULTY = DIFFICULTY.EASY

func get_platform_as_string() -> String:
	return PLATFORM.keys()[platform]
