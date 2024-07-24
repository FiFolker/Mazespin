extends CanvasLayer

@onready var play_btn = %SinglePlayer

func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		play_btn.grab_focus()

func _on_singleplayer_btn_button_down():
	GameManager.scene_changed.emit(get_tree().current_scene.scene_file_path)
	get_tree().change_scene_to_file(GameManager.scenes["singleplayer"])

func _on_option_btn_button_down():
	get_tree().change_scene_to_file(GameManager.scenes["options"])


func _on_quit_btn_button_down():
	get_tree().quit()


func _on_multiplayer_button_down():
	get_tree().change_scene_to_file(GameManager.scenes["multiplayer"])
