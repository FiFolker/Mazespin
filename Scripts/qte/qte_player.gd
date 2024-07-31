extends QTE
class_name QTEPlayer

@export var QTE_DISPLAY : PackedScene = load("res://Scenes/QTE/qte_display.tscn")

var qte_info : QTEDisplay
var key_released : bool = true

func _ready():
	super._ready()
	
	#setup signal to do some behavior
	qte_done.connect(_on_qte_done)
	qte_failure.connect(_on_qte_failure)
	
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
	qte_display(key_txt, qte_timer)
	qte_timer.start()

func qte_display(key_text:String, timer_reference:Timer) -> void:
	qte_info = QTE_DISPLAY.instantiate()
	qte_info.setup(key_text, timer_reference)
	SceneManager.current_scene.add_child(qte_info)

#endregion

func _on_qte_done():
	if qte_info != null:
		qte_info.success_animation()


func _on_qte_failure():
	if qte_info != null:	
		qte_info.error_animation()
