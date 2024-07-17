extends PathFollow2D

@export var speed:float = 100
@onready var slow_down_scale : float = calculate_braking_force(speed) :
	set(value):
		slow_down_scale = calculate_braking_force(speed)

var has_to_slow_down: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	self.progress += speed*delta
	if has_to_slow_down:
		slow_down(delta)


func _on_player_area_entered(area):
	if area is QTEArea:
		var qte : QTEArea = area
		var time_until_too_late = qte.number_of_qte * qte.difficulty
		#has_to_slow_down = true
		#print(qte.get_area_size())
		speed /= 5
		qte.qte_success.connect(qte_success)
		qte.generate_qte()
		

func slow_down(delta:float) -> void:
	print("slow ... ", has_to_slow_down)
	speed -= delta * slow_down_scale  # slow progressively
	if speed < 0.05 : 
		speed = 0
	#print("speed : ", speed, " detla : ", delta, " slow down scale : ", slow_down_scale) debug line

func qte_success() -> void:
	print("success ", has_to_slow_down)
	has_to_slow_down = false
	speed *= 5

func calculate_braking_force(_speed: float) -> float:
	var a = 0.01422529440908359703105520436145
	var b = 1.861
	return a * pow(_speed, b)
