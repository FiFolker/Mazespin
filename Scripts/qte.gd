extends Area2D
class_name QTEArea

signal qte_done
signal qte_win
signal qte_lose

@export var number_of_qte:int
@onready var key_info = %KeyInfo
@onready var remaining_time = %RemainingTime

var index_qte : int = 0
var camera:Camera2D
var action_name : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# define qte action name
	action_name = "qte_" + OptionsValues.get_platform_as_string().to_lower() 
	
	# Search cameras in group "cameras"
	camera = null
	for cam in get_tree().get_nodes_in_group("cameras"):
		if cam is Camera2D:
			camera = cam
			break
			
	if camera == null:
		print("Aucune caméra trouvée dans le groupe 'cameras'")
		return

func _process(delta:float) -> void:
	if $QTETimer.time_left > 0:
		remaining_time.text = str($QTETimer.time_left).pad_decimals(2)

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("current_qte"):
		clear_qte()
		qte_done.emit()

#region QTE management
func generate_qte() -> void:
	index_qte += 1
	$QTEDisplay.global_position = rand_position_on_cam()
	var key : InputEvent = get_random_key_from_pool()
	key_info.text = key.as_text()
	InputMap.action_add_event("current_qte", key)
	$QTETimer.start()
	
func clear_qte() -> void:
	$QTETimer.stop()
	key_info.text = ""
	remaining_time.text = ""
	InputMap.action_erase_events("current_qte")
	print(InputMap.action_get_events("current_qte"))
#endregion

func rand_position_on_cam() -> Vector2:
	# Get the position x and y of the origin of the cam (top left btw)
	var cam_pos_x : float = camera.get_screen_center_position().x - (get_viewport_rect().size.x/2)
	var cam_pos_y : float = camera.get_screen_center_position().y - (get_viewport_rect().size.y/2)
	# Generate rand pos in the cam limits 
	var x = randf_range(cam_pos_x, cam_pos_x + get_viewport_rect().size.x)
	var y = randf_range(cam_pos_y, cam_pos_y + (get_viewport_rect().size.y/2))
	
	return Vector2(x,y)

func get_random_key_from_pool() -> InputEvent:
	var keys : Array[InputEvent] = InputMap.action_get_events(action_name)
	var random_index : int = randi() % keys.size()
	var random_event : InputEvent = keys[random_index]
	return random_event


func _on_qte_timer_timeout() -> void:
	clear_qte()
	qte_lose.emit()

func _on_qte_done() -> void:
	if index_qte < number_of_qte:
		generate_qte()
	else:
		qte_win.emit()

