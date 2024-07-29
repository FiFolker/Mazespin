extends Node2D
class_name Driver

var _driver_data : DriverData
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

func _ready():
	if _driver_data == null:
		push_error(self, " driver not initialized")

func setup(driver_data:DriverData):
	self._driver_data = driver_data

func _process(delta:float):
	if Race.state == Race.State.RUNING:
		chrono += delta
