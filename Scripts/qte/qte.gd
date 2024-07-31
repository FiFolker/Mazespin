extends Node
class_name QTE

signal qte_done
signal qte_failure

@onready var qte_timer = %QTETimer

var action_name : String

func setup() -> void:
	# define qte action name
	action_name = "qte_" + OptionsValues.get_input_as_string().to_lower() 
	
	#define timer in function of the difficulty (i have to think deeply about the difficulty)
	qte_timer.wait_time = OptionsValues.difficulty

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()

#region QTE logic
func generate_qte() -> void:
	pass

func clear_qte() -> void:
	qte_timer.stop()
	queue_free()
#endregion

func _on_qte_timer_timeout() -> void:
	qte_failure.emit()
	clear_qte()

func get_random_key_from_pool() -> InputEvent:
	var keys : Array[InputEvent] = InputMap.action_get_events(action_name)
	var random_index : int = randi() % keys.size()
	var random_event : InputEvent = keys[random_index]
	return random_event
	
