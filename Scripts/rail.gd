extends PathFollow2D

@export var speed:float = 100
@onready var slow_down_scale : float = calculate_braking_force(speed) :
	set(value):
		slow_down_scale = calculate_braking_force(speed)

var has_to_slow_down: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print(calculate_braking_force(speed))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	self.progress += speed*delta
	if has_to_slow_down:
		slow_down(delta)


func _on_player_area_entered(area):
	if area is QTEArea:
		has_to_slow_down = true
		var qte : QTEArea = area
		qte.generate_qte()
		qte.qte_win.connect(qte_success)
		

func slow_down(delta:float) -> void:
	print("slow ...")
	speed -= delta * slow_down_scale  # Diminue progressivement
	if speed < 0.05 : 
		speed = 0
	print("speed : ", speed, " detla : ", delta, " slow down scale : ", slow_down_scale)

func qte_success() -> void:
	has_to_slow_down = false
	speed = 200

func calculate_braking_force(speed: float) -> float:
	var a = 0.01422529440908359703105520436145
	var b = 1.861
	return a * pow(speed, b)
