extends PathFollow2D
class_name Car

@export var max_speed:float = 100
@onready var speed:float = max_speed :
	set(value):
		speed = clampf(value, 0, max_speed)

var speed_change_ratio : float

func _ready():
	max_speed = Race.car.speed
	speed = max_speed
	self.progress = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	if Race.state == Race.State.RUNING:
		self.progress += speed*delta
	if self.progress == 1:
		Race.lap_finished.emit()
	

func _on_car_area_entered(area):
	if area is QTEArea:
		var qte_sequence : QTEArea = area
		
		var time_before_crossing_area : float= qte_sequence.number_of_qte * OptionsValues.difficulty
		var area_size:Vector2 = qte_sequence.get_area_size()
		
		# calculate speed to corssing the area
		speed_change_ratio = speed / (area_size.y / time_before_crossing_area)
		speed /= speed_change_ratio
		
		# connect to signals
		qte_sequence.qte_sequence_success.connect(qte_sequence_success)
		qte_sequence.qte_sequence_failure.connect(qte_sequence_failure)

func qte_sequence_success() -> void:
	print("success NICE")
	speed *= speed_change_ratio

func qte_sequence_failure() -> void:
	print("fail ...")
	speed *= speed_change_ratio


