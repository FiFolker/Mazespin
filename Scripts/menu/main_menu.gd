extends CanvasLayer

@export var game_scene: PackedScene
@export var option_scene: PackedScene

func _on_play_btn_button_down():
	get_tree().change_scene_to_packed(game_scene)



func _on_option_btn_button_down():
	print("go to option menu")
	get_tree().change_scene_to_packed(option_scene)


func _on_quit_btn_button_down():
	get_tree().quit()
