extends PathFollow2D
class_name Car

@export var driver_ai_scene : PackedScene = preload("res://Scenes/Drivers/driver_ai.tscn")
@export var driver_player_scene : PackedScene = preload("res://Scenes/Drivers/driver_player.tscn")

@onready var car_area = $CarArea
@onready var driver_name = %DriverName

@export var max_speed:float = 100
@onready var speed:float = max_speed :
	set(value):
		speed = clampf(value, 0, max_speed)

var speed_change_ratio : float
var driver : Driver

func init(_driver:Driver):
	var driver_scene : Driver
	if _driver is DriverAI:
		driver = _driver as DriverAI
		driver_scene = driver_ai_scene.instantiate() as DriverAI
	if _driver is DriverPlayer:
		driver = _driver as DriverPlayer
		driver_scene = driver_player_scene.instantiate() as DriverPlayer
	driver_scene.setup(_driver._driver_data)
	add_child(driver_scene)
	

func _ready():
	#max_speed = Race.car.speed
	#speed = max_speed
	self.progress = 0
	driver_name.text = driver.driver_name
	car_area.load_car(driver.car_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	if Race.state == Race.State.RUNING:
		self.progress += speed*delta
	if self.progress == 1:
		Race.lap_finished.emit()
	

func _on_car_area_entered(area:Area2D):
	if area is QTEArea:
		var qte_sequence : QTEArea = area
		
		if driver is DriverAI :
			qte_sequence.start_qte(false)
			driver.solve_qte(qte_sequence)
		else:
			qte_sequence.start_qte(true)
		
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


