extends CanvasLayer

@onready var timer_label = %TimerLabel

var chrono : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_label.text = array_to_min_and_sec_string(convert_sec_in_min(chrono))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta:float):
	chrono += delta
	timer_label.text = array_to_min_and_sec_string(convert_sec_in_min(chrono))

func convert_sec_in_min(sec:float)->Array[int]:
	var time_converted : Array[int] = [0,0]
	
	time_converted[0] = int(sec/60)
	time_converted[1] = int(sec - (time_converted[0]*60))
	
	return time_converted

func array_to_min_and_sec_string(min_and_sec:Array[int])-> String:
	if min_and_sec[0] <= 0:
		return str(min_and_sec[1]) + "s"
	return str(min_and_sec[0]) + "m " + str(min_and_sec[1]) + "s"
