extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Race.ranking_update.connect(_on_update_rank)

func _on_update_rank()-> void:
	for driver in get_children():
		move_child(driver, driver.driver.ranking-1)
		print("GUI >> ", driver.driver.driver_name,":", driver.get_index())
