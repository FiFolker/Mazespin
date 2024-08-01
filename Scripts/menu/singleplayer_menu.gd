extends CanvasLayer

@export var menu_scene : PackedScene

@onready var difficulty_choice : OptionButton = %Difficulty
@onready var ai_number_choice : SpinBox = %AI
@onready var laps_number_choice : SpinBox = %Laps

@onready var mode_place : VBoxContainer = %Mode
@onready var track_place : VBoxContainer = %Track
@onready var cars_selection : GridContainer = %CarsSelection

@onready var info_dialog : AcceptDialog = $InfoDialog

@onready var menu = %Menu

# options selected
var mode : Race.MODE = Race.MODE.CHRONO
var track : TrackData = null
var car : CarData


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_dialog.hide()
	hide_ai_options()
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		%Chrono.grab_focus()

	init_difficulty()
	init_cars(Data.car_list)
	init_tracks(Data.track_list)
	init_laps()
	init_ai()

#region load and init resources

func init_tracks(tracks : Array[TrackData]) -> void:
	for curr_track in tracks:
		var btn = Button.new()
		btn.toggle_mode = true
		btn.name = curr_track.name
		btn.text = curr_track.name
		btn.button_group = load("res://Resources/ButtonGroups/track_group.tres")
		btn.icon = curr_track.icon
		btn.button_down.connect(track_selected.bind(curr_track))
		track_place.add_child(btn)

func init_cars(cars : Array[CarData]) -> void:
	for curr_car in cars:	
		var btn = Button.new()
		btn.theme_type_variation = "CarButton"
		btn.toggle_mode = true
		btn.name = curr_car.name
		btn.tooltip_text = curr_car.name
		btn.button_group = load("res://Resources/ButtonGroups/cars_group.tres")
		btn.icon = curr_car.sprite_small
		btn.button_down.connect(car_selected.bind(curr_car))
		cars_selection.add_child(btn)

	
func init_difficulty() -> void:
	var selected_index = -1
	var index = 0

	for difficulty in OptionsValues.DIFFICULTY:
		index = difficulty_choice.item_count
		difficulty_choice.add_item(difficulty)
		if OptionsValues.difficulty == OptionsValues.DIFFICULTY[difficulty]:
			selected_index = index
	difficulty_choice.select(selected_index)

func init_laps() -> void:
	laps_number_choice.max_value = Data.MAX_LAPS
	laps_number_choice.min_value = 1
	laps_number_choice.value = Data.DEFAULT_LAPS
		
func init_ai() -> void:
	ai_number_choice.max_value = Data.MAX_AI_NB
	ai_number_choice.value = Data.DEFAULT_AI_NB

#endregion

#region signals

func _on_menu_button_down() -> void:
	SceneManager.goto_scene_menu("menu")

func _on_difficulty_item_selected(index) -> void:
	OptionsValues.difficulty = OptionsValues.DIFFICULTY[difficulty_choice.get_item_text(index)]

func _on_chrono_button_down() -> void:
	mode = Race.MODE.CHRONO
	hide_ai_options()

func _on_ai_button_down() -> void:
	mode = Race.MODE.AI
	show_ai_options()

func track_selected(selected_track:TrackData) -> void:
	if Data.track_list.find(selected_track) != -1:
		track = selected_track

func car_selected(selected_car:CarData) -> void:
	if Data.car_list.find(selected_car) != -1:
		car = selected_car
		CurrentDriver.driver.car_data = selected_car

func _on_race_button_down() -> void:
	if track == null:
		info_dialog.dialog_text = "You didn't choose a race !"
		info_dialog.show()
		return
	if car == null:
		info_dialog.dialog_text = "You didn't choose a car !"
		info_dialog.show()
		return
	Race.singleplayer(track, mode, car, int(laps_number_choice.value), int(ai_number_choice.value))

#endregion

func hide_ai_options() -> void:
	ai_number_choice.hide()
	laps_number_choice.hide()
	menu.focus_neighbor_right = difficulty_choice.get_path()

func show_ai_options() -> void:
	ai_number_choice.show()
	laps_number_choice.show()
	menu.focus_neighbor_right = ai_number_choice.get_path()
