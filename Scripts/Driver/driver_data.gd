extends Node
class_name DriverData

var driver_name : String
var car_data : CarData
var chrono : float
var ranking : int

func _init(_driver_name:String, _car_data:CarData, _ranking:int, _chrono:float = 0.0):
	driver_name = _driver_name
	car_data = _car_data
	chrono = _chrono
	ranking = _ranking
