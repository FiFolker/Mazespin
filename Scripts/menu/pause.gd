extends CanvasLayer
class_name Pause

@onready var resume = %Resume

func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		resume.grab_focus()

func _on_resume_button_down():
	Race.resume()

func _on_restart_button_down():
	Race.replay_single()

func _on_options_button_down():
		SceneManager.goto_scene_menu("options")

func _on_menu_button_down():
	SceneManager.goto_scene_menu("menu")


func _on_end_button_down():
	Race.end_race()
