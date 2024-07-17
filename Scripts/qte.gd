extends Area2D

signal slow_down

var slowing : bool = false
var time_scale : float = 1.0
var factor_scale : float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		slowing = false
		print("Acceleration triggered: ", slowing)
	
	if slowing:
		if time_scale > 0:
			slow_time(delta)
	else:
		time_scale = 1.0
		Engine.time_scale = time_scale

func slow_time(delta:float) -> void:
	time_scale -= delta * factor_scale  # Diminue progressivement
	if time_scale < 0.05 : 
		time_scale = 0
	Engine.time_scale = time_scale
	#print("Slowing time: ", Engine.time_scale, ", factor_scale: ", factor_scale)

func qte():
	var x = randf_range(0, get_viewport().get_visible_rect().size.x)
	var y = randf_range(0, get_viewport().get_visible_rect().size.y)
	print(x, " : " ,y)
	var key : InputEvent = get_random_key_from_pool()
	print(key)
	if Input.is_action_just_pressed("qte"):
		print("qte pressed")
		slowing = false
	if key is InputEventKey:
		print("is eventkey")
		if Input.is_key_pressed(KEY_SHIFT):
			print("Selected key pressed for QTE ")

func get_random_key_from_pool() -> InputEvent:
	var action_name : String = "qte"
	var keys : Array[InputEvent] = InputMap.action_get_events(action_name)
	var random_index : int = randi() % keys.size()
	var random_event : InputEvent = keys[random_index]
	return random_event

func _on_area_entered(area):
	print("area entered")
	slowing = true
	qte()
	
func _on_area_exited(area):
	print("area exited")
