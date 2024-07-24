extends CanvasLayer

enum MODE {CHRONO, AI}

@export var menu_scene : PackedScene
@onready var difficulty_choice : OptionButton = %Difficulty
@onready var mode_place : VBoxContainer = %Mode
@onready var cars_selection : GridContainer = %CarsSelection
@onready var info_dialog : AcceptDialog = $InfoDialog

var cars_path : String = "res://Resources/Cars/"

# options selected
var mode : MODE = MODE.CHRONO
var race_scene : PackedScene = null
var car : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_dialog.hide()
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		%Chrono.grab_focus()
	
	init_difficulty()
	init_cars()

func init_difficulty() -> void:
	var selected_index = -1
	var index = 0

	for difficulty in OptionsValues.DIFFICULTY:
		index = difficulty_choice.item_count
		difficulty_choice.add_item(difficulty)
		if OptionsValues.difficulty == OptionsValues.DIFFICULTY[difficulty]:
			selected_index = index
	difficulty_choice.select(selected_index)

func init_cars() -> void:
	var dir = DirAccess.open(cars_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() :
				var current_car : Car = load(cars_path + file_name) as Car
				if current_car is Car:
					var btn = Button.new()
					btn.toggle_mode = true
					btn.name = current_car.resource_name
					btn.button_group = load("res://Resources/ButtonGroups/cars_group.tres")
					btn.icon = current_car.sprite_small
					cars_selection.add_child(btn)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _on_menu_button_down() -> void:
	get_tree().change_scene_to_file(GameManager.scenes["menu"])

func _on_difficulty_item_selected(index) -> void:
	OptionsValues.difficulty = OptionsValues.DIFFICULTY[difficulty_choice.get_item_text(index)]

func _on_chrono_button_down() -> void:
	mode = MODE.CHRONO
	print("changed mode to chrono")

func _on_ai_button_down() -> void:
	mode = MODE.AI
	print("changed mode to ai")

func _on_race_button_down() -> void:
	if race_scene == null:
		info_dialog.dialog_text = "You didn't choose a race !"
		info_dialog.show()
	if car == -1:
		info_dialog.dialog_text = "You didn't choose a car !"
		info_dialog.show()
		return
		return
	pass # Launch the race with all the parameters
