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
var wait_last_drivers : bool


func _ready():
	SceneManager.scene_changing_ended.connect(_on_scene_changing_ended)
	lap_finished.connect(_on_lap_finished)
	
func _process(delta):
	if wait_last_drivers:
		if check_if_all_drivers_finished():
			end_race()

func check_if_all_drivers_finished() -> bool:
	var all_finished : bool = true
	var i : int = 0
	while all_finished and i < leaderboard.size() :
		all_finished = leaderboard[i].current_lap == max_laps
		i += 1
	return all_finished

func _on_scene_changing_ended():
	if track != null:
		if SceneManager.current_scene.scene_file_path == track.scene.resource_path:
			init_cars()
			start_countdown(countdown)

func singleplayer(_track:TrackData, _mode:MODE, _car:CarData, _laps_number:int, _ai_number:int) -> void:
	single_setup()
	CurrentDriver.driver.car_data = _car
	init(_track, _mode, _laps_number, _ai_number)

func init(_track:TrackData, _mode:MODE, _laps_number:int, _ai_number:int):
	track = _track
	mode = _mode
	max_laps = -1 if mode == MODE.CHRONO else _laps_number
	number_driver = 0 if mode == MODE.CHRONO else _ai_number
	setup()

func single_setup() -> void:
	leaderboard.clear()
	leaderboard.append(CurrentDriver.driver)
	CurrentDriver.driver.ranking = leaderboard.size()
	CurrentDriver.driver.reset()

func setup() -> void:
	general_lap = 0
	state = State.WAITING
	wait_last_drivers = false
	init_drivers()
	SceneManager.goto_scene_packed(track.scene)

func replay_single() -> void:
	single_setup()
	setup()

func init_drivers() -> void:
	for i in number_driver:
		var random_car = Data.car_list.pick_random()
		var driver_data : DriverData = DriverData.new(Data.random_name.pick_random(), random_car, leaderboard.size()+1)
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

func chrono_to_string(chrono:float, precision:int = chrono_precision) -> String:
	var minute : int = int(chrono/60)
	var sec : float = float(chrono - (minute*60))
	
	if minute <= 0:
		return str(sec).pad_decimals(precision)
	
	return str(minute) + ":" + str(sec).pad_decimals(precision)

func _on_lap_finished() -> void:
	general_lap += 1
	if max_laps == -1:
		return
	if general_lap >= max_laps:
		wait_last_drivers = true
		
func end_race() -> void:
	wait_last_drivers = false
	state = Race.State.FINISHED
	await get_tree().create_timer(2).timeout
	save_drivers()
	SceneManager.goto_scene_menu("end")

func save_drivers() -> void:
	var driver_data : DriverData 
	for i in leaderboard.size():
		if leaderboard[i] != null:
			driver_data = DriverData.new_driver_data(leaderboard[i]._driver_data)
			leaderboard[i] = Driver.new()
			leaderboard[i].setup(driver_data)
		else:
			push_error("Driver at pos ", i, " is null !")
			return
	driver_data = DriverData.new_driver_data(CurrentDriver.driver._driver_data)
	CurrentDriver.driver = DriverPlayer.new()
	CurrentDriver.driver.setup(driver_data)
	leaderboard[CurrentDriver.driver.ranking-1] = CurrentDriver.driver

func can_i_race(driver:Driver) -> bool:
	if max_laps == -1:
		return true
	return driver.current_lap < max_laps
