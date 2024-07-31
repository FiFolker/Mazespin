extends Node2D
class_name Driver

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
var chrono : float : 
	set(value):
		_driver_data.chrono = value
	get:
		return _driver_data.chrono
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
		

func _ready():
	if _driver_data == null:
		push_error(self, " driver not initialized")
	car = get_parent() #get path follow 2d which is the car

func setup(driver_data:DriverData):
	self._driver_data = driver_data

func short_name() -> String:
	return driver_name.substr(0, 3).to_upper()

func _process(delta:float):
	if Race.state == Race.State.RUNING:
		chrono += delta
