extends Area2D
class_name QTEArea

signal qte_done
signal qte_success
signal qte_failure

@export var number_of_qte:int

# to display graphic with touch and time to press it
const QTE_DISPLAY = preload("res://Scenes/qte_display.tscn")
var qte_info : QTEDisplay

var in_progress:bool = false

# idk but smth like that so the timer isn't always the same and it depends of the difficulty
# idk if i put difficulty as an option in the menu or it depends of the progression of the player
# the more far you're are the more it's quick ???
enum DIFFICULTY {EASY=10, MEDIUM=5, HARD=1}
@export var difficulty : DIFFICULTY = DIFFICULTY.EASY

@onready var qte_timer = $QTETimer

var index_qte : int = 0
var camera:Camera2D
var action_name : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# define qte action name
	action_name = "qte_" + OptionsValues.get_platform_as_string().to_lower() 
	
	print(InputMap.action_get_events("current_qte"))
	
	#define timer in function of the difficulty (i have to think deeply about the difficulty)
	qte_timer.wait_time = difficulty

	# Search cameras in group "cameras"
	camera = null
	for cam in get_tree().get_nodes_in_group("cameras"):
		if cam is Camera2D:
			camera = cam
			break
			
	if camera == null:
		print("Aucune caméra trouvée dans le groupe 'cameras'")
		return

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("current_qte") && in_progress:
		clear_qte()
		qte_done.emit()

#region QTE management
func generate_qte() -> void:
	index_qte += 1
	var key : InputEvent = get_random_key_from_pool()
	InputMap.action_add_event("current_qte", key)
	qte_display(key.as_text(), qte_timer)
	qte_timer.start()

func qte_display(key_text:String, timer_reference:Timer) -> void:
	qte_info = QTE_DISPLAY.instantiate()
	qte_info.setup(key_text, timer_reference)
	get_tree().root.add_child(qte_info)

func clear_qte() -> void:
	qte_info.queue_free()
	qte_timer.stop()
	InputMap.action_erase_events("current_qte")
#endregion
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

func get_area_size() -> Vector2:
	if !($CollisionShape2D.shape is RectangleShape2D):
		return Vector2.ZERO
	return $CollisionShape2D.shape.size * self.scale

func _on_qte_timer_timeout() -> void:
	clear_qte()
	qte_failure.emit()

func _on_qte_done() -> void:
	if index_qte < number_of_qte:
		generate_qte()
	else:
		qte_success.emit()

func _on_area_entered(area):
	in_progress = true

func _on_area_exited(area):
	in_progress = false
