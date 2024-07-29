extends Area2D

@onready var car_model = %CarModel
@onready var car_collider = %CarCollider


func load_car(car_data:CarData):
	if car_data != null:
		car_model.texture = car_data.sprite
		car_collider.shape.size = Vector2(car_model.texture.get_size().y, car_model.texture.get_size().x)
