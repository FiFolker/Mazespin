extends Driver
class_name DriverPlayer

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file(SceneManager.scenes["menu"])
	
