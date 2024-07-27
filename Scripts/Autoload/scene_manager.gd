extends Node

signal has_won
signal has_lost
signal is_ended

signal scene_changing(old_scene_path:String)
signal scene_changing_ended

var scenes : Dictionary = {}
const menu_path : String = "res://Scenes/menus/"
var previous_scene : String

var current_scene : Node

func _ready():
	setup_scenes(menu_path, false)
	scene_changing.connect(on_scene_changing)
	has_won.connect(win)
	has_lost.connect(lose)
	is_ended.connect(end)
	print(get_tree().current_scene)
	current_scene = get_tree().current_scene

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

func end() -> void:
	get_tree().change_scene_to_file(scenes["end"])

func on_scene_changing(old_scene_path:String) -> void:
	previous_scene = old_scene_path
	print(previous_scene)

func goto_scene_menu(_name:String):
	if _name not in scenes:
		push_error(_name, "Doesn't exist in scenes dico")
		return
	var path = scenes[_name]
	call_deferred("_deferred_goto_scene", path)

func goto_scene_packed(scene:PackedScene):
	call_deferred("_deferred_goto_scene", scene.resource_path)
	
func goto_scene_file(path:String):
	call_deferred("_deferred_goto_scene", path)
	
func _deferred_goto_scene(path):
	# Before remove let's emit than it's changing to save the old scene
	scene_changing.emit(current_scene.scene_file_path)
	
	# It is now safe to remove the current scene.
	
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	
	scene_changing_ended.emit()
