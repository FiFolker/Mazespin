extends CanvasLayer
class_name QTEDisplay

@onready var key_info : Label = %KeyInfo
@onready var remaining_time : Label = %RemainingTime
@onready var key_png : TextureRect = %KeyPng
@onready var qte_display : PanelContainer = $QTEDisplay

var security_margin : float = 128

var timer : Timer
var key : String

func setup(key_text:String, timer_ref:Timer):
	key = key_text
	timer = timer_ref

func _ready():
	qte_display.position = Vector2(randf_range(0, get_viewport().size.x - security_margin), randf_range(0, get_viewport().size.y/2))	
	var texture = load("res://Assets/Sprites/Input/"+OptionsValues.get_input_as_string().to_lower()+"/"+key.to_lower()+".png")
	if texture != null:
		key_png.texture = texture
	else:
		key_info.text = key
	remaining_time.text = str(timer.wait_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	if timer.time_left > 0:
		remaining_time.text = str(timer.time_left).pad_decimals(2)
