extends Node

signal has_won
signal has_lost

signal scene_changed(old_scene_path:String)

var scenes : Dictionary = {}
const menu_path : String = "res://Scenes/menus/"
var previous_scene : String

func _ready():
	setup_scenes(menu_path, false)
	scene_changed.connect(on_scene_changed)
	has_won.connect(win)
	has_lost.connect(lose)

func setup_scenes(path:String, debug:bool):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if debug : print("Found directory: " + file_name)
				setup_scenes(path+file_name, debug)
			else:
				if debug : print("Found file: " + file_name)
				scenes[file_name.split(".")[0].to_lower()] = path + "/" + file_name
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func win() -> void:
	get_tree().change_scene_to_file(scenes["win"])
	
func lose() -> void:
	get_tree().change_scene_to_file(scenes["lose"])

func on_scene_changed(old_scene_path:String) -> void:
	previous_scene = old_scene_path
	print(previous_scene)
