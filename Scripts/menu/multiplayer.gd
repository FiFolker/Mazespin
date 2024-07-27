extends CanvasLayer

@onready var menu = %Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		menu.grab_focus()
	


func _on_menu_button_down():
	get_tree().change_scene_to_file(SceneManager.scenes["menu"])
