extends Node2D
class_name Driver

signal new_best_lap

var _driver_data : DriverData
# getter and setter to access to driver data without have to do driver.driver_data.driver_name ... boring
var driver_name : String :
	set(value):
		_driver_data.driver_name = value
	get:
		return _driver_data.driver_name
var car_data : CarData :
	set(value):
		_driver_data.car_data = value
	get:
		return _driver_data.car_data
var general_chrono : float : 
	set(value):
		_driver_data.general_chrono = value
	get:
		return _driver_data.general_chrono
var lap_chrono : float : 
	set(value):
		_driver_data.lap_chrono = value
	get:
		return _driver_data.lap_chrono
var best_lap : float : 
	set(value):
		_driver_data.best_lap = value
	get:
		return _driver_data.best_lap
var ranking : int : 
	set(value):
		_driver_data.ranking = value
	get:
		return _driver_data.ranking
var current_lap : int : 
	set(value):
		_driver_data.current_lap = value
	get:
		return _driver_data.current_lap
var car : Car : 
	set(value):
		_driver_data.car = value
	get:
		return _driver_data.car

# var than you can only get and there are useful datas
var _space_diff : float :
	set(value):
		pass
	get:
		if Race.leaderboard[0].car == null:
			return 0
		return (Race.leaderboard[0].car.progress_ratio + Race.leaderboard[0].current_lap) - (car.progress_ratio + current_lap)

var time_diff : float :
	set(value):
		pass
	get:
		return _space_diff * Race.leaderboard[0].general_chrono

var lap_diff : int :
	set(value):
		pass
	get:
		return floori(_space_diff)

func _ready():
	if _driver_data == null:
		push_error(self, " driver not initialized")
	car = get_parent() #get path follow 2d which is the car

func reset() -> void:
	best_lap = 0
	current_lap = 0
	general_chrono = 0
	lap_chrono = 0

func setup(driver_data:DriverData):
	self._driver_data = driver_data

func short_name() -> String:
	return driver_name.substr(0, 3).to_upper()

func _process(delta:float):
	if Race.state == Race.State.RUNING and Race.can_i_race(self):
		general_chrono += delta
		lap_chrono += delta
		if ranking != 1:
			var driver_ahead = Race.leaderboard[ranking-2]
			var progression_driver_ahead = driver_ahead.car.progress_ratio + driver_ahead.current_lap
			var current_progresion = car.progress_ratio + current_lap
			if current_progresion > progression_driver_ahead:
				print(self.driver_name," : ", self.ranking,
				" is overtaking ", 
				driver_ahead.driver_name," : ",driver_ahead.ranking)
				Race.leaderboard[ranking-1] = driver_ahead
				Race.leaderboard[ranking-2] = self
				ranking -= 1
				driver_ahead.ranking += 1
				Race.ranking_update.emit()


func lap_completed() -> void:
	if lap_chrono < self.best_lap or self.best_lap == 0:
		self.best_lap = lap_chrono
		new_best_lap.emit()
	current_lap += 1
	lap_chrono = 0
	car.progress_ratio = 0
