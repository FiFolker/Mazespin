extends CanvasLayer

@export var option_scene: PackedScene
@onready var play_btn = %PlayBtn

func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		play_btn.grab_focus()

func _on_play_btn_button_down():
	get_tree().change_scene_to_packed(GameManager.game_scene)

func _on_option_btn_button_down():
	print("go to option menu")
	get_tree().change_scene_to_packed(option_scene)


func _on_quit_btn_button_down():
	get_tree().quit()
