extends Area2D

var driver : Driver

@onready var car_model = %CarModel
@onready var car_collider = %CarCollider

# Called when the node enters the scene tree for the first time.
func _ready():
	#driver = get_parent().driver
	if driver != null:
		car_model.texture = driver.car_data.sprite
		car_collider.shape.size = car_model.texture.get_size()
