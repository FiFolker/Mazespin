extends CanvasLayer

@export var default_button_to_grab : Button

func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER and default_button_to_grab != null:
		default_button_to_grab.grab_focus()

func _on_menu_btn_button_down():
	SceneManager.goto_scene_menu("menu")


func _on_replay_btn_button_down():
	SceneManager.goto_scene_packed(Race.track.scene)
