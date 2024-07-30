extends Node

signal lap_finished
signal ranking_update

enum MODE {CHRONO, AI}
enum State {WAITING, RUNING, FINISHED}

const chrono_precision : int = 3
var car_scene : PackedScene = load("res://Scenes/car.tscn")

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
var countdown : float = 3.5

func _ready():
	SceneManager.scene_changing_ended.connect(_on_scene_changing_ended)
	

func _on_scene_changing_ended():
	if track != null:
		if SceneManager.current_scene.scene_file_path == track.scene.resource_path:
			init_cars()
			start_countdown(countdown)

func singleplayer(_track:TrackData, _mode:MODE) -> void:
	leaderboard.clear()
	leaderboard.append(CurrentDriver.driver)
	CurrentDriver.driver.ranking = leaderboard.size()
	CurrentDriver.driver.chrono = 0
	init(_track, _mode)

func init(_track:TrackData, _mode:MODE):
	track = _track
	mode = _mode
	general_lap = 0
	max_laps = 1
	number_driver = 0 if mode == MODE.CHRONO else 20
	state = State.WAITING
	init_drivers()
	SceneManager.goto_scene_packed(track.scene)
	
func init_drivers() -> void:
	for i in number_driver:
		if i > leaderboard.size():
			var random_car = Data.car_list.pick_random()
			var driver_data : DriverData = DriverData.new(Data.random_name.pick_random() + str(i), random_car, i+1)
			var driver : DriverAI = DriverAI.new()
			driver.setup(driver_data)
			leaderboard.append(driver)
	
func init_cars() -> void:
	var race_route : Path2D = SceneManager.current_scene.find_child("RaceRoute") as Path2D
	if race_route != null:
		for driver in leaderboard:
			var new_car = car_scene.instantiate() as Car
			new_car.name = driver.driver_name + str(driver.ranking)
			new_car.init(driver)
			race_route.add_child(new_car)

func start_countdown(time:float) -> void:
	countdown_timer =  get_tree().create_timer(time)
	countdown_timer.timeout.connect(start_race)
	
func start_race() -> void:
	state = State.RUNING

func chrono_to_string(chrono:float, precision:int) -> String:
	var minute : int = int(chrono/60)
	var sec : float = float(chrono - (minute*60))
	
	if minute <= 0:
		return str(sec).pad_decimals(precision)
	
	return str(minute) + ":" + str(sec).pad_decimals(precision)
