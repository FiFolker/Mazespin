extends CanvasLayer
class_name QTEDisplay

@onready var key_info : Label = %KeyInfo
@onready var key_png_animated = %KeyPngAnimated
@onready var animation_player = $AnimationPlayer
@onready var qte_pos = $QTEPos
@onready var clock_progress = %ClockProgress

@export var duration_between_frames : float = 0.25

var security_margin : float = 128

var timer : Timer
var key : String

func setup(key_text:String, timer_ref:Timer):
	key = key_text
	timer = timer_ref

func _ready():
	var screen_size  : Vector2 = get_viewport().get_visible_rect().size
	qte_pos.position = Vector2(randf_range(0, screen_size.x - security_margin), randf_range(0, screen_size.y/2))
	
	
	var textures : Array[Texture2D] = get_textures()

	if textures.size() > 0:
		key_png_animated.texture = AnimatedTexture.new()
		var animated_texture : AnimatedTexture = key_png_animated.texture
		animated_texture.frames = textures.size()
		for i in range(textures.size()):
			animated_texture.set_frame_texture(i, textures[i])
			animated_texture.set_frame_duration(i, duration_between_frames)
	else:
		# in case he doesn't find the textures
		key_info.visible = true
		key_info.text = key

func get_textures() -> Array[Texture2D]:
	var textures : Array[Texture2D]
	var input_name : String = OptionsValues.get_input_as_string().to_lower()
	var path_textures : Array[String] = [
		"res://Assets/Sprites/Input/"+input_name+"/"+input_name+"_"+key.to_lower()+".png",
		"res://Assets/Sprites/Input/"+input_name+"/"+input_name+"_"+key.to_lower()+"_outline.png"
	]
	
	for path in path_textures:
		if ResourceLoader.exists(path):
			textures.append(load(path))

	return textures
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	if is_instance_valid(timer) and timer.time_left > 0:
		clock_progress.value = absf(timer.time_left/timer.wait_time - 1.0) * 100

func error_animation() -> void:
	animation_player.play("fail")

func success_animation() -> void:
	animation_player.play("success")
