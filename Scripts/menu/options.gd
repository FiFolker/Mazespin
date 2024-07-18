extends CanvasLayer

@onready var input_choice = %InputChoice
@onready var difficulty_choice = %DifficultyChoice

# Called when the node enters the scene tree for the first time.
func _ready():
	var selected_index = -1
	var index = 0
	
	for input in OptionsValues.INPUT:
		index = input_choice.item_count
		input_choice.add_item(input)
		if OptionsValues.input == OptionsValues.INPUT[input]:
			selected_index = index
	input_choice.select(selected_index)

	for difficulty in OptionsValues.DIFFICULTY:
		index = difficulty_choice.item_count
		difficulty_choice.add_item(difficulty)
		if OptionsValues.difficulty == OptionsValues.DIFFICULTY[difficulty]:
			selected_index = index
	difficulty_choice.select(selected_index)

func _on_menu_btn_button_down():
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")


func _on_input_choice_item_selected(index):
	OptionsValues.input = OptionsValues.INPUT[input_choice.get_item_text(index)]
	print(OptionsValues.input)


func _on_difficulty_choice_item_selected(index):
	OptionsValues.difficulty = OptionsValues.DIFFICULTY[difficulty_choice.get_item_text(index)]
	print(OptionsValues.difficulty)
