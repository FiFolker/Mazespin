extends Node

enum INPUT {PC, CONTROLLER}
enum DIFFICULTY {EASY=10, MEDIUM=5, HARD=1}

@export var input:INPUT
@export var difficulty:DIFFICULTY = DIFFICULTY.EASY

func get_input_as_string() -> String:
	return INPUT.keys()[input]
