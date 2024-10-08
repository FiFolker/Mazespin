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
var qte_sequence : QTEArea

func init(_driver:Driver):
	if _driver is DriverAI:
		driver = _driver as DriverAI
	if _driver is DriverPlayer:
		driver = _driver as DriverPlayer
	

func _ready():
	#max_speed = Race.car.speed
	#speed = max_speed
	self.progress = 0
	var driver_scene : Driver
	if driver is DriverAI:
		driver_scene = driver_ai_scene.instantiate() as DriverAI
	if driver is DriverPlayer:
		driver_scene = driver_player_scene.instantiate() as DriverPlayer
	driver_scene.setup(driver._driver_data)
	add_child(driver_scene)
	driver_name.text = driver.driver_name
	car_area.load_car(driver.car_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	if Race.state == Race.State.RUNING and Race.can_i_race(driver):
		self.progress += speed*delta
	if self.progress_ratio == 1:
		if driver.ranking == 1:
			Race.lap_finished.emit()
		driver.lap_completed()

func _on_car_area_entered(area:Area2D):
	if area is QTEArea:
		qte_sequence = QTEArea.new()
		qte_sequence.init(area, self)
		
		add_child(qte_sequence)
		
		var time_before_crossing_area : float= qte_sequence.number_of_qte * OptionsValues.difficulty
		var area_size:Vector2 = area.get_area_size()
		
		# calculate speed to corssing the area
		speed_change_ratio = speed / (area_size.y / time_before_crossing_area)
		speed /= speed_change_ratio
		
		# connect to signals
		qte_sequence.qte_sequence_success.connect(qte_sequence_success)
		qte_sequence.qte_sequence_failure.connect(qte_sequence_failure)

func qte_sequence_success() -> void:
	#print(self, " QTE success")
	speed = max_speed
	qte_sequence.queue_free()

func qte_sequence_failure() -> void:
	#print(self, " QTE failed")
	speed = max_speed * 0.5
	qte_sequence.queue_free()


