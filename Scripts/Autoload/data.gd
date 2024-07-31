extends Node

var cars_path : String = "res://Resources/Cars/"
var track_path : String = "res://Resources/Tracks/"

const MAX_LAPS : int = 25
const MAX_DRIVER : int = 20
const MAX_AI_NB : int = 19
const DEFAULT_LAPS : int = 6
const DEFAULT_DRIVERS : int = 20
const DEFAULT_AI_NB : int = 19

var car_list : Array[CarData]
var track_list : Array[TrackData]
const random_name : Array[String] = [
	"Hamilton",
	"Verstappen",
	"Alonso",
	"Schumacher",
	"Stroll",
	"Ocon",
	"Leclerc",
	"Gasly",
	"Norris",
	"Piastry",
	"Tsunoda"
]

func _ready():
	fill_car_list(get_resources(cars_path))
	fill_track_list(get_resources(track_path))

func fill_car_list(cars : Array[Resource]) -> void:
	for curr_car in cars:
		if curr_car is CarData:
			car_list.append(curr_car)
		else:
			printerr("It's not a car ...")
			
func fill_track_list(tracks : Array[Resource]) -> void:
	for curr_track in tracks:
		if curr_track is TrackData:
			track_list.append(curr_track)
		else:
			printerr("It's not a track ...")

func get_resources(path:String) -> Array[Resource]:
	var resources : Array[Resource]
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.contains(".tres"):
				resources.append(load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return resources
