extends CanvasLayer

@export var chrono_precision : int = 1
@export var driver_template : PackedScene

@onready var chrono_label = %ChronoVal

@onready var countdown_place = %Countdown
@onready var countdown_label = %CountdownLabel

@onready var driver_place : VBoxContainer = %DriverPlace

var countdown : int

# Called when the node enters the scene tree for the first time.
func _ready():
	#countdown
	countdown_place.visible = true
	countdown = int(Race.countdown_timer.time_left)
	Race.lap_finished.connect(on_lap_finished)
	
	chrono_label.text = Race.chrono_to_string(CurrentDriver.chrono, chrono_precision)
	
	init_drivers()
	

func init_drivers() -> void:
	for driver in Race.leaderboard:
		var new_driver = driver_template.instantiate()
		new_driver.name = driver.driver_name
		driver_place.add_child(new_driver)
		new_driver.load_data(driver)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	chrono_label.text = Race.chrono_to_string(CurrentDriver.chrono, chrono_precision)
		
	if Race.countdown_timer.time_left > 0 and countdown_place.visible ==true:
		
		countdown = int(Race.countdown_timer.time_left - delta)
		if countdown != 0:
			countdown_label.text = str(countdown)
		else:
			countdown_label.text = "START"
			countdown_end()
	

func countdown_end() -> void:
	await get_tree().create_timer(.5).timeout
	countdown_place.visible = false
	
func on_lap_finished() -> void:
	Race.general_lap += 1
	
