extends CanvasLayer

func _on_menu_btn_button_down():
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")


func _on_replay_btn_button_down():
	get_tree().change_scene_to_packed(GameManager.game_scene)
