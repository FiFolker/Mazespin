extends Node

signal lap_finished

enum MODE {CHRONO, AI}
enum State {WAITING, RUNING, FINISHED}

# race settings
var track : TrackData
var mode : MODE
var state : State
var max_laps : int
var number_driver : int

# race infos
var leaderboard : Array[Driver] # need to define driver type or a way to save driver info
var general_lap : int
var countdown_timer : SceneTreeTimer

func singleplayer(_track:TrackData, _mode:MODE, driver: Driver) -> void:
	leaderboard.append(driver)
	init(_track, _mode)

func init(_track:TrackData, _mode:MODE):
	track = _track
	mode = _mode
	general_lap = 0
	max_laps = 1
	number_driver = 19
	state = State.WAITING
	init_drivers()
	start_countdown(3.5)
	
func init_drivers() -> void:
	for i in number_driver:
		var driver : Driver = Driver.new()
		driver.driver_name = "test"
		driver.chrono = 0.0
		driver.ranking = i+1
		leaderboard.append(driver)
	
func start_countdown(time:float) -> void:
	countdown_timer =  get_tree().create_timer(time)
	countdown_timer.timeout.connect(start_race)
	
func start_race() -> void:
	state = State.RUNING

