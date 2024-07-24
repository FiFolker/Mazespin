extends CanvasLayer

enum MODE {CHRONO, AI}

@export var menu_scene : PackedScene
@onready var difficulty_choice = %Difficulty
@onready var mode_place = %Mode

# options selected
var mode : MODE = MODE.CHRONO
var race_scene : PackedScene
var car : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		#to do grab something
		pass
	var selected_index = -1
	var index = 0

	for difficulty in OptionsValues.DIFFICULTY:
		index = difficulty_choice.item_count
		difficulty_choice.add_item(difficulty)
		if OptionsValues.difficulty == OptionsValues.DIFFICULTY[difficulty]:
			selected_index = index
	difficulty_choice.select(selected_index)


func _on_menu_button_down() -> void:
	get_tree().change_scene_to_packed(GameManager.scenes["menu"])

func _on_difficulty_item_selected(index) -> void:
	OptionsValues.difficulty = OptionsValues.DIFFICULTY[difficulty_choice.get_item_text(index)]

func _on_chrono_button_down() -> void:
	mode = MODE.CHRONO
	print("changed mode to chrono")

func _on_ai_button_down() -> void:
	mode = MODE.AI
	print("changed mode to ai")

func change_toggled_mode() -> void:
	pass

func _on_race_button_down() -> void:
	pass # Launch the race with all the parameters
