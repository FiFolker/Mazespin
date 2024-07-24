extends CanvasLayer

@export var option_scene: PackedScene
@export var singleplayer_scene: PackedScene
@onready var play_btn = %SinglePlayer

func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		play_btn.grab_focus()

func _on_singleplayer_btn_button_down():
	GameManager.scene_changed.emit(get_tree().current_scene.scene_file_path)
	get_tree().change_scene_to_file(GameManager.scenes["singleplayer"])

func _on_option_btn_button_down():
	print("go to option menu")
	get_tree().change_scene_to_file(GameManager.scenes["options"])


func _on_quit_btn_button_down():
	get_tree().quit()
