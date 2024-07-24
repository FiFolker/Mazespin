extends Node

enum INPUT {KEYBOARD, CONTROLLER}
enum DIFFICULTY {EASY=10, MEDIUM=5, HARD=1}

var input:INPUT = INPUT.KEYBOARD
var difficulty:DIFFICULTY = DIFFICULTY.EASY

func get_input_as_string() -> String:
	return INPUT.keys()[input]

func _ready():
	if Input.get_connected_joypads().size() > 0:
		input = INPUT.CONTROLLER
