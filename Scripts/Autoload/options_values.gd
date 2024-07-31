extends Node

enum INPUT {KEYBOARD, CONTROLLER}
enum DIFFICULTY {EASY=10, NORMAL=5, HARD=1}

var input:INPUT = INPUT.KEYBOARD
var difficulty:DIFFICULTY = DIFFICULTY.NORMAL

func get_input_as_string() -> String:
	return INPUT.keys()[input]

func _ready():
	if Input.get_connected_joypads().size() > 0:
		input = INPUT.CONTROLLER
