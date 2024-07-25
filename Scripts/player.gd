extends Area2D

@onready var car_model = %CarModel
@onready var car_collider = %CarCollider

# Called when the node enters the scene tree for the first time.
func _ready():
	car_model.texture = Race.car.sprite
	car_collider.shape.size = car_model.texture.get_size()

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file(GameManager.scenes["menu"])
	
