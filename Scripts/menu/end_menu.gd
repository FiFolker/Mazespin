extends CanvasLayer

@export var default_button_to_grab : Button

func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER and default_button_to_grab != null:
		default_button_to_grab.grab_focus()

func _on_menu_btn_button_down():
	get_tree().change_scene_to_file(GameManager.scenes["menu"])


func _on_replay_btn_button_down():
	get_tree().change_scene_to_packed(GameManager.scenes["game"])
