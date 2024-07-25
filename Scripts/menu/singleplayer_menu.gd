extends CanvasLayer

@export var menu_scene : PackedScene
@onready var difficulty_choice : OptionButton = %Difficulty
@onready var mode_place : VBoxContainer = %Mode
@onready var track_place : VBoxContainer = %Track
@onready var cars_selection : GridContainer = %CarsSelection
@onready var info_dialog : AcceptDialog = $InfoDialog

var cars_path : String = "res://Resources/Cars/"
var track_path : String = "res://Resources/Tracks/"

# options selected
var mode : Race.MODE = Race.MODE.CHRONO
var track : Track = null
var car : Car = null

var car_list : Array[Car]
var track_list : Array[Track]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_dialog.hide()
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		%Chrono.grab_focus()
	
	init_difficulty()
	init_cars(get_resources(cars_path))
	init_tracks(get_resources(track_path))

#region load and init resources

func init_tracks(tracks : Array[Resource]) -> void:
	for curr_track in tracks:
		if curr_track is Track:
			curr_track = curr_track as Track
			track_list.append(curr_track)
			var btn = Button.new()
			btn.toggle_mode = true
			btn.name = curr_track.name
			btn.text = curr_track.name
			btn.button_group = load("res://Resources/ButtonGroups/track_group.tres")
			btn.icon = curr_track.icon
			btn.button_down.connect(track_selected.bind(curr_track))
			track_place.add_child(btn)
		else:
			printerr("It's not a track ...")

func init_cars(cars : Array[Resource]) -> void:
	for curr_car in cars:
		if curr_car is Car:
			curr_car = curr_car as Car
			car_list.append(curr_car)
			var btn = Button.new()
			btn.theme_type_variation = "CarButton"
			btn.toggle_mode = true
			btn.name = curr_car.name
			btn.tooltip_text = curr_car.name
			btn.button_group = load("res://Resources/ButtonGroups/cars_group.tres")
			btn.icon = curr_car.sprite_small
			btn.button_down.connect(car_selected.bind(curr_car))
			cars_selection.add_child(btn)
		else:
			printerr("It's not a car ...")
	
func init_difficulty() -> void:
	var selected_index = -1
	var index = 0

	for difficulty in OptionsValues.DIFFICULTY:
		index = difficulty_choice.item_count
		difficulty_choice.add_item(difficulty)
		if OptionsValues.difficulty == OptionsValues.DIFFICULTY[difficulty]:
			selected_index = index
	difficulty_choice.select(selected_index)

func get_resources(path) -> Array[Resource]:
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
	

#endregion

#region signals

func _on_menu_button_down() -> void:
	get_tree().change_scene_to_file(GameManager.scenes["menu"])

func _on_difficulty_item_selected(index) -> void:
	OptionsValues.difficulty = OptionsValues.DIFFICULTY[difficulty_choice.get_item_text(index)]

func _on_chrono_button_down() -> void:
	mode = Race.MODE.CHRONO
	print("changed mode to chrono")

func _on_ai_button_down() -> void:
	mode = Race.MODE.AI
	print("changed mode to ai")

func track_selected(selected_track:Track) -> void:
	if track_list.find(selected_track) != -1:
		track = selected_track

func car_selected(selected_car:Car) -> void:
	if car_list.find(selected_car) != -1:
		car = selected_car

func _on_race_button_down() -> void:
	if track == null:
		info_dialog.dialog_text = "You didn't choose a race !"
		info_dialog.show()
		return
	if car == null:
		info_dialog.dialog_text = "You didn't choose a car !"
		info_dialog.show()
		return
	var race = Race.init(track, car, mode)
	get_tree().change_scene_to_packed(track.scene) # i have to find a way to transfer data between the scenes

#endregion
