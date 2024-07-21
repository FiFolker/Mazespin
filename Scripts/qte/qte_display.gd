extends CanvasLayer
class_name QTEDisplay

@onready var key_info : Label = %KeyInfo
@onready var remaining_time : Label = %RemainingTime
@onready var qte_display : PanelContainer = $QTEDisplay
@onready var key_png_animated = %KeyPngAnimated
@onready var animation_player = $AnimationPlayer
@onready var anim_place = $Node2D

@export var duration_between_frames : float = 0.25

var security_margin : float = 128

var timer : Timer
var key : String

func setup(key_text:String, timer_ref:Timer):
	key = key_text
	timer = timer_ref

func _ready():
	qte_display.position = Vector2(randf_range(0, get_viewport().size.x - security_margin), randf_range(0, get_viewport().size.y/2))	
	
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
	remaining_time.text = str(timer.wait_time)

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
		remaining_time.text = str(timer.time_left).pad_decimals(2)

func error_animation() -> void:
	anim_place.position = qte_display.position
	animation_player.play("fail")
	await animation_player.animation_finished
	queue_free()

func success_animation() -> void:
	anim_place.position = qte_display.position
	animation_player.play("success")
	await animation_player.animation_finished
	queue_free()
