extends CanvasLayer

@export var default_button_to_grab : Button
@export var driver_template_scene : PackedScene

@onready var driver_infos = %DriverInfos

func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER and default_button_to_grab != null:
		default_button_to_grab.grab_focus()
	init_drivers()
	
func init_drivers() -> void:
	for driver in Race.leaderboard:
		var new_driver = driver_template_scene.instantiate() as DriverTemplateEnd
		new_driver.name = driver.driver_name + str(driver.ranking)
		driver_infos.add_child(new_driver)
		new_driver.load_data(driver)


func _on_menu_btn_button_down():
	SceneManager.goto_scene_menu("menu")


func _on_replay_btn_button_down():
	Race.replay_single()
