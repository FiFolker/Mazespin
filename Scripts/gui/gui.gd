extends CanvasLayer

@onready var timer_label = %TimerLabel
@export var chrono_precision : int = 1
@onready var countdown_place = %Countdown
@onready var countdown_label = %CountdownLabel
var countdown : int

# Called when the node enters the scene tree for the first time.
func _ready():
	countdown_place.visible = true
	countdown = Race.countdown_timer.time_left
	timer_label.text = chrono_to_string(chrono_precision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta:float):
	if Race.state == Race.State.RUNING:
		timer_label.text = chrono_to_string(chrono_precision)
		
	if Race.countdown_timer.time_left > 0 and countdown_place.visible ==true:
		
		countdown = Race.countdown_timer.time_left - delta
		if countdown != 0:
			countdown_label.text = str(countdown)
		else:
			countdown_label.text = "START"
			countdown_end()

func chrono_to_string(precision:int) -> String:
	var min : int = int(Race.chrono/60)
	var sec : float = float(Race.chrono - (min*60))
	
	if min <= 0:
		return str(sec).pad_decimals(precision)
	
	return str(min) + ":" + str(sec).pad_decimals(precision)
	

func countdown_end() -> void:
	await get_tree().create_timer(.5).timeout
	countdown_place.visible = false
	
