extends CanvasLayer

@export var chrono_precision : int = 1
@export var curr_driver : Driver
@export var driver_template : PackedScene

@onready var chrono_label = %ChronoVal

@onready var countdown_place = %Countdown
@onready var countdown_label = %CountdownLabel

@onready var driver_place = %DriverPlace

var countdown : int

# Called when the node enters the scene tree for the first time.
func _ready():
	#countdown
	countdown_place.visible = true
	countdown = Race.countdown_timer.time_left
	Race.lap_finished.connect(on_lap_finished)
	
	chrono_label.text = chrono_to_string(curr_driver.chrono, chrono_precision)
	
	init_drivers()
	

func init_drivers() -> void:
	for driver in Race.leaderboard:
		var new_driver = driver_template.instantiate()
		driver_place.add_child(new_driver)
		new_driver.set_meta("ranking", driver.ranking)
		new_driver.set_meta("car", driver.car_data.sprite_small)
		new_driver.set_meta("name", driver.driver_name)
		new_driver.set_meta("chrono", driver.chrono)
		new_driver.load_data()
		if driver == curr_driver:
			print("it's you")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	chrono_label.text = chrono_to_string(curr_driver.chrono, chrono_precision)
		
	if Race.countdown_timer.time_left > 0 and countdown_place.visible ==true:
		
		countdown = Race.countdown_timer.time_left - delta
		if countdown != 0:
			countdown_label.text = str(countdown)
		else:
			countdown_label.text = "START"
			countdown_end()

func chrono_to_string(chrono:float, precision:int) -> String:
	var min : int = int(chrono/60)
	var sec : float = float(chrono - (min*60))
	
	if min <= 0:
		return str(sec).pad_decimals(precision)
	
	return str(min) + ":" + str(sec).pad_decimals(precision)
	

func countdown_end() -> void:
	await get_tree().create_timer(.5).timeout
	countdown_place.visible = false
	
func on_lap_finished() -> void:
	Race.general_lap += 1
	
