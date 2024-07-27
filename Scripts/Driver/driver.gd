extends Node
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

func _init(driver_data:DriverData):
	self._driver_data = driver_data

func init(driver_data:DriverData):
	self._driver_data = driver_data

#func _init(_name:String, _car_data:CarData, _ranking:int, _chrono:float = 0.0):
	#driver_name = _name
	#car_data = _car_data
	#chrono = _chrono
	#ranking = _ranking
	
func _process(delta:float):
	if Race.state == Race.State.RUNING:
		_driver_data.chrono += delta
