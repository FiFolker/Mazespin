extends Node

enum MODE {CHRONO, AI}
enum State {WAITING, RUNING, FINISHED}

var track : Track
var car : Car
var mode : MODE
var state : State
var chrono : float
var countdown_timer : SceneTreeTimer

func init(track:Track, car:Car, mode:MODE):
	self.track = track
	self.car = car
	self.mode = mode
	chrono = 0.0
	state = State.WAITING
	start_countdown(4)
	
func start_countdown(time:float) -> void:
	countdown_timer =  get_tree().create_timer(time)
	countdown_timer.timeout.connect(start_race)
	
func start_race() -> void:
	state = State.RUNING

func _process(delta):
	if state == State.RUNING:
		chrono += delta
