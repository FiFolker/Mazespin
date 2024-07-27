extends CanvasLayer

@onready var play_btn = %SinglePlayer

func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		play_btn.grab_focus()

func _on_singleplayer_btn_button_down():
	#SceneManager.scene_changed.emit(get_tree().current_scene.scene_file_path)
	#get_tree().change_scene_to_file(SceneManager.scenes["singleplayer"])
	SceneManager.goto_scene_menu("singleplayer")

func _on_option_btn_button_down():
	SceneManager.goto_scene_menu("options")


func _on_quit_btn_button_down():
	get_tree().quit()


func _on_multiplayer_button_down():
	wip_dialog()
	#SceneManager.goto_scene_menu("multiplayer")


func _on_driver_button_down():
	wip_dialog()

func wip_dialog() -> void:
	var dia = AcceptDialog.new()
	dia.dialog_text = "Work In Progress ...\nCome back later please"
	dia.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	add_child(dia)
	dia.show()
