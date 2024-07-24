extends CanvasLayer

@onready var input_choice = %InputChoice

# Called when the node enters the scene tree for the first time.
func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		input_choice.grab_focus()
	
	var selected_index = -1
	var index = 0
	
	for input in OptionsValues.INPUT:
		index = input_choice.item_count
		input_choice.add_item(input)
		if OptionsValues.input == OptionsValues.INPUT[input]:
			selected_index = index
	input_choice.select(selected_index)

func _on_menu_btn_button_down():
	get_tree().change_scene_to_file(GameManager.scenes["menu"])


func _on_input_choice_item_selected(index):
	OptionsValues.input = OptionsValues.INPUT[input_choice.get_item_text(index)]
	print(OptionsValues.input)
