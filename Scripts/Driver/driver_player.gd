extends Driver
class_name DriverPlayer

func _input(event):
	if event.is_action_pressed("pause"):
		SceneManager.goto_scene_menu("menu")
	
