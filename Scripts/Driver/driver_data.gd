extends Node
class_name DriverData

var driver_name : String
var car_data : CarData
var general_chrono : float
var lap_chrono : float
var best_lap : float
var ranking : int
var current_lap : int
var car : Car

func _init(_driver_name:String, _car_data:CarData, _ranking:int, _current_lap:int = 0):
	driver_name = _driver_name
	car_data = _car_data
	ranking = _ranking
	current_lap = _current_lap
	general_chrono = 0.0
	lap_chrono = 0.0
	best_lap = 0.0

static func new_driver_data(_driver_data:DriverData) -> DriverData:
	var driver_data : DriverData = DriverData.new(
		_driver_data.driver_name,
		_driver_data.car_data,
		_driver_data.ranking
	)
	driver_data.current_lap = _driver_data.current_lap
	driver_data.best_lap = _driver_data.best_lap
	driver_data.general_chrono = _driver_data.general_chrono
	driver_data.car = _driver_data.car
	
	return driver_data
