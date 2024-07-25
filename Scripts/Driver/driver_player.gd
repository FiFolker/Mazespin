extends Driver

func _ready():
	var driver : Driver = Race.fetch_driver()

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file(GameManager.scenes["menu"])
	
