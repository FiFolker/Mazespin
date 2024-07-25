extends Node2D
class_name Driver

@export var driver_name : String
@export var car : PathFollow2D
var car_data : CarData
var chrono : float
var ranking : int

func _ready():
	if get_parent() is PathFollow2D:
		car = get_parent()
	
func _process(delta:float):
	if Race.state == Race.State.RUNING:
		chrono += delta
