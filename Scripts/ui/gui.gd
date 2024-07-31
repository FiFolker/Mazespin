extends CanvasLayer

@export var chrono_precision : int = 1
@export var driver_template : PackedScene

@onready var chrono_label = %ChronoVal
@onready var best_chrono = %BestChrono

@onready var countdown_place = %Countdown
@onready var countdown_label = %CountdownLabel

@onready var laps_label = %LapsLabel

@onready var driver_place : VBoxContainer = %DriverPlace

var countdown : int
var max_laps_str : String

# Called when the node enters the scene tree for the first time.
func _ready():
	#countdown
	countdown_place.visible = true
	countdown = Race.countdown
	
	Race.lap_finished.connect(on_lap_finished)
	
	CurrentDriver.driver.new_best_lap.connect(_on_new_best_lap)
	best_chrono.visible = true
	
	chrono_label.text = Race.chrono_to_string(CurrentDriver.driver.lap_chrono, chrono_precision)
	max_laps_str = " lap" if Race.max_laps == -1 else "/"+str(Race.max_laps)
	laps_label.text = str(Race.general_lap)+max_laps_str
	init_drivers()
	

func init_drivers() -> void:
	for driver in Race.leaderboard:
		var new_driver = driver_template.instantiate()
		new_driver.name = driver.driver_name
		driver_place.add_child(new_driver)
		new_driver.load_data(driver)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	chrono_label.text = Race.chrono_to_string(CurrentDriver.driver.lap_chrono, chrono_precision)
		
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
	laps_label.text = str(Race.general_lap)+max_laps_str
	
func _on_new_best_lap() -> void:
	best_chrono.visible = true
	best_chrono.text = "Best : "+ Race.chrono_to_string(CurrentDriver.driver.best_lap, chrono_precision)

