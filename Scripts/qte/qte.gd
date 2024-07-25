extends Node
class_name QTE

signal qte_done
signal qte_failure

@export var QTE_DISPLAY : PackedScene

@onready var qte_timer = $QTETimer

var action_name : String
var qte_info : QTEDisplay

var key_released : bool = true

var qte_shown : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# define qte action name
	action_name = "qte_" + OptionsValues.get_input_as_string().to_lower() 
	
	#define timer in function of the difficulty (i have to think deeply about the difficulty)
	qte_timer.wait_time = OptionsValues.difficulty
	
	# clear the input map to be sure than there is no key assigned
	InputMap.action_erase_events("current_qte")
	
	generate_qte()

func _input(event:InputEvent) -> void:	
	if event.is_action_pressed("current_qte") and key_released:
		key_released = false
		qte_done.emit()
		clear_qte()
		
	if InputMap.action_get_events("current_qte").size() > 0 : 
		if event is InputEventKey or event is InputEventJoypadButton:
			if !event.is_match(InputMap.action_get_events("current_qte")[0]) and event.is_pressed() and key_released:
				key_released = false
				qte_failure.emit()
				clear_qte()
			
	# reset bool when key released
	if event is InputEventKey or event is InputEventJoypadButton and !event.is_pressed():
		key_released = true

#region QTE logic
func generate_qte() -> void:
	var key : InputEvent = get_random_key_from_pool()
	var key_txt = key.as_text()
	if key is InputEventJoypadButton:
		key_txt = str(key.button_index)
	
	InputMap.action_add_event("current_qte", key)
	if qte_shown:
		qte_display(key_txt, qte_timer)
	qte_timer.start()

func qte_display(key_text:String, timer_reference:Timer) -> void:
	qte_info = QTE_DISPLAY.instantiate()
	qte_info.setup(key_text, timer_reference)
	get_tree().current_scene.add_child(qte_info)

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
	


func _on_qte_done():
	qte_info.success_animation()


func _on_qte_failure():
		qte_info.error_animation()
